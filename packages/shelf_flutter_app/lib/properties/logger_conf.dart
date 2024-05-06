final class LoggerConf {
  const LoggerConf({
    this.logRequest = true,
    this.customLogger,
  });

  final bool logRequest;
  final void Function(String message, bool isError)? customLogger;
}
