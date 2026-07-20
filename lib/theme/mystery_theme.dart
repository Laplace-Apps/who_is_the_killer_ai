import 'package:flutter/material.dart';

@immutable
class MysteryColors extends ThemeExtension<MysteryColors> {
  const MysteryColors({
    required this.backgroundTop,
    required this.backgroundMiddle,
    required this.backgroundBottom,
    required this.surfaceRaised,
    required this.outline,
    required this.accent,
    required this.onAccent,
    required this.success,
  });

  static const dark = MysteryColors(
    backgroundTop: Color(0xFF121424),
    backgroundMiddle: Color(0xFF171D36),
    backgroundBottom: Color(0xFF0B2742),
    surfaceRaised: Color(0xFF20283E),
    outline: Color(0xFF515D78),
    accent: Color(0xFFE64B65),
    onAccent: Colors.white,
    success: Color(0xFF55C79A),
  );

  final Color backgroundTop;
  final Color backgroundMiddle;
  final Color backgroundBottom;
  final Color surfaceRaised;
  final Color outline;
  final Color accent;
  final Color onAccent;
  final Color success;

  @override
  MysteryColors copyWith({
    Color? backgroundTop,
    Color? backgroundMiddle,
    Color? backgroundBottom,
    Color? surfaceRaised,
    Color? outline,
    Color? accent,
    Color? onAccent,
    Color? success,
  }) {
    return MysteryColors(
      backgroundTop: backgroundTop ?? this.backgroundTop,
      backgroundMiddle: backgroundMiddle ?? this.backgroundMiddle,
      backgroundBottom: backgroundBottom ?? this.backgroundBottom,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      outline: outline ?? this.outline,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
    );
  }

  @override
  MysteryColors lerp(covariant MysteryColors? other, double t) {
    if (other == null) return this;
    return MysteryColors(
      backgroundTop: Color.lerp(backgroundTop, other.backgroundTop, t)!,
      backgroundMiddle: Color.lerp(
        backgroundMiddle,
        other.backgroundMiddle,
        t,
      )!,
      backgroundBottom: Color.lerp(
        backgroundBottom,
        other.backgroundBottom,
        t,
      )!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

extension MysteryThemeX on BuildContext {
  MysteryColors get mystery =>
      Theme.of(this).extension<MysteryColors>() ?? MysteryColors.dark;
}

class MysteryTheme {
  MysteryTheme._();

  static ThemeData dark() {
    const colors = MysteryColors.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: colors.accent,
          brightness: Brightness.dark,
          surface: colors.backgroundTop,
        ).copyWith(
          primary: colors.accent,
          onPrimary: colors.onAccent,
          surfaceContainer: colors.surfaceRaised,
          outline: colors.outline,
        );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colors.backgroundTop,
      fontFamily: 'Inter',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceRaised.withValues(alpha: 0.78),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          side: BorderSide(color: colors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      extensions: const [colors],
    );
  }
}
