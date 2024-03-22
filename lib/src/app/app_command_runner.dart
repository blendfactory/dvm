import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/commands/dart_command.dart';
import 'package:dvmx/src/app/commands/install_command.dart';
import 'package:dvmx/src/app/commands/list_command.dart';
import 'package:dvmx/src/app/commands/uninstall_command.dart';
import 'package:dvmx/src/app/commands/use_command.dart';
import 'package:dvmx/src/app/gen/cli_info.dart';
import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:mason_logger/mason_logger.dart';

/// A command runner for the DVM.
final class AppCommandRunner extends CommandRunner<ExitStatus> {
  /// Creates a new instance of [AppCommandRunner].
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
    addCommand(InstallCommand());
    addCommand(UseCommand());
    addCommand(DartCommand());
    addCommand(ListCommand());
    addCommand(UninstallCommand());
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
            loggerProvider.overrideWithValue(
              Logger(
                level: Level.verbose,
              ),
            ),
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
    _consoleService.info(cliInfo.version);
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
