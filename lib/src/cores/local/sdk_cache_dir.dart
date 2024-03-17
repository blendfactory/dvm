import 'package:dvmx/src/cores/local/dvm_home_dir.dart';
import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sdk_cache_dir.g.dart';

@Riverpod(
  dependencies: [
    dvmHomeDir,
  ],
)
Directory sdkCacheDir(SdkCacheDirRef ref) {
  final dvmHomeDir = ref.watch(dvmHomeDirProvider);
  return dvmHomeDir.childDirectory('cache/versions');
}
