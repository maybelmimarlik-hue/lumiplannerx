import 'package:flutter/material.dart';
import 'lumi_colors.dart';

class LumiTheme {
  LumiTheme._();

  static const String bodyFont = 'PlusJakartaSans';
  static const String headFont = 'Fraunces';

  static const double radiusCard = 22;
  static const double radiusPill = 999;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: LumiColors.navy.withOpacity(0.06),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: LumiColors.lavender,
      brightness: Brightness.light,
    ).copyWith(
      primary: LumiColors.lavenderDark,
      onPrimary: Colors.white,
      surface: LumiColors.cream,
      onSurface: LumiColors.navy,
      error: LumiColors.danger,
    );

    const text = TextStyle(color: LumiColors.navy, fontFamily: bodyFont);

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: LumiColors.cream,
      fontFamily: bodyFont,
      textTheme: TextTheme(
        displaySmall: text.copyWith(
            fontFamily: headFont, fontSize: 32, height: 40 / 32, fontWeight: FontWeight.w700),
        headlineMedium: text.copyWith(
            fontFamily: headFont, fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w600),
        titleLarge: text.copyWith(fontSize: 20, height: 28 / 20, fontWeight: FontWeight.w700),
        titleMedium: text.copyWith(fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w600),
        bodyMedium: text.copyWith(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400),
        bodySmall: text.copyWith(
            fontSize: 12, height: 18 / 12, fontWeight: FontWeight.w400, color: LumiColors.gray),
        labelLarge: text.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        labelSmall: text.copyWith(fontSize: 11, height: 16 / 11, fontWeight: FontWeight.w500),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: LumiColors.navy,
        contentTextStyle: text.copyWith(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: border(LumiColors.grayLine),
        enabledBorder: border(LumiColors.grayLine),
        focusedBorder: border(LumiColors.lavender, 1.6),
        errorBorder: border(LumiColors.danger),
        focusedErrorBorder: border(LumiColors.danger, 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: LumiColors.lavenderDark,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusPill)),
          textStyle: const TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
