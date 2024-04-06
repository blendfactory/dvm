import 'package:dvmx/src/features/project_config/models/project_config.dart';
import 'package:json_annotation/json_annotation.dart';

sealed class ProjectConfigStatus {
  const ProjectConfigStatus();

  const factory ProjectConfigStatus.found(
    ProjectConfig projectConfig,
  ) = ProjectConfigStatusFound;
  const factory ProjectConfigStatus.notFound() = ProjectConfigStatusNotFound;

  const factory ProjectConfigStatus.jsonFormatError(
    FormatException e,
  ) = ProjectConfigStatusJsonFormatError;
  const factory ProjectConfigStatus.paramFormatError(
    CheckedFromJsonException e,
  ) = ProjectConfigStatusParamFormatError;
  const factory ProjectConfigStatus.unknownError(
    Exception e,
  ) = ProjectConfigStatusUnknownError;
}

final class ProjectConfigStatusFound extends ProjectConfigStatus {
  const ProjectConfigStatusFound(this.projectConfig);
  final ProjectConfig projectConfig;
}

final class ProjectConfigStatusNotFound extends ProjectConfigStatus {
  const ProjectConfigStatusNotFound();
}

sealed class ProjectConfigStatusError extends ProjectConfigStatus {
  const ProjectConfigStatusError(this.e);
  final Exception? e;
}

final class ProjectConfigStatusJsonFormatError
    extends ProjectConfigStatusError {
  const ProjectConfigStatusJsonFormatError(FormatException super.e);
}

final class ProjectConfigStatusParamFormatError
    extends ProjectConfigStatusError {
  const ProjectConfigStatusParamFormatError(CheckedFromJsonException super.e);
}

final class ProjectConfigStatusUnknownError extends ProjectConfigStatusError {
  const ProjectConfigStatusUnknownError(Exception super.e);
}
