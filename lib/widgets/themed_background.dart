import 'package:flutter/material.dart';

class ThemedBackground extends StatelessWidget {
  final Widget child;

  const ThemedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    if (!isDark) {
      return Container(
        color: const Color(0xFFF9FAFB),
        child: child,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0C1710), Color(0xFF16321F), Color(0xFF0F2015)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Aurora effect 1
          Positioned(
            top: -200,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF388E3C).withValues(alpha: 0.25),
                    const Color(0xFF388E3C).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Aurora effect 2
          Positioned(
            bottom: -200,
            right: -150,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4CAF50).withValues(alpha: 0.15),
                    const Color(0xFF4CAF50).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Content
          child,
        ],
      ),
    );
  }
}
