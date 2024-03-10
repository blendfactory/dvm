// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'sdk_cache_dir.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sdkCacheDirHash() => r'5d7a2b87468ffa57c5a648612256077bbb3c8166';

/// See also [sdkCacheDir].
@ProviderFor(sdkCacheDir)
final sdkCacheDirProvider = AutoDisposeProvider<Directory>.internal(
  sdkCacheDir,
  name: r'sdkCacheDirProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sdkCacheDirHash,
  dependencies: <ProviderOrFamily>[dvmHomeDirProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    dvmHomeDirProvider,
    ...?dvmHomeDirProvider.allTransitiveDependencies
  },
);

typedef SdkCacheDirRef = AutoDisposeProviderRef<Directory>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
