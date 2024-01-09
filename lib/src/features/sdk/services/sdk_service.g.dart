// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'sdk_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sdkCacheDirHash() => r'e2b68f046bef2ed8b3925627272f12dbafff1b8a';

/// See also [sdkCacheDir].
@ProviderFor(sdkCacheDir)
final sdkCacheDirProvider = AutoDisposeProvider<Directory>.internal(
  sdkCacheDir,
  name: r'sdkCacheDirProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sdkCacheDirHash,
  dependencies: <ProviderOrFamily>[fileSystemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    fileSystemProvider,
    ...?fileSystemProvider.allTransitiveDependencies
  },
);

typedef SdkCacheDirRef = AutoDisposeProviderRef<Directory>;
String _$sdkServiceHash() => r'374da5e1b2761c0c615173ebe3517a63618b4fab';

/// See also [sdkService].
@ProviderFor(sdkService)
final sdkServiceProvider = AutoDisposeProvider<SdkService>.internal(
  sdkService,
  name: r'sdkServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sdkServiceHash,
  dependencies: <ProviderOrFamily>{
    dvmClientProvider,
    sdkCacheDirProvider,
    systemTempDirProvider,
    permissionClientProvider
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    dvmClientProvider,
    ...?dvmClientProvider.allTransitiveDependencies,
    sdkCacheDirProvider,
    ...?sdkCacheDirProvider.allTransitiveDependencies,
    systemTempDirProvider,
    ...?systemTempDirProvider.allTransitiveDependencies,
    permissionClientProvider,
    ...?permissionClientProvider.allTransitiveDependencies
  },
);

typedef SdkServiceRef = AutoDisposeProviderRef<SdkService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
