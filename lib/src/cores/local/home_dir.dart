import 'dart:io' show Platform;

import 'package:dvmx/src/cores/local/development_dir.dart';
import 'package:dvmx/src/cores/local/file_system.dart';
import 'package:dvmx/src/cores/local/is_debug.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_dir.g.dart';

@Riverpod(
  dependencies: [
    isDebug,
    developmentDir,
    fileSystem,
  ],
)
Directory homeDir(HomeDirRef ref) {
  final isDebug = ref.watch(isDebugProvider);
  final developmentDir = ref.watch(developmentDirProvider);
  final fileSystem = ref.watch(fileSystemProvider);

  if (isDebug) {
    return developmentDir.childDirectory('home');
  } else {
    final userHomePath = Platform.isWindows
        ? Platform.environment['USERPROFILE']!
        : Platform.environment['HOME']!;
    return fileSystem.directory(userHomePath);
  }
}
