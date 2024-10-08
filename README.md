<image src="https://repository-images.githubusercontent.com/729417964/c90b1c0d-5c3b-42d8-a49f-58f62d37cbf6" alt="DVM" />

# DVM

Dart Version Management: A simple CLI to manage Dart SDK versions per project.

Inspired by [FVM].

For those interested in the evolution process of DVM, please visit the [GitHub Project].

## Installation

### Homebrew (Recommended)

> [!NOTE]
> This is recommended since it does not depend on the version of Dart SDK, pub packages, etc.

```shell
brew install blendfactory/tap/dvm
```

### Pub (Not Recommended)

> [!NOTE]
> Requires Dart SDK version 3.5.0 or higher.

```shell
dart pub global activate dvm --overwrite
```

## GitHub Actions

See [dvm-config-action].

## Contributors

<a href="https://github.com/blendfactory/dvm/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=blendfactory/dvm"  alt="Contributors"/>
</a>

<!-- Links -->

[FVM]: https://github.com/leoafarias/fvm
[GitHub Project]: https://github.com/orgs/blendfactory/projects/1
[dvm-config-action]: https://github.com/blendfactory/dvm-config-action
