import 'package:dvm/src/app/app_commnad.dart';
import 'package:dvm/src/app/app_container.dart';
import 'package:dvm/src/app/command_services/releases_command_services.dart';
import 'package:dvm/src/app/models/exit_status.dart';
import 'package:dvm/src/features/sdk/models/sdk_channel.dart';

final class ReleasesCommand extends AppCommand {
  ReleasesCommand() {
    argParser.addOption(
      'channel',
      help: 'Filter by channel name',
      abbr: 'c',
      allowed: SdkChannel.values.map((c) => c.name),
      defaultsTo: SdkChannel.stable.name,
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
    final channel = argResults['channel'] as String;
    final sdkChannel = SdkChannel.values.byName(channel);

    final releasesCommandService =
        appContainer.read(releasesCommandServiceProvider);

    return releasesCommandService.call(channel: sdkChannel);
  }
}
