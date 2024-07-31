import 'package:shelf/shelf.dart';
import 'package:shelf_gzip/shelf_gzip.dart';
import 'package:shelf_static/shelf_static.dart';
import 'properties/middleware/no_found_middleware.dart';
import 'properties/run_app_properties.dart';

class RunApp {
  RunApp({
    RunAppProperties? runAppProperties,
  }) : _runAppProperties = runAppProperties ?? const RunAppProperties();

  final RunAppProperties _runAppProperties;

  Handler get handler {
    Pipeline pipeline = const Pipeline();

    if (_runAppProperties.staticConf.compress) {
      pipeline = pipeline.addMiddleware(createGzipMiddleware());
    }

    if (_runAppProperties.loggerConf.logRequest) {
      pipeline = pipeline.addMiddleware(
        logRequests(
          logger: _runAppProperties.loggerConf.customLogger,
        ),
      );
    }

    if (_runAppProperties.staticConf.onNotFoundPathUseDefaultDocument) {
      pipeline = pipeline.addMiddleware(
        onNotFoundUseDefaultDocumentMiddleware(
          _runAppProperties.staticConf.defaultDocument,
        ),
      );
    }
    return pipeline.addHandler(
      createStaticHandler(
        _runAppProperties.staticConf.fileSystemPath,
        defaultDocument: _runAppProperties.staticConf.defaultDocument,
      ),
    );
  }
}
