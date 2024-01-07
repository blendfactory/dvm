import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dvm/src/app/commands/releases_command.dart';
import 'package:dvm/src/app/gen/cli_info.g.dart';
import 'package:dvm/src/app/models/exit_status.dart';
import 'package:dvm/src/app/servicies/console_service.dart';

final class DvmCommandRunner extends CommandRunner<ExitStatus> {
  DvmCommandRunner([
    this._consoleService = const ConsoleService(),
  ]) : super(
          cliInfo.name,
          cliInfo.description,
        ) {
    argParser.addFlag(
      'version',
      abbr: 'v',
      help: 'Print this cli version.',
      negatable: false,
    );
    addCommand(ReleasesCommand());
  }

  final ConsoleService _consoleService;

  @override
  Future<ExitStatus> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);
      if (argResults.existsVersionFlag) {
        print(cliInfo.version);
        return ExitStatus.success;
      }
      return await runCommand(argResults) ?? ExitStatus.success;
    } on UsageException catch (e) {
      _printUsageException(e);
      return ExitStatus.usage;
    } on Exception catch (e) {
      _printException(e);
      return ExitStatus.error;
    }
  }

  void _printUsageException(UsageException e) {
    _consoleService.spacer();
    _consoleService.warning(e.message);
    _consoleService.spacer();
    _consoleService.info(e.usage);
    _consoleService.spacer();
  }

  void _printException(Exception e) {
    _consoleService.spacer();
    _consoleService.error(e.toString());
    _consoleService.spacer();
  }
}

extension _ExistsVersionFlag on ArgResults {
  bool get existsVersionFlag => wasParsed('version');
}
