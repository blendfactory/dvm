import 'dart:io';

import 'package:dvmx/src/cores/local/sdk_cache_dir.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dart_service.g.dart';

@Riverpod(
  dependencies: [
    sdkCacheDir,
  ],
)
DartService dartService(
  DartServiceRef ref,
) {
  final sdkCacheDir = ref.watch(sdkCacheDirProvider);
  return DartService(
    sdkCacheDir: sdkCacheDir,
  );
}

final class DartService {
  DartService({
    required Directory sdkCacheDir,
  }) : _sdkCacheDir = sdkCacheDir;

  final Directory _sdkCacheDir;

  Future<ProcessResult> runWithVersion({
    required SdkVersion version,
    required List<String> args,
  }) async {
    final versionCacheDir = _sdkCacheDir.childDirectory(version.toString());

    final dartBinDir = versionCacheDir.childDirectory('bin');
    final dartExecutableFileName = Platform.isWindows ? 'dart.bat' : 'dart';
    final dartExecutableFile = dartBinDir.childFile(dartExecutableFileName);
    if (!dartExecutableFile.existsSync()) {
      throw Exception('Not found dart executable file.');
    }

    return Process.run(
      dartExecutableFile.path,
      args,
    );
  }
}
