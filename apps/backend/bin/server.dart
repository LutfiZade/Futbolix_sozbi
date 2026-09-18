import 'dart:io';

import 'package:futbolix_backend/src/http/server.dart';

Future<void> main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final host = Platform.environment['HOST'] ?? '127.0.0.1';
  final server = await startServer(host: host, port: port);
  stdout.writeln(
    'Futbolix backend: http://${server.address.host}:${server.port}',
  );
}
