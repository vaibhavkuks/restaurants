import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      filledButtonTheme: _filledButtonTheme,
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
    );
  }

  static ColorScheme get _lightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: _hexToColor(AppConstants.primaryColor),
      secondary: _hexToColor(AppConstants.secondaryColor),
      surface: _hexToColor(AppConstants.surfaceColor),
      error: _hexToColor(AppConstants.errorColor),
    );
  }

  static TextTheme get _textTheme {
    return GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: AppConstants.textSizeHeading,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: AppConstants.textSizeTitle,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: AppConstants.textSizeXLarge,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: AppConstants.textSizeLarge,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: AppConstants.textSizeLarge),
      bodyMedium: GoogleFonts.inter(fontSize: AppConstants.textSizeMedium),
      bodySmall: GoogleFonts.inter(fontSize: AppConstants.textSizeSmall),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLarge,
          vertical: AppConstants.paddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  static FilledButtonThemeData get _filledButtonTheme {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLarge,
          vertical: AppConstants.paddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _hexToColor(AppConstants.surfaceColor),
      surfaceTintColor: Colors.white,
      foregroundColor: _hexToColor(AppConstants.secondaryColor),
      titleTextStyle: GoogleFonts.inter(
        fontSize: AppConstants.textSizeTitle,
        fontWeight: FontWeight.w600,
        color: _hexToColor('#000000'),
      ),
    );
  }

  static PreferredSizeWidget appBarBottomBorder() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: 1,
        color: Colors.grey[300],
      ),
    );
  }

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      selectedItemColor: _hexToColor(AppConstants.primaryColor),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    );
  }

  static Color _hexToColor(String hex) {
    return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }
}
