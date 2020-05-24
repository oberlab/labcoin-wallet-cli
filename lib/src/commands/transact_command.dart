import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:labcoin_sdk/labcoin_sdk.dart';

const CSV_DELIMITER = ',';

class TransactCommand extends Command {
  @override
  String get name => 'transact';

  @override
  String get description => 'Create and send a transaction';

  TransactCommand() {
    argParser.addOption('private-key', abbr: 'p', help: 'Your private key used to sign transactions', valueHelp: 'Your private Key');
    argParser.addOption('destination', abbr: 'd', help: 'Defnes where should the amount be send', valueHelp: 'Reciver\'s WalletAddress');
    argParser.addOption('amount', abbr: 'a', help: 'Defnes how much should be spend', valueHelp: 'Amount as integer');
    argParser.addOption('import', abbr: 'e', help: 'Import multiple transactions from a file', valueHelp: 'input.csv');
  }

  @override
  Future run() async {
    var labcoinUri = LabcoinUri(globalResults['node']);
    var labcoinClient = LabcoinClient(labcoinUri);
    if (argResults['private-key'] != null) {

      var wallet = Wallet(argResults['private-key']);
      var transactions = <Transaction>[];

      if (argResults['import'] != null) {
        var inputFile = File(argResults['import']);
        if (inputFile.existsSync()) {
          print('Found an Inputfile, will ignore destination and amount tags');
          var lines = inputFile.readAsStringSync().split('\n');
          for (var line in lines) {
            var lineParts = line.split(CSV_DELIMITER);
            transactions.add(Transaction(
                wallet.publicKey.toString(),
                lineParts[0],
                int.parse(lineParts[1])
            ));
          }
        } else {
          print('The given Path is invalid or the File does not exist!');
          exit(1);
        }
      } else if (argResults['destination'] != null && argResults['amount'] != null) {
        transactions.add(Transaction(
            wallet.publicKey.toString(),
            argResults['destination'] ,
            int.parse(argResults['amount'])
        ));
      } else {
        print('Please define eighter a import or a destination and amount');
        exit(1);
      }
      for (var transaction in transactions) {
        transaction.sign(wallet.privateKey);
        labcoinClient.sendTransaction(transaction);
      }
    } else {
      print('Please define one or more address');
      exit(1);
    }
  }
}