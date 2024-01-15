import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dvmx/src/app/gen/cli_info.g.dart';
import 'package:grinder/grinder.dart';

const _osToArchs = {
  'macos': ['x64', 'arm64'],
  'linux': ['ia32', 'x64', 'arm', 'arm64'],
  'windows': ['ia32', 'x64'],
};

void addChecksumTasks() {
  final osTasks = _osToArchs.entries.map((entry) {
    final os = entry.key;
    final archTasks = entry.value.map((arch) {
      return GrinderTask(
        'pkg-checksum-$os-$arch',
        taskFunction: () async => _buildChecksum(os, arch),
        description: 'Build $os $arch checksum.',
      );
    }).toList();
    archTasks.forEach(addTask);

    return GrinderTask(
      'pkg-checksum-$os',
      description: 'Build $os checksums.',
      depends: archTasks.map((task) => task.name),
    );
  }).toList();
  osTasks.forEach(addTask);

  addTask(
    GrinderTask(
      'pkg-checksum-all',
      description: 'Build all checksums.',
      depends: osTasks.map((task) => task.name),
    ),
  );
}

Future<void> _buildChecksum(String os, String arch) async {
  final version = cliInfo.version;
  final executableFileExtension = os == 'windows' ? 'zip' : 'tar.gz';
  final executableFileName = 'dvm-$version-$os-$arch.$executableFileExtension';
  final executableFile = File('build/$executableFileName');

  final bytes = await executableFile.readAsBytes();
  final digest = sha256.convert(bytes);

  final sha256FileName = 'dvm-$version-$os-$arch.sha256';
  final sha256File = File('build/$sha256FileName');

  await sha256File.writeAsString('$digest  $executableFileName\n');
}
