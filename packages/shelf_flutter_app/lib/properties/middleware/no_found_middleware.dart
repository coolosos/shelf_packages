import 'dart:io';

import 'package:shelf/shelf.dart';

Middleware onNotFoundUseDefaultDocumentMiddleware(String defaultDocumentName) {
  return (Handler innerHandler) => (Request request) {
        return Future.sync(() => innerHandler(request)).then((response) {
          if (response.statusCode == HttpStatus.notFound &&
              !request.url.path.contains('.')) {
            return innerHandler(
              Request(
                'GET',
                Uri(
                  scheme: 'https',
                  host: 'localhost',
                  path: defaultDocumentName,
                ),
              ),
            );
            // return Response.movedPermanently(defaultDocumentName);
          }
          return response;
        });
      };
}
