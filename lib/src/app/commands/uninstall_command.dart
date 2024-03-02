import 'package:dvmx/dvmx.dart';
import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/uninstall_command_service.dart';
import 'package:dvmx/src/features/sdk/models/sdk_version.dart';

const _allFlagKey = 'all';

final class UninstallCommand extends AppCommand {
  UninstallCommand() {
    argParser.addFlag(
      _allFlagKey,
      abbr: 'a',
      help: 'Uninstall all Dart SDKs.',
      negatable: false,
    );
  }

  @override
  final name = 'uninstall';

  @override
  final description = 'Uninstall Dart SDKs.';

  @override
  String get invocation => 'dvm uninstall <version> or dvm uninstall --all. If '
      'both the `<version>` and the `--all` option are specified, the `--all` '
      'option takes precedence.';

  @override
  List<String> get aliases => ['uni'];

  @override
  Future<ExitStatus> run() async {
    final uninstallCommandService =
        appContainer.read(uninstallCommandServiceProvider);

    final isAll = argResults.wasParsed(_allFlagKey);
    if (isAll) {
      return uninstallCommandService.call(isAll: true);
    }

    final version = argResults.rest.firstOrNull;
    final sdkVersion = switch (version) {
      null => null,
      _ => () {
          try {
            return SdkVersion.fromString(version);
          } on FormatException catch (e) {
            usageException('Invalid version: $version\n${e.message}');
          }
        }(),
    };
    return uninstallCommandService.call(version: sdkVersion);
  }
}
