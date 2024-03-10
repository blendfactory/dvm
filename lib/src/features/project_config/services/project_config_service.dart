import 'dart:convert';

import 'package:dvmx/src/cores/local/file_system.dart';
import 'package:dvmx/src/cores/local/is_debug.dart';
import 'package:dvmx/src/cores/local/sdk_cache_dir.dart';
import 'package:dvmx/src/cores/models/sdk_version.dart';
import 'package:dvmx/src/features/project_config/models/project_config.dart';
import 'package:file/file.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_config_service.g.dart';

@Riverpod(
  dependencies: [
    isDebug,
    fileSystem,
  ],
)
Directory projectConfigDir(ProjectConfigDirRef ref) {
  final isDebug = ref.watch(isDebugProvider);
  final fileSystem = ref.watch(fileSystemProvider);
  final projectConfigDirName = isDebug ? '.build' : '.dvm';
  return fileSystem.currentDirectory.childDirectory(projectConfigDirName);
}

@Riverpod(
  dependencies: [
    projectConfigDir,
    sdkCacheDir,
  ],
)
ProjectConfigService projectConfigService(
  ProjectConfigServiceRef ref,
) {
  final projectConfigDir = ref.watch(projectConfigDirProvider);
  final sdkCacheDir = ref.watch(sdkCacheDirProvider);
  return ProjectConfigService(
    projectConfigDir: projectConfigDir,
    sdkCacheDir: sdkCacheDir,
  );
}

final class ProjectConfigService {
  ProjectConfigService({
    required Directory projectConfigDir,
    required Directory sdkCacheDir,
  })  : _projectConfigDir = projectConfigDir,
        _sdkCacheDir = sdkCacheDir;

  final Directory _projectConfigDir;
  final Directory _sdkCacheDir;

  ProjectConfig? findProjectConfig() {
    final projectConfigFile = _projectConfigDir.childFile('config.json');
    if (!projectConfigFile.existsSync()) {
      return null;
    }

    try {
      final fileContent = projectConfigFile.readAsStringSync();
      final json = jsonDecode(fileContent) as Map<String, dynamic>;
      return ProjectConfig.fromJson(json);
    } on FormatException catch (_) {
      return null;
    } on CheckedFromJsonException catch (_) {
      return null;
    }
  }

  SdkVersion? findProjectSdkVersion() {
    final projectConfig = findProjectConfig();
    return projectConfig?.version;
  }

  void updateSettings(SdkVersion version) {
    final sdkLink = _projectConfigDir.childLink('dart_sdk');
    final targetPath = _sdkCacheDir.childDirectory(version.toString()).path;
    if (sdkLink.existsSync()) {
      sdkLink.updateSync(targetPath);
    } else {
      sdkLink.createSync(targetPath, recursive: true);
    }

    final projectConfigFile = _projectConfigDir.childFile('config.json');
    if (!projectConfigFile.existsSync()) {
      projectConfigFile.createSync(recursive: true);
    }
    final projectConfig = ProjectConfig(version: version);
    const prettyEncoder = JsonEncoder.withIndent('  ');
    final projectConfigContent = prettyEncoder.convert(projectConfig.toJson());
    projectConfigFile.writeAsStringSync('$projectConfigContent\n');

    final ignoreFile = _projectConfigDir.childFile('.gitignore');
    if (!ignoreFile.existsSync()) {
      ignoreFile.createSync(recursive: true);
    }
    final ignoreFileContent = '${sdkLink.basename}\n';
    ignoreFile.writeAsStringSync(ignoreFileContent);
  }
}
