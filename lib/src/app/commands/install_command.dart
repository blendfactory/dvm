import 'package:dvmx/dvmx.dart';
import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/install_command_service.dart';
import 'package:dvmx/src/features/sdk/models/sdk_version.dart';

final class InstallCommand extends AppCommand {
  InstallCommand();

  @override
  final name = 'install';

  @override
  final description = 'Install a Dart SDK.';

  @override
  String get invocation => 'dvm install <version>. If no <version>'
      ' is specified, the version configured in project is installed.';

  @override
  List<String> get aliases => ['i'];

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

    final installCommandService =
        appContainer.read(installCommandServiceProvider);

    return installCommandService.call(
      version: sdkVersion,
      throwUsageException: usageException,
    );
  }
}
