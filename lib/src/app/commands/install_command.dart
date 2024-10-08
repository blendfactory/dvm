import 'package:dvmx/dvmx.dart';
import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/install_command_service.dart';
import 'package:dvmx/src/cores/models/sdk_channel.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';

const _latestKey = 'latest';
const _channelKey = 'channel';

final class InstallCommand extends AppCommand {
  InstallCommand() {
    argParser.addFlag(
      _latestKey,
      abbr: 'l',
      help:
          '''Install the latest release. This option takes precedence even if a version is specified.''',
      negatable: false,
    );
    argParser.addOption(
      _channelKey,
      abbr: 'c',
      help:
          '''Used only if the `latest` option is specified. Specifies from which channel the latest release is installed.''',
      allowed: SdkChannel.values.map((c) => c.name),
      defaultsTo: SdkChannel.stable.name,
    );
  }

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

    final channel = argResults.option(_channelKey)!;
    final sdkChannel = SdkChannel.values.byName(channel);
    final isLatest = argResults.flag(_latestKey);

    final installCommandService =
        appContainer.read(installCommandServiceProvider);

    return installCommandService.call(
      version: sdkVersion,
      latestOptions: (
        isLatest: isLatest,
        channel: sdkChannel,
      ),
      throwUsageException: usageException,
    );
  }
}
