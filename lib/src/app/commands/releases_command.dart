import 'package:args/command_runner.dart';
import 'package:dvm/src/app/command_services/releases_command_services.dart';
import 'package:dvm/src/app/models/exit_status.dart';
import 'package:dvm/src/features/sdk/models/sdk_channel.dart';
import 'package:riverpod/riverpod.dart';

class ReleasesCommand extends Command<ExitStatus> {
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
  Future<ExitStatus> run() async {
    final channel = argResults!['channel'] as String;
    final sdkChannel = SdkChannel.values.byName(channel);

    final container = ProviderContainer();
    final releasesCommandService =
        container.read(releasesCommandServiceProvider);

    return releasesCommandService.call(channel: sdkChannel);
  }
}