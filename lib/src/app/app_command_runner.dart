import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:dvm/src/app/app_container.dart';
import 'package:dvm/src/app/commands/releases_command.dart';
import 'package:dvm/src/app/gen/cli_info.g.dart';
import 'package:dvm/src/app/models/exit_status.dart';
import 'package:dvm/src/app/servicies/console_service.dart';

final class AppCommandRunner extends CommandRunner<ExitStatus> {
  AppCommandRunner()
      : super(
          cliInfo.name,
          cliInfo.description,
        ) {
    argParser.addFlag(
      'version',
      abbr: 'v',
      help: 'Print this cli version.',
      negatable: false,
    );
    argParser.addFlag(
      'verbose',
      help: 'Print verbose output.',
      negatable: false,
    );
    addCommand(ReleasesCommand());
  }

  ConsoleService get _consoleService =>
      appContainer.read(consoleServiceProvider);

  @override
  Future<ExitStatus> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);
      if (argResults.existsVersionFlag) {
        _printCliVersion();
        return ExitStatus.success;
      }
      if (argResults.existsVerboseFlag) {
        appContainer.updateOverrides(
          [
            loggerProvider.overrideWithValue(Logger.verbose()),
          ],
        );
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

  void _printCliVersion() {
    _consoleService.spacer();
    _consoleService.info(cliInfo.version);
    _consoleService.spacer();
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

extension _ExistsFlag on ArgResults {
  bool get existsVersionFlag => wasParsed('version');

  bool get existsVerboseFlag => wasParsed('verbose');
}
