import 'package:flutter/material.dart';

import '../../domain/denomination.dart';
import '../theme/peso_theme.dart';

// UI UX Improvement, render a rectangle container for each denomination with specific colors
class MoneySwatch extends StatelessWidget {
  const MoneySwatch({super.key, required this.denomination, this.width = 64});

  final DenominationValue denomination;

  final double width;

  bool get _isBill => denomination.type == DenominationType.bill;

  @override
  Widget build(BuildContext context) {
    final color = denomination.swatchColor;
    final ink = denomination.inkColor;

    // coins are drawn as a circle, bills as a rectangle
    if (!_isBill) {
      final size = width * 0.62;
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(color, Colors.white, 0.35)!, color],
          ),
          border: Border.all(color: Color.lerp(color, Colors.black, 0.25)!),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              denomination.display,
              style: TextStyle(
                color: ink,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.36,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, 0.22)!, color],
        ),
        border: Border.all(color: Color.lerp(color, Colors.black, 0.2)!),
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // inner frame, real bills have a printed border like this
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: ink.withValues(alpha: 0.35)),
                ),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                denomination.display,
                style: TextStyle(
                  color: ink,
                  fontWeight: FontWeight.w800,
                  fontSize: width * 0.22,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
