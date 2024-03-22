import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/cores/models/channel_option.dart';
import 'package:dvmx/src/features/sdk/services/sdk_service.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_command_service.g.dart';

@Riverpod(
  dependencies: [
    sdkService,
    consoleService,
  ],
)
ListCommandService listCommandService(
  ListCommandServiceRef ref,
) {
  final sdkService = ref.watch(sdkServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  return ListCommandService(
    sdkService: sdkService,
    consoleService: consoleService,
  );
}

final class ListCommandService {
  ListCommandService({
    required SdkService sdkService,
    required ConsoleService consoleService,
  })  : _sdkService = sdkService,
        _consoleService = consoleService;

  final SdkService _sdkService;
  final ConsoleService _consoleService;

  Future<ExitStatus> call({
    required ChannelOption channelOption,
    required bool isLatest,
  }) async {
    final channel = channelOption.toSdkChannelOrNull();
    try {
      final versions = await _sdkService.getInstalledSdks(channel: channel);
      if (versions.isEmpty) {
        _consoleService.warning('No SDKs installed.');
        return ExitStatus.success;
      }

      if (isLatest) {
        final latestVersion = versions.last;
        _consoleService.info(latestVersion.toString());
        return ExitStatus.success;
      }

      for (final version in versions) {
        _consoleService.info(version.toString());
      }
      return ExitStatus.success;
    } on ClientException catch (e) {
      _consoleService.error(e.toString());
      return ExitStatus.error;
    }
  }
}
