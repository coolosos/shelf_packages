import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';

final class StaticConf {
  const StaticConf({
    this.fileSystemPath = 'app',
    this.defaultDocument = 'index.html',
    this.onNotFoundUseDefaultDocumentMiddleware = true,
  });

  final String fileSystemPath;
  final String defaultDocument;
  final bool onNotFoundUseDefaultDocumentMiddleware;

  String get indexApp => File(
        path.join(
          Directory.current.path,
          fileSystemPath,
          defaultDocument,
        ),
      ).readAsStringSync();

  Handler get staticHandler => createStaticHandler(
        fileSystemPath,
        defaultDocument: defaultDocument,
      );
}
