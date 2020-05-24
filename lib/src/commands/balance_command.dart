import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:labcoin_sdk/labcoin_sdk.dart';

class BalanceCommand extends Command {
  @override
  String get name => 'balance';

  @override
  String get description => 'Get the Balance of an address';

  BalanceCommand() {
    argParser.addMultiOption('address', abbr: 'a', help: 'Show the balance one or more address');
    argParser.addOption('export', abbr: 'e', help: 'Export the balance or balances to a json file', valueHelp: 'output.json');
  }

  @override
  Future run() async {
    var labcoinUri = LabcoinUri(globalResults['node']);
    var labcoinClient = LabcoinClient(labcoinUri);
    if (argResults['address'].isNotEmpty) {
      var results = <Map<String, dynamic>>[];
      for(var address in argResults['address']) {
        var result = await labcoinClient.getAddress(address);
        results.add({
          'address': result.address,
          'funds': result.funds
        });
      }
      for (var result in results) {
        print('${result['address']}: ${result['funds']}');
      }
      if(argResults['export'] != null) {
        var exportFile = File(argResults['export']);

        if (!exportFile.existsSync()) exportFile.createSync(recursive: true);

        exportFile.writeAsStringSync(jsonEncode(results));
      }
    } else {
      print('Please define one ore more address');
      exit(1);
    }
  }
}