import 'dart:math';

import 'package:flutter/material.dart';

class InitiallyWigglingText extends StatelessWidget {
  const InitiallyWigglingText(this.text, {super.key});

  final String text;

  double bounce(double t) {
    const steps = 1 / 2;
    return (((steps * 0.5) - (((t + 0.25 * steps) % steps))).abs() -
            0.25 * steps) /
        (steps / 4);
  }

  double smooth(double t) {
    return pow(t.abs(), 1 / 3) * t.sign;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: smooth(bounce(value)) / 15,
          origin: const Offset(0, 500),
          child: Text(
            text,
            style: const TextStyle(fontSize: 25),
          ),
        );
      },
    );
  }
}
