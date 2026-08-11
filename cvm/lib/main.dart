import 'package:flutter/material.dart';
import 'presentation/change_screen.dart';

void main() => runApp(const CvmApp());

class CvmApp extends StatelessWidget {
  const CvmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converge Vending Machine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
        useMaterial3: true,
      ),
      home: const ChangeScreen(),
    );
  }
}
