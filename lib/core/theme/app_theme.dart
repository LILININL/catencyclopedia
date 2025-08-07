import 'package:flutter/material.dart';

/// Theme-related utilities and constants for the Cat Encyclopedia app
class AppTheme {
  // Cat Theme Colors
  static const Color catOrange = Color(0xFFFFB74D);
  static const Color catCream = Color(0xFFFFF3E0);
  static const Color catBrown = Color(0xFF8D5524);
  static const Color catLightBrown = Color(0xFF4E342E);

  /// Main theme for the app
  static ThemeData get theme => ThemeData(
    primaryColor: catOrange,
    scaffoldBackgroundColor: catCream,
    appBarTheme: const AppBarTheme(
      backgroundColor: catOrange,
      foregroundColor: Colors.brown,
      elevation: 2,
      iconTheme: IconThemeData(color: catBrown),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: catOrange,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      filled: true,
      fillColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: catLightBrown),
      titleMedium: TextStyle(fontWeight: FontWeight.bold, color: catBrown),
    ),
  );

  /// Custom AppBarTheme for favorites page
  static AppBarTheme get favoritesAppBarTheme => AppBarTheme(
    backgroundColor: catOrange,
    foregroundColor: Colors.white,
    elevation: 2,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}
