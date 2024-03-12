// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'home_dir.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeDirHash() => r'02173187e2b2807b702cf7b0f3182853f8ce1190';

/// See also [homeDir].
@ProviderFor(homeDir)
final homeDirProvider = AutoDisposeProvider<Directory>.internal(
  homeDir,
  name: r'homeDirProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeDirHash,
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

typedef HomeDirRef = AutoDisposeProviderRef<Directory>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
