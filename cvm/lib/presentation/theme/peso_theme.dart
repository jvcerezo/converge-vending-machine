import 'package:flutter/material.dart';

import '../../domain/denomination.dart';

// note colors match the real NGC bills so users can spot them at a glance.
// app colors are NOT flag colors on purpose, RA 8491 restricts using the
// flag design for branding.
abstract final class PesoColors {
  static const brandDeep = Color(0xFF14504A);
  static const brandDeepShade = Color(0xFF0C3A36);
  static const brandBrass = Color(0xFFB98A2E);

  // bills, dominant color of each note
  static const note1000 = Color(0xFF1B4F9C); // blue
  static const note500 = Color(0xFFE0A80D); // yellow
  static const note200 = Color(0xFF2E7D32); // green
  static const note100 = Color(0xFF7B5EA7); // violet
  static const note50 = Color(0xFFC0392B); // red
  static const note20 = Color(0xFFD97706); // orange

  // coins
  static const coinGold = Color(0xFFC9A227); // P20 bi-metallic
  static const coinSilver = Color(0xFF8E99A4); // P1, P5, P10
  static const coinCopper = Color(0xFFB87333); // sentimo
}

// color of the denomination plus a readable text color on top of it
extension DenominationSwatch on DenominationValue {
  Color get swatchColor => switch (this) {
    DenominationValue.peso1000 => PesoColors.note1000,
    DenominationValue.peso500 => PesoColors.note500,
    DenominationValue.peso200 => PesoColors.note200,
    DenominationValue.peso100 => PesoColors.note100,
    DenominationValue.peso50 => PesoColors.note50,
    DenominationValue.peso20Bill => PesoColors.note20,
    DenominationValue.peso20Coin => PesoColors.coinGold,
    DenominationValue.peso10 ||
    DenominationValue.peso5 ||
    DenominationValue.peso1 => PesoColors.coinSilver,
    DenominationValue.sentimo25 ||
    DenominationValue.sentimo10 ||
    DenominationValue.sentimo5 ||
    DenominationValue.sentimo1 => PesoColors.coinCopper,
  };

  // yellow and gold need dark text, the rest are dark enough for white
  Color get inkColor => switch (this) {
    DenominationValue.peso500 ||
    DenominationValue.peso20Coin => const Color(0xFF3B2F00),
    _ => Colors.white,
  };
}

ThemeData buildPesoTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: PesoColors.brandDeep,
        primary: PesoColors.brandDeep,
      ).copyWith(
        secondary: PesoColors.brandBrass,
        tertiary: PesoColors.coinCopper,
        surface: const Color(0xFFF7F5EF),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: PesoColors.brandDeep,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PesoColors.brandDeep, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
