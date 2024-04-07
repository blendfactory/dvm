import 'package:http/http.dart';
import 'package:pub_semver/pub_semver.dart';

sealed class PackageVersionStatus {
  const PackageVersionStatus();
  const factory PackageVersionStatus.upToDate() = PackageVersionStatusUpToDate;
  const factory PackageVersionStatus.outdated({
    required Version current,
    required Version latest,
  }) = PackageVersionStatusOutdated;

  const factory PackageVersionStatus.aheadOfLatestError({
    required Version current,
    required Version latest,
  }) = PackageVersionStatusAheadOfLatestError;
  const factory PackageVersionStatus.formatError(FormatException e) =
      PackageVersionStatusFormatError;
  const factory PackageVersionStatus.networkError(ClientException e) =
      PackageVersionStatusNetworkError;
  const factory PackageVersionStatus.unknownError(Exception e) =
      PackageVersionStatusUnknownError;
}

final class PackageVersionStatusUpToDate extends PackageVersionStatus {
  const PackageVersionStatusUpToDate();
}

final class PackageVersionStatusOutdated extends PackageVersionStatus {
  const PackageVersionStatusOutdated({
    required this.current,
    required this.latest,
  });
  final Version current;
  final Version latest;
}

sealed class PackageVersionStatusError extends PackageVersionStatus {
  const PackageVersionStatusError(this.e);
  final Exception? e;
}

final class PackageVersionStatusAheadOfLatestError
    extends PackageVersionStatusError {
  const PackageVersionStatusAheadOfLatestError({
    required this.current,
    required this.latest,
  }) : super(null);
  final Version current;
  final Version latest;
}

final class PackageVersionStatusFormatError extends PackageVersionStatusError {
  const PackageVersionStatusFormatError(FormatException super.e);
}

final class PackageVersionStatusNetworkError extends PackageVersionStatusError {
  const PackageVersionStatusNetworkError(ClientException super.e);
}

final class PackageVersionStatusUnknownError extends PackageVersionStatusError {
  const PackageVersionStatusUnknownError(Exception super.e);
}
