enum ExitStatus {
  success(0),
  usage(64),
  error(1),
  ;

  const ExitStatus(this.code);

  final int code;
}
