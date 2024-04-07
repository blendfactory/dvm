import 'package:cli_info/cli_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cli_info.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
external CliInfo cliInfo(CliInfoRef ref);
