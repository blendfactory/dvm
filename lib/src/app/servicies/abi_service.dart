import 'dart:ffi';

import 'package:dvm/src/features/sdk/models/architecture.dart';
import 'package:dvm/src/features/sdk/models/operating_system.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'abi_service.g.dart';

@Riverpod(dependencies: [])
AbiService abiService(AbiServiceRef ref) {
  final abi = Abi.current();
  return AbiService(abi: abi);
}

const _nameOs = 'os';
const _nameArch = 'architecture';
final _abiRegex = RegExp('^(?<$_nameOs>[a-z]+)_(?<$_nameArch>[\\da-z]+)\$');

final class AbiService {
  AbiService({
    required Abi abi,
  }) : _abi = abi;

  final Abi _abi;

  ({OperatingSystem os, Architecture arch}) getOsAndArch() {
    final match = _abiRegex.firstMatch(_abi.toString());
    if (match == null) {
      throw Exception('Could not parse ABI: $this');
    }
    final osValue = match.namedGroup(_nameOs)!;
    final os = OperatingSystem.values.byNameOrNull(osValue);
    if (os == null) {
      throw Exception('Unsupport operating system: $osValue');
    }

    final archValue = match.namedGroup(_nameArch)!;
    final arch = Architecture.values.byNameOrNull(archValue);
    if (arch == null) {
      throw Exception('Unsupport architecture: $archValue');
    }

    return (os: os, arch: arch);
  }
}

extension _EnumByNameOrNull<T extends Enum> on Iterable<T> {
  T? byNameOrNull(String name) {
    for (final value in this) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }
}
