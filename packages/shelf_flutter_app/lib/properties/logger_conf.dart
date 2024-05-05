final class LoggerConf {
  const LoggerConf({
    required this.logRequest,
    this.customLogger,
  });

  final bool logRequest;
  final void Function(String message, bool isError)? customLogger;
}
