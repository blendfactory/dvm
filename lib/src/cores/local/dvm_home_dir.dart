import 'package:dvmx/src/cores/local/home_dir.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dvm_home_dir.g.dart';

@Riverpod(
  dependencies: [
    homeDir,
  ],
)
Directory dvmHomeDir(DvmHomeDirRef ref) {
  final homeDir = ref.watch(homeDirProvider);
  return homeDir.childDirectory('.dvm');
}
