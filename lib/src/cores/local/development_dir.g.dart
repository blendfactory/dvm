// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'development_dir.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$developmentDirHash() => r'76bdb7b8f983b4ea109e35a15ee99847b6833a3a';

/// See also [developmentDir].
@ProviderFor(developmentDir)
final developmentDirProvider = AutoDisposeProvider<Directory>.internal(
  developmentDir,
  name: r'developmentDirProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$developmentDirHash,
  dependencies: <ProviderOrFamily>[fileSystemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    fileSystemProvider,
    ...?fileSystemProvider.allTransitiveDependencies
  },
);

typedef DevelopmentDirRef = AutoDisposeProviderRef<Directory>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
