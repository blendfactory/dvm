enum Architecture {
  ia32('ia32'),
  x64('x64'),
  arm('arm'),
  arm64('arm64'),
  ;

  const Architecture(this.value);

  final String value;

  @override
  String toString() => value;
}
