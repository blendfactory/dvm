// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'dvm_home_dir.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dvmHomeDirHash() => r'9c9e1c317862c3f1061273cfa0331a1c733aa76a';

/// See also [dvmHomeDir].
@ProviderFor(dvmHomeDir)
final dvmHomeDirProvider = AutoDisposeProvider<Directory>.internal(
  dvmHomeDir,
  name: r'dvmHomeDirProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dvmHomeDirHash,
  dependencies: <ProviderOrFamily>[homeDirProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    homeDirProvider,
    ...?homeDirProvider.allTransitiveDependencies
  },
);

typedef DvmHomeDirRef = AutoDisposeProviderRef<Directory>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
