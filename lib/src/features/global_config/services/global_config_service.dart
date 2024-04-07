import 'dart:convert';

import 'package:dvmx/src/cores/local/global_root_dir.dart';
import 'package:dvmx/src/cores/local/sdk_cache_dir.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';
import 'package:dvmx/src/features/global_config/models/global_config.dart';
import 'package:dvmx/src/features/global_config/models/global_config_status.dart';
import 'package:file/file.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_config_service.g.dart';

@Riverpod(
  dependencies: [
    globalRootDir,
  ],
)
Directory globalConfigDir(GlobalConfigDirRef ref) {
  final globalRootDir = ref.watch(globalRootDirProvider);
  return globalRootDir.childDirectory('default');
}

@Riverpod(
  dependencies: [
    globalConfigDir,
    sdkCacheDir,
  ],
)
GlobalConfigService globalConfigService(
  GlobalConfigServiceRef ref,
) {
  final globalConfigDir = ref.watch(globalConfigDirProvider);
  final sdkCacheDir = ref.watch(sdkCacheDirProvider);
  return GlobalConfigService(
    globalConfigDir: globalConfigDir,
    sdkCacheDir: sdkCacheDir,
  );
}

final class GlobalConfigService {
  GlobalConfigService({
    required Directory globalConfigDir,
    required Directory sdkCacheDir,
  })  : _globalConfigDir = globalConfigDir,
        _sdkCacheDir = sdkCacheDir;

  final Directory _globalConfigDir;
  final Directory _sdkCacheDir;

  GlobalConfig? findGlobalConfig() {
    final globalConfigFile = _globalConfigDir.childFile('config.json');
    if (!globalConfigFile.existsSync()) {
      return null;
    }

    try {
      final fileContent = globalConfigFile.readAsStringSync();
      final json = jsonDecode(fileContent) as Map<String, dynamic>;
      return GlobalConfig.fromJson(json);
    } on FormatException catch (_) {
      return null;
    } on CheckedFromJsonException catch (_) {
      return null;
    }
  }

  SdkVersion? findGlobalSdkVersion() {
    final globalConfig = findGlobalConfig();
    return globalConfig?.version;
  }

  void updateSettings(SdkVersion version) {
    final sdkLink = _globalConfigDir.childLink('dart_sdk');
    final targetPath = _sdkCacheDir.childDirectory(version.toString()).path;
    if (sdkLink.existsSync()) {
      sdkLink.updateSync(targetPath);
    } else {
      sdkLink.createSync(targetPath, recursive: true);
    }

    final globalConfigFile = _globalConfigDir.childFile('config.json');
    if (!globalConfigFile.existsSync()) {
      globalConfigFile.createSync(recursive: true);
    }
    final globalConfig = GlobalConfig(version: version);
    const prettyEncoder = JsonEncoder.withIndent('  ');
    final globalConfigContent = prettyEncoder.convert(globalConfig.toJson());
    globalConfigFile.writeAsStringSync('$globalConfigContent\n');
  }

  GlobalConfigStatus checkGlobalConfig() {
    final globalConfigFile = _globalConfigDir.childFile('config.json');
    if (!globalConfigFile.existsSync()) {
      return GlobalConfigStatus.notFound();
    }

    try {
      final fileContent = globalConfigFile.readAsStringSync();
      final json = jsonDecode(fileContent) as Map<String, dynamic>;
      final globalConfig = GlobalConfig.fromJson(json);
      return GlobalConfigStatus.found(globalConfig);
    } on FormatException catch (e) {
      return GlobalConfigStatus.jsonFormatError(e);
    } on CheckedFromJsonException catch (e) {
      return GlobalConfigStatus.paramFormatError(e);
    } on Exception catch (e) {
      return GlobalConfigStatus.unknownError(e);
    }
  }
}
