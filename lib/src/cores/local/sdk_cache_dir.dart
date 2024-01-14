import 'dart:io';

import 'package:dvmx/src/cores/local/file_system.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sdk_cache_dir.g.dart';

@Riverpod(
  dependencies: [
    fileSystem,
  ],
)
Directory sdkCacheDir(SdkCacheDirRef ref) {
  final fileSystem = ref.watch(fileSystemProvider);
  final userHome = Platform.isWindows
      ? Platform.environment['USERPROFILE']!
      : Platform.environment['HOME']!;
  return fileSystem.directory('$userHome/.dvm/cache/versions');
}
