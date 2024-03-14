// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'global_config_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalConfigDirHash() => r'b7298c8d98f7accd68944188c4c02479c65c6660';

/// See also [globalConfigDir].
@ProviderFor(globalConfigDir)
final globalConfigDirProvider = AutoDisposeProvider<Directory>.internal(
  globalConfigDir,
  name: r'globalConfigDirProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalConfigDirHash,
  dependencies: <ProviderOrFamily>[globalRootDirProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    globalRootDirProvider,
    ...?globalRootDirProvider.allTransitiveDependencies
  },
);

typedef GlobalConfigDirRef = AutoDisposeProviderRef<Directory>;
String _$globalConfigServiceHash() =>
    r'6e1297096792236daa0e2a712ef77352b23fe22f';

/// See also [globalConfigService].
@ProviderFor(globalConfigService)
final globalConfigServiceProvider =
    AutoDisposeProvider<GlobalConfigService>.internal(
  globalConfigService,
  name: r'globalConfigServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalConfigServiceHash,
  dependencies: <ProviderOrFamily>[
    globalConfigDirProvider,
    sdkCacheDirProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    globalConfigDirProvider,
    ...?globalConfigDirProvider.allTransitiveDependencies,
    sdkCacheDirProvider,
    ...?sdkCacheDirProvider.allTransitiveDependencies
  },
);

typedef GlobalConfigServiceRef = AutoDisposeProviderRef<GlobalConfigService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
