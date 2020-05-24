import 'package:args/command_runner.dart';
import 'package:labwallet/src/commands/balance_command.dart';
import 'package:labwallet/src/commands/create_command.dart';
import 'package:labwallet/src/commands/transact_command.dart';

CommandRunner getCommandRunner() {
  var commandRunner = CommandRunner('labwallet', 'A Labcoin Wallet CLI')
      ..argParser.addOption('node', abbr: 'n', help: 'The Labcoin Node you\'d like to use', defaultsTo: 'konstantinullrich.de:8081', valueHelp: 'hostname:port')
      ..addCommand(CreateCommand())
      ..addCommand(TransactCommand())
      ..addCommand(BalanceCommand());

  return commandRunner;
}