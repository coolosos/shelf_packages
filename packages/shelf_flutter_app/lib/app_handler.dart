import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_gzip/shelf_gzip.dart';

import 'properties/run_app_properties.dart';

class RunApp {
  RunApp({
    required RunAppProperties runAppProperties,
  }) : _runAppProperties = runAppProperties;

  String? _indexHtmlApp;

  final RunAppProperties _runAppProperties;

  Handler get handler {
    Pipeline pipeline = const Pipeline().addMiddleware(createGzipMiddleware());

    if (_runAppProperties.staticConf.onNotFoundUseDefaultDocumentMiddleware) {
      pipeline = pipeline.addMiddleware(
        flutterAppOnNotFoundResponseMiddleware(),
      );
    }

    if (_runAppProperties.loggerConf.logRequest) {
      pipeline = pipeline.addMiddleware(
        logRequests(
          logger: _runAppProperties.loggerConf.customLogger,
        ),
      );
    }

    return pipeline.addHandler(_runAppProperties.staticConf.staticHandler);
  }

  Middleware flutterAppOnNotFoundResponseMiddleware() {
    return (Handler innerHandler) => (Request request) async {
          if (request.url.path.isEmpty ||
              request.url.path ==
                  _runAppProperties.staticConf.defaultDocument) {
            return _index();
          }

          return Future.sync(() => innerHandler(request)).then((response) {
            if (response.statusCode == HttpStatus.notFound) {
              return _index();
            }

            return response;
          });
        };
  }

  Response _index() {
    final body = _indexHtmlApp ??= _runAppProperties.staticConf.indexApp;
    if (body.isEmpty) {
      return Response.notFound('');
    }
    return Response(
      HttpStatus.ok,
      body: body,
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.html.toString(),
      },
    );
  }
}
