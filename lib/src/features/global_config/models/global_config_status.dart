import 'package:dvmx/src/features/global_config/models/global_config.dart';
import 'package:json_annotation/json_annotation.dart';

sealed class GlobalConfigStatus {
  const GlobalConfigStatus();

  const factory GlobalConfigStatus.found(
    GlobalConfig globalConfig,
  ) = GlobalConfigStatusFound;
  const factory GlobalConfigStatus.notFound() = GlobalConfigStatusNotFound;

  const factory GlobalConfigStatus.jsonFormatError(
    FormatException e,
  ) = GlobalConfigStatusJsonFormatError;
  const factory GlobalConfigStatus.paramFormatError(
    CheckedFromJsonException e,
  ) = GlobalConfigStatusParamFormatError;
  const factory GlobalConfigStatus.unknownError(
    Exception e,
  ) = GlobalConfigStatusUnknownError;
}

final class GlobalConfigStatusFound extends GlobalConfigStatus {
  const GlobalConfigStatusFound(this.globalConfig);
  final GlobalConfig globalConfig;
}

final class GlobalConfigStatusNotFound extends GlobalConfigStatus {
  const GlobalConfigStatusNotFound();
}

sealed class GlobalConfigStatusError extends GlobalConfigStatus {
  const GlobalConfigStatusError(this.e);
  final Exception? e;
}

final class GlobalConfigStatusJsonFormatError extends GlobalConfigStatusError {
  const GlobalConfigStatusJsonFormatError(FormatException super.e);
}

final class GlobalConfigStatusParamFormatError extends GlobalConfigStatusError {
  const GlobalConfigStatusParamFormatError(CheckedFromJsonException super.e);
}

final class GlobalConfigStatusUnknownError extends GlobalConfigStatusError {
  const GlobalConfigStatusUnknownError(Exception super.e);
}
