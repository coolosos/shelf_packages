import 'logger_conf.dart';
import 'static_conf.dart';

final class RunAppProperties {
  const RunAppProperties({
    this.loggerConf = const LoggerConf(logRequest: false),
    this.staticConf = const StaticConf(),
  });

  final StaticConf staticConf;

  final LoggerConf loggerConf;
}
