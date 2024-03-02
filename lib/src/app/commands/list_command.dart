import 'package:dvmx/src/app/app_commnad.dart';
import 'package:dvmx/src/app/app_container.dart';
import 'package:dvmx/src/app/command_services/list_command_service.dart';
import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/features/sdk/models/sdk_channel.dart';

final class ListCommand extends AppCommand {
  ListCommand() {
    argParser.addOption(
      'channel',
      abbr: 'c',
      help: 'Filter by channel name',
      allowed: SdkChannel.values.map((c) => c.name),
    );
  }

  @override
  final name = 'list';

  @override
  final description = 'Display the installed Dart SDK versions.';

  @override
  List<String> get aliases => ['l'];

  @override
  Future<ExitStatus> run() async {
    final channel = argResults['channel'] as String?;
    final sdkChannel = switch (channel) {
      null => null,
      final c => SdkChannel.values.byName(c),
    };

    final listCommandService = appContainer.read(listCommandServiceProvider);

    return listCommandService.call(channel: sdkChannel);
  }
}
