// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'global_root_dir.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalRootDirHash() => r'352e436c45a548e9fef9060bc16b6e4d5c9f2d92';

/// See also [globalRootDir].
@ProviderFor(globalRootDir)
final globalRootDirProvider = AutoDisposeProvider<Directory>.internal(
  globalRootDir,
  name: r'globalRootDirProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalRootDirHash,
  dependencies: <ProviderOrFamily>[
    isDebugProvider,
    developmentDirProvider,
    dvmHomeDirProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    isDebugProvider,
    ...?isDebugProvider.allTransitiveDependencies,
    developmentDirProvider,
    ...?developmentDirProvider.allTransitiveDependencies,
    dvmHomeDirProvider,
    ...?dvmHomeDirProvider.allTransitiveDependencies
  },
);

typedef GlobalRootDirRef = AutoDisposeProviderRef<Directory>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
