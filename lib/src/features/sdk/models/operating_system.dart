enum OperatingSystem {
  macos('macos'),
  linux('linux'),
  windows('windows'),
  ;

  const OperatingSystem(this.value);

  final String value;

  @override
  String toString() => value;
}
