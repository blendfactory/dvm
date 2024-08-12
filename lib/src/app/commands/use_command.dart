import 'package:dvmx/dvmx.dart';
import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/use_command_service.dart';
import 'package:dvmx/src/cores/models/sdk_channel.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';

const _latestKey = 'latest';
const _channelKey = 'channel';
const _globalKey = 'global';

final class UseCommand extends AppCommand {
  UseCommand() {
    argParser.addFlag(
      _latestKey,
      abbr: 'l',
      help:
          '''Use the latest release. This option takes precedence even if a version is specified.''',
      negatable: false,
    );
    argParser.addOption(
      _channelKey,
      abbr: 'c',
      help:
          '''Used only if the `latest` option is specified. Specifies from which channel the latest release is used.''',
      allowed: SdkChannel.values.map((c) => c.name),
      defaultsTo: SdkChannel.stable.name,
    );
    argParser.addFlag(
      _globalKey,
      abbr: 'g',
      help: 'Sets the Dart SDK as a global.',
      negatable: false,
    );
  }

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

    final channel = argResults.option(_channelKey)!;
    final sdkChannel = SdkChannel.values.byName(channel);
    final isLatest = argResults.flag(_latestKey);

    final isGlobal = argResults.flag(_globalKey);

    final useCommandService = appContainer.read(useCommandServiceProvider);

    return useCommandService.call(
      version: sdkVersion,
      latestOptions: (
        isLatest: isLatest,
        channel: sdkChannel,
      ),
      isGlobal: isGlobal,
      throwUsageException: usageException,
    );
  }
}
