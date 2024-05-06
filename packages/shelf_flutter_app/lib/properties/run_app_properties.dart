import 'logger_conf.dart';
import 'static_conf.dart';

export 'logger_conf.dart';
export 'static_conf.dart';

final class RunAppProperties {
  const RunAppProperties({
    this.loggerConf = const LoggerConf(),
    this.staticConf = const StaticConf(),
  });

  final StaticConf staticConf;

  final LoggerConf loggerConf;
}
