import 'package:dvm/src/cores/local/file_system.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'system_temp_dir.g.dart';

@Riverpod(
  dependencies: [
    fileSystem,
  ],
)
Directory systemTempDir(SystemTempDirRef ref) {
  final fileSystem = ref.watch(fileSystemProvider);
  return fileSystem.systemTempDirectory;
}
