import 'package:dvmx/src/app/models/exit_status.dart';
import 'package:dvmx/src/app/servicies/console_service.dart';
import 'package:dvmx/src/features/sdk/models/sdk_channel.dart';
import 'package:dvmx/src/features/sdk/services/sdk_service.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'releases_command_services.g.dart';

@Riverpod(
  dependencies: [
    sdkService,
    consoleService,
  ],
)
ReleasesCommandService releasesCommandService(
  ReleasesCommandServiceRef ref,
) {
  final sdkService = ref.watch(sdkServiceProvider);
  final consoleService = ref.watch(consoleServiceProvider);
  return ReleasesCommandService(
    sdkService: sdkService,
    consoleService: consoleService,
  );
}

final class ReleasesCommandService {
  ReleasesCommandService({
    required SdkService sdkService,
    required ConsoleService consoleService,
  })  : _sdkService = sdkService,
        _consoleService = consoleService;

  final SdkService _sdkService;
  final ConsoleService _consoleService;

  Future<ExitStatus> call({
    required SdkChannel channel,
    required bool isLatest,
  }) async {
    try {
      if (isLatest) {
        final version = await _sdkService.getLatestSdk(channel: channel);
        _consoleService.info(version.toString());
        return ExitStatus.success;
      }

      final versions = await _sdkService.getSdks(channel: channel);
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
