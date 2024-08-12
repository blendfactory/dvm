## 0.0.8+1

### Improved

- Add the installation section to the README.

## 0.0.8

### Changed

- Requires Dart SDK 3.5.0 or higher.

### Fixed

- Fix the error when running `dvm install` command.

## 0.0.7

### Added

- Create a command for displaying info about dvm configuration.
  - `dvm doctor`

## 0.0.6

### Improved

- Change `dvm list` to display a message as a warning instead of an error when the SDKs are not found.

### Fixed

- Sort and display installed Dart SDKs in ascending order.

### Added

- Add `--global` option flag to `dvm use`.
  - `dvm use --global <version>`
- When executing `dvm dart`, if the project config are not found, the Dart SDK version from the global config will be used.
- Add `--latest` option flag to `dvm list`.
  - `dvm list --latest`
- Add `--remote` option flag to `dvm list`.
  - `dvm list --remote`

### Changed

- Change the alias of `dvm list` from `l` to `ls`.
- Change default channel for `dvm list` to stable.
- Remove `dvm releases` command.

## 0.0.5

### Fixed

- Fix pub warning.
  - "To format your files run: `dart format .`"

## 0.0.4

### Added

- Add `--latest` option flag to `dvm releases`.
  - `dvm releases --latest`
- Add `--latest` option flag to `dvm install`.
  - `dvm install --latest`
- Add `--latest` option flag to `dvm use`.
  - `dvm use --latest`

### Changed

- Remove extraneous margins from the output of `dvm --version`.

## 0.0.3

### Added

- Create a command for showing installed Dart SDK versions.
  - `dvm list`
- Create a command for uninstalling Dart SDK versions.
  - `dvm uninstall <version>`

## 0.0.2

### Improved

- Improve PUB POINTS.
  - Fix warning "No example found".
  - Fix warning "The package description is too short".

### Fixed

- Grant execution permission to dartaotruntime.

## 0.0.1

- Initial version.
