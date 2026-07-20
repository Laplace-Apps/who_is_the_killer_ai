import 'package:flutter/material.dart';

import '../theme/mystery_theme.dart';

class MysteryBackground extends StatelessWidget {
  const MysteryBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.mystery;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.backgroundTop,
            colors.backgroundMiddle,
            colors.backgroundBottom,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: -70,
            right: -50,
            child: _AtmosphericCircle(size: 210),
          ),
          const Positioned(
            bottom: -90,
            left: -70,
            child: _AtmosphericCircle(size: 250),
          ),
          child,
        ],
      ),
    );
  }
}

class _AtmosphericCircle extends StatelessWidget {
  const _AtmosphericCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.mystery.accent.withValues(alpha: 0.13),
            width: 28,
          ),
        ),
      ),
    );
  }
}
