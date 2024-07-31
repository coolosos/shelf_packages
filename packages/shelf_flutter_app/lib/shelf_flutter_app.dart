import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_gzip/shelf_gzip.dart';
import 'package:shelf_static/shelf_static.dart';
import 'properties/run_app_properties.dart';

class RunApp {
  RunApp({
    RunAppProperties? runAppProperties,
  }) : _runAppProperties = runAppProperties ?? const RunAppProperties();

  static String? _indexHtmlApp;

  final RunAppProperties _runAppProperties;

  Handler get handler {
    Pipeline pipeline = const Pipeline();

    if (_runAppProperties.staticConf.compress) {
      pipeline = pipeline.addMiddleware(createGzipMiddleware());
    }

    if (_runAppProperties.staticConf.onNotFoundUseDefaultDocument) {
      pipeline = pipeline.addMiddleware(
        onNotFoundUseDefaultDocumentMiddleware(),
      );
    }

    if (_runAppProperties.staticConf.rootUseDefaultDocument) {
      pipeline = pipeline.addMiddleware(
        rootUseDefaultDocumentMiddleware(),
      );
    }

    if (_runAppProperties.loggerConf.logRequest) {
      pipeline = pipeline.addMiddleware(
        logRequests(
          logger: _runAppProperties.loggerConf.customLogger,
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

  Middleware rootUseDefaultDocumentMiddleware() {
    return (Handler innerHandler) => (Request request) {
          if (request.url.path.isEmpty ||
              request.url.path ==
                  _runAppProperties.staticConf.defaultDocument) {
            return _index();
          }
          return innerHandler(request);
        };
  }

  Middleware onNotFoundUseDefaultDocumentMiddleware() {
    return (Handler innerHandler) => (Request request) {
          return Future.sync(() => innerHandler(request)).then((response) {
            if (response.statusCode == HttpStatus.notFound) {
              return _index();
            }

            return response;
          });
        };
  }

  Future<Response> _index() async {
    _indexHtmlApp ??= await _runAppProperties.staticConf.file.readAsString();
    if (_indexHtmlApp?.isEmpty ?? true) {
      return Response.notFound('');
    }
    return Response(
      HttpStatus.ok,
      body: _indexHtmlApp,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.html.toString(),
      },
    );
  }
}
