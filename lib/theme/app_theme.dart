import 'package:flutter/material.dart';
import 'tokens.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: HlTokens.sea,
        primary: HlTokens.sea,
        secondary: HlTokens.coral,
        surface: HlTokens.sand,
        onPrimary: Colors.white,
        onSurface: HlTokens.ink,
      ),
      scaffoldBackgroundColor: HlTokens.sand,
      dividerColor: HlTokens.line,
    );
    final text = base.textTheme.apply(
      bodyColor: HlTokens.ink,
      displayColor: HlTokens.ink,
    );
    return base.copyWith(
      textTheme: text,
      primaryTextTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: HlTokens.sand,
        foregroundColor: HlTokens.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: HlTokens.ink,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardTheme(
        color: HlTokens.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HlTokens.radiusCard),
          side: const BorderSide(color: HlTokens.line),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: HlTokens.foam,
        labelStyle: const TextStyle(
          color: HlTokens.seaDeep,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.94),
        indicatorColor: HlTokens.foam,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final selected = states.contains(MaterialState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? HlTokens.sea : HlTokens.inkSoft,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: HlTokens.sea,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}
