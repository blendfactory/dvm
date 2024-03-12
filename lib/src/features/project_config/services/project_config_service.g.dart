// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'project_config_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectConfigDirHash() => r'ee9a4a5b45d1b13dfa490bc859ab499c55a3c604';

/// See also [projectConfigDir].
@ProviderFor(projectConfigDir)
final projectConfigDirProvider = AutoDisposeProvider<Directory>.internal(
  projectConfigDir,
  name: r'projectConfigDirProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectConfigDirHash,
  dependencies: <ProviderOrFamily>[projectRootDirProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    projectRootDirProvider,
    ...?projectRootDirProvider.allTransitiveDependencies
  },
);

typedef ProjectConfigDirRef = AutoDisposeProviderRef<Directory>;
String _$projectConfigServiceHash() =>
    r'4fdc5691800200e709ffc436f809371a2d8f4459';

/// See also [projectConfigService].
@ProviderFor(projectConfigService)
final projectConfigServiceProvider =
    AutoDisposeProvider<ProjectConfigService>.internal(
  projectConfigService,
  name: r'projectConfigServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectConfigServiceHash,
  dependencies: <ProviderOrFamily>[
    projectConfigDirProvider,
    sdkCacheDirProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    projectConfigDirProvider,
    ...?projectConfigDirProvider.allTransitiveDependencies,
    sdkCacheDirProvider,
    ...?sdkCacheDirProvider.allTransitiveDependencies
  },
);

typedef ProjectConfigServiceRef = AutoDisposeProviderRef<ProjectConfigService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
