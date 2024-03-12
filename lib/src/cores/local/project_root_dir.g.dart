// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'project_root_dir.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectRootDirHash() => r'f56f7eddc79671e292442d7f179347a641bf8944';

/// See also [projectRootDir].
@ProviderFor(projectRootDir)
final projectRootDirProvider = AutoDisposeProvider<Directory>.internal(
  projectRootDir,
  name: r'projectRootDirProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectRootDirHash,
  dependencies: <ProviderOrFamily>[
    isDebugProvider,
    developmentDirProvider,
    fileSystemProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    isDebugProvider,
    ...?isDebugProvider.allTransitiveDependencies,
    developmentDirProvider,
    ...?developmentDirProvider.allTransitiveDependencies,
    fileSystemProvider,
    ...?fileSystemProvider.allTransitiveDependencies
  },
);

typedef ProjectRootDirRef = AutoDisposeProviderRef<Directory>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
