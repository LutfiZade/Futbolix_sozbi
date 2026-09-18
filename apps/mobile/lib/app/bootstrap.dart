import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'futbolix_app.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF080F0E),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FutbolixApp());
}
