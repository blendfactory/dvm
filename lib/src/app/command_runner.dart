import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dvm/src/app/gen/cli_info.g.dart';
import 'package:dvm/src/app/models/exit_status.dart';

final class DvmCommandRunner extends CommandRunner<ExitStatus> {
  DvmCommandRunner()
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
  }

  @override
  Future<ExitStatus> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);
      if (argResults.existsVersionFlag) {
        print(cliInfo.version);
        return ExitStatus.success;
      }
      return await runCommand(argResults) ?? ExitStatus.success;
    } on UsageException catch (_) {
      return ExitStatus.usage;
    } on Exception catch (_) {
      return ExitStatus.error;
    }
  }
}

extension _ExistsVersionFlag on ArgResults {
  bool get existsVersionFlag => wasParsed('version');
}
