import 'dart:io';

import 'package:file/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_client.g.dart';

@Riverpod(dependencies: [])
PermissionClient permissionClient(PermissionClientRef ref) {
  return const PermissionClient();
}

const _executable = 'chmod';

final class PermissionClient {
  const PermissionClient();

  Future<void> grantExecPermission(File file) async {
    final args = ['+x', file.path];
    final result = await Process.run(_executable, args);

    final exitCode = result.exitCode;
    final stderr = result.stderr as String;

    if (exitCode != 0) {
      throw ProcessException(_executable, args, stderr, exitCode);
    }
  }
}
