import 'package:flutter/material.dart';

/// Temporary starting screen; the supplied UI/UX will replace its content.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Futbolix')));
  }
}
