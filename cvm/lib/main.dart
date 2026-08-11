import 'package:flutter/material.dart';
import 'presentation/change_screen.dart';
import 'presentation/theme/peso_theme.dart';

void main() => runApp(const CvmApp());

class CvmApp extends StatelessWidget {
  const CvmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converge Vending Machine',
      debugShowCheckedModeBanner: false,
      theme: buildPesoTheme(),
      home: const ChangeScreen(),
    );
  }
}
