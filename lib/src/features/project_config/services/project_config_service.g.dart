// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'project_config_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectConfigDirHash() => r'5091c316ac70a65f6b9cea2002d345fbb4d05e84';

/// See also [projectConfigDir].
@ProviderFor(projectConfigDir)
final projectConfigDirProvider = AutoDisposeProvider<Directory>.internal(
  projectConfigDir,
  name: r'projectConfigDirProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectConfigDirHash,
  dependencies: <ProviderOrFamily>[isDebugProvider, fileSystemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    isDebugProvider,
    ...?isDebugProvider.allTransitiveDependencies,
    fileSystemProvider,
    ...?fileSystemProvider.allTransitiveDependencies
  },
);

typedef ProjectConfigDirRef = AutoDisposeProviderRef<Directory>;
String _$projectConfigServiceHash() =>
    r'fed2cde06832f67d0aad2b2c5515855c5109f058';

/// See also [projectConfigService].
@ProviderFor(projectConfigService)
final projectConfigServiceProvider =
    AutoDisposeProvider<ProjectConfigService>.internal(
  projectConfigService,
  name: r'projectConfigServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectConfigServiceHash,
  dependencies: <ProviderOrFamily>[projectConfigDirProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    projectConfigDirProvider,
    ...?projectConfigDirProvider.allTransitiveDependencies
  },
);

typedef ProjectConfigServiceRef = AutoDisposeProviderRef<ProjectConfigService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
