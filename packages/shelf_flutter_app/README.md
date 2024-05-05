# Shelf Flutter App

Serve a flutter web app with gzip and notfound routes middleware

## Quick start

First, run `dart pub add shelf_flutter_app` for your app. Then:

### shelf 

```dart
import 'package:shelf_flutter_app/shelf_flutter_app.dart';

final staticApp = RunApp();

var server = await shelf_io.serve(staticApp.handler, 'localhost', 8080);
 
```

### dart_frog 

```dart
import 'package:shelf_flutter_app/shelf_flutter_app.dart';

Handler middleware(Handler handler) {

    final staticApp = RunApp();

    return handler.use(
        fromShelfHandler(staticApp.handler),
    );
}
```

### Full RunApp constructor

```dart
  final staticApp = RunApp(
    runAppProperties: RunAppProperties(
      loggerConf: LoggerConf(
        logRequest: true,
        customLogger: (String msg, bool isError) {
          if (isError) {
            print('[ERROR] $msg');
          } else {
            print(msg);
          }
        },
      ),
      staticConf: const StaticConf(
        defaultDocument: 'index.html',
        fileSystemPath: 'app',
        onNotFoundUseDefaultDocumentMiddleware: true,
      ),
    ),
  );
```

you may need to disable notfoundMiddleware by default so that it does not break other routes, and add it later.

#### As dart_frog middleware example

```dart
final cascadeHandler = Cascade()
    .add(
    fromShelfHandler(
        staticApp.handler,
    ),
    )
    .add(handler)
    .handler
    .use(
    fromShelfMiddleware(
        staticApp.flutterAppOnNotFoundResponseMiddleware(),
    ),
    );
```