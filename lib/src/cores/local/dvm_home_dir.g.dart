// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'dvm_home_dir.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dvmHomeDirHash() => r'7b8a2b5c15f5be842b574c6899276ef64376ae22';

/// See also [dvmHomeDir].
@ProviderFor(dvmHomeDir)
final dvmHomeDirProvider = AutoDisposeProvider<Directory>.internal(
  dvmHomeDir,
  name: r'dvmHomeDirProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dvmHomeDirHash,
  dependencies: <ProviderOrFamily>[fileSystemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    fileSystemProvider,
    ...?fileSystemProvider.allTransitiveDependencies
  },
);

typedef DvmHomeDirRef = AutoDisposeProviderRef<Directory>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
