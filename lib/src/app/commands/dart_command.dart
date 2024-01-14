import 'package:args/args.dart';
import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/dart_command_service.dart';
import 'package:dvmx/src/app/models/exit_status.dart';

final class DartCommand extends AppCommand {
  DartCommand();

  @override
  final name = 'dart';

  @override
  final description = 'Proxy a dart command.';

  @override
  String get invocation => 'dvm dart <args>';

  @override
  List<String> get aliases => ['d'];

  @override
  ArgParser get argParser => ArgParser.allowAnything();

  @override
  Future<ExitStatus> run() async {
    final args = argResults.arguments;

    final dartCommandService = appContainer.read(dartCommandServiceProvider);

    return dartCommandService.call(
      args: args,
      throwUsageException: usageException,
    );
  }
}
