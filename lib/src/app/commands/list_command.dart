import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/list_command_service.dart';
import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/cores/models/channel_option.dart';

const _channelKey = 'channel';
const _latestKey = 'latest';
const _remoteKey = 'remote';

final class ListCommand extends AppCommand {
  ListCommand() {
    argParser.addOption(
      _channelKey,
      abbr: 'c',
      help: 'Filter by channel name.',
      allowed: ChannelOption.options.map((c) => c.value),
      defaultsTo: ChannelOption.stable.value,
    );
    argParser.addFlag(
      _latestKey,
      abbr: 'l',
      help: 'Display only the latest Dart SDK version.',
      negatable: false,
    );
    argParser.addFlag(
      _remoteKey,
      abbr: 'r',
      help: 'Display the latest Dart SDK version available remotely.',
      negatable: false,
    );
  }

  @override
  final name = 'list';

  @override
  final description = 'Displays the version of Dart SDK installed locally '
      'or available remotely.';

  @override
  List<String> get aliases => ['ls'];

  @override
  Future<ExitStatus> run() async {
    final channelValue = argResults.option(_channelKey)!;
    final channelOption = ChannelOption.byValue(channelValue);

    final isLatest = argResults.flag(_latestKey);

    final isRemote = argResults.flag(_remoteKey);

    final listCommandService = appContainer.read(listCommandServiceProvider);

    return listCommandService.call(
      channelOption: channelOption,
      isLatest: isLatest,
      isRemote: isRemote,
    );
  }
}
