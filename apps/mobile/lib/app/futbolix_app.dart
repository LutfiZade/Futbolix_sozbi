import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'demo_store.dart';
import 'theme/app_theme.dart';

class FutbolixApp extends StatelessWidget {
  const FutbolixApp({super.key, this.store});
  final DemoStore? store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futbolix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: AppShell(store: store),
    );
  }
}
