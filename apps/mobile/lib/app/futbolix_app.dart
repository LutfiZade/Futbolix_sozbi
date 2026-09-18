import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import 'theme/app_theme.dart';

class FutbolixApp extends StatelessWidget {
  const FutbolixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futbolix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
