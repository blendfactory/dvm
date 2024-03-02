import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/releases_command_services.dart';
import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/features/sdk/models/sdk_channel.dart';

const _channelKey = 'channel';
const _latestKey = 'latest';

final class ReleasesCommand extends AppCommand {
  ReleasesCommand() {
    argParser.addOption(
      _channelKey,
      abbr: 'c',
      help: 'Filter by channel name.',
      allowed: SdkChannel.values.map((c) => c.name),
      defaultsTo: SdkChannel.stable.name,
    );
    argParser.addFlag(
      _latestKey,
      abbr: 'l',
      help: 'Show only the latest release.',
      negatable: false,
    );
  }

  @override
  final name = 'releases';

  @override
  final description = 'Show available Dart SDK releases.';

  @override
  List<String> get aliases => ['r'];

  @override
  Future<ExitStatus> run() async {
    final channel = argResults[_channelKey] as String;
    final sdkChannel = SdkChannel.values.byName(channel);
    final isLatest = argResults.wasParsed(_latestKey);

    final releasesCommandService =
        appContainer.read(releasesCommandServiceProvider);

    return releasesCommandService.call(
      channel: sdkChannel,
      isLatest: isLatest,
    );
  }
}
