import 'package:dvmx/dvmx.dart';
import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/use_command_service.dart';
import 'package:dvmx/src/features/sdk/models/sdk_version.dart';

final class UseCommand extends AppCommand {
  UseCommand();

  @override
  final name = 'use';

  @override
  final description = 'Set a Dart SDK version to use in a project.';

  @override
  String get invocation => 'dvm use <version>. If no <version>'
      ' is specified, the version configured in project is set.';

  @override
  List<String> get aliases => ['u'];

  @override
  Future<ExitStatus> run() async {
    final version = argResults.rest.firstOrNull;
    final SdkVersion? sdkVersion;
    if (version == null) {
      sdkVersion = null;
    } else {
      try {
        sdkVersion = SdkVersion.fromString(version);
      } on FormatException catch (e) {
        usageException(e.message);
      }
    }

    final useCommandService = appContainer.read(useCommandServiceProvider);

    return useCommandService.call(
      version: sdkVersion,
      throwUsageException: usageException,
    );
  }
}
