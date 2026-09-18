import 'dart:convert';
import 'dart:io';

/// Local server skeleton. Application routes and authentication come later.
Future<HttpServer> startServer({
  String host = '127.0.0.1',
  int port = 8080,
}) async {
  final server = await HttpServer.bind(host, port);
  server.listen((request) async {
    request.response.headers.contentType = ContentType.json;
    if (request.method == 'GET' && request.uri.path == '/healthz') {
      request.response.write(jsonEncode({'status': 'ok'}));
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write(jsonEncode({'error': 'not_found'}));
    }
    await request.response.close();
  });
  return server;
}
