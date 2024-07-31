import 'dart:io';
import 'package:path/path.dart' as path;

final class StaticConf {
  const StaticConf({
    this.fileSystemPath = 'app',
    this.defaultDocument = 'index.html',
    this.rootUseDefaultDocument = true,
    this.onNotFoundUseDefaultDocument = false,
    this.compress = true,
  });

  final String fileSystemPath;
  final String defaultDocument;

  final bool rootUseDefaultDocument;
  final bool onNotFoundUseDefaultDocument;
  final bool compress;

  File get file => File(
        path.join(
          Directory.current.path,
          fileSystemPath,
          defaultDocument,
        ),
      );
}
