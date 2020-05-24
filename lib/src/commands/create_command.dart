
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:args/command_runner.dart';
import 'package:labcoin_sdk/labcoin_sdk.dart';

import 'package:labwallet/src/utils/pemhelper.dart';

class CreateCommand extends Command {
  @override
  String get name => 'create';

  @override
  String get description => 'Create a new Wallet';

  CreateCommand() {
    argParser.addOption('out', abbr: 'o', valueHelp: 'path', help: 'Define the output folder for the generate Wallet', defaultsTo: './wallet');
    argParser.addFlag('asJson', help: 'Save the wallet as a single Json file');
  }

  @override
  void run() {
    var wallet = Wallet.fromRandom();

    if (argResults['out'] != null) {
      var directory = Directory(argResults['out']);

      if (!directory.existsSync()) directory.createSync(recursive: true);

      var walletName = crypto.sha1.convert(utf8.encode(wallet.publicKey.toString())).toString();

      if (argResults['asJson']) {
        var walletFile = File('${directory.path}/${walletName}.json');
        var walletObject = <String, String>{};

        walletObject['privateKey'] = wallet.privateKey.toString();
        walletObject['publicKey'] = wallet.publicKey.toString();

        if (!walletFile.existsSync()) walletFile.createSync(recursive: true);

        walletFile.writeAsStringSync(jsonEncode(walletObject));
      } else {
        var publicKey = File('${directory.path}/${walletName}.pub');
        var privateKey = File('${directory.path}/${walletName}');

        if (!publicKey.existsSync()) publicKey.createSync();
        if (!privateKey.existsSync()) privateKey.createSync();

        publicKey.writeAsStringSync(encodePublicKeyToPem(wallet.publicKey));
        privateKey.writeAsStringSync(encodePrivateKeyToPem(wallet.privateKey));
      }
    } else {
      print('please specify an output folder');
    }
  }
}