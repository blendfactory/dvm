import 'dart:convert';

import 'package:dvm/src/cores/local/file_system.dart';
import 'package:dvm/src/cores/local/is_debug.dart';
import 'package:dvm/src/features/project_config/models/project_config.dart';
import 'package:dvm/src/features/sdk/models/sdk_version.dart';
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
  ],
)
ProjectConfigService projectConfigService(
  ProjectConfigServiceRef ref,
) {
  final projectConfigDir = ref.watch(projectConfigDirProvider);
  return ProjectConfigService(
    projectConfigDir: projectConfigDir,
  );
}

final class ProjectConfigService {
  ProjectConfigService({
    required Directory projectConfigDir,
  }) : _projectConfigDir = projectConfigDir;

  final Directory _projectConfigDir;

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
}
