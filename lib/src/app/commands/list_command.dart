import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/list_command_service.dart';
import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/cores/models/channel_option.dart';

const _channelKey = 'channel';
const _latestKey = 'latest';

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
      help: 'Display only the latest installed Dart SDK version.',
      negatable: false,
    );
  }

  @override
  final name = 'list';

  @override
  final description = 'Display the installed Dart SDK versions.';

  @override
  List<String> get aliases => ['ls'];

  @override
  Future<ExitStatus> run() async {
    final channelValue = argResults[_channelKey] as String;
    final channelOption = ChannelOption.byValue(channelValue);

    final isLatest = argResults.wasParsed(_latestKey);

    final listCommandService = appContainer.read(listCommandServiceProvider);

    return listCommandService.call(channelOption: channelOption);
  }
}
