import 'package:flutter/material.dart';

class AppTheme {
  // App Colors - Enhanced with more modern palette
  static const Color primaryColor = Color(0xFF6200EE); // Deep Purple
  static const Color secondaryColor = Color(0xFF03DAC6); // Teal
  static const Color accentColor = Color(0xFFFF4081); // Pink
  static const Color backgroundColor = Color(0xFFF8F9FA); // Light Grey/Off-White
  static const Color textPrimaryColor = Color(0xFF1D1D1D); // Nearly Black
  static const Color textSecondaryColor = Color(0xFF757575); // Medium Gray
  
  // Dark Theme Colors - Enhanced for better contrast
  static const Color darkPrimaryColor = Color(0xFFBB86FC); // Light Purple
  static const Color darkSecondaryColor = Color(0xFF03DAC6); // Teal
  static const Color darkAccentColor = Color(0xFFCF6679); // Dark Pink
  static const Color darkBackgroundColor = Color(0xFF121212); // Dark Background
  static const Color darkTextPrimaryColor = Color(0xFFFFFFFF); // Pure White
  static const Color darkTextSecondaryColor = Color(0xFFB3B3B3); // Light Gray

  // Generation Colors - Enhanced for better visibility
  static const Color boomersColor = Color(0xFF3949AB); // Indigo
  static const Color genXColor = Color(0xFF9C27B0); // Purple
  static const Color millennialsColor = Color(0xFF00897B); // Teal
  static const Color genZColor = Color(0xFFE91E63); // Pink
  static const Color genAlphaColor = Color(0xFFFF6D00); // Orange

  // Text Styles - Enhanced typography
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    letterSpacing: 0.25,
    color: textSecondaryColor,
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: Colors.white,
      onSurface: textPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textTheme: const TextTheme(
      displayLarge: headingStyle,
      displayMedium: subheadingStyle,
      bodyLarge: bodyStyle,
      bodySmall: captionStyle,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      background: darkBackgroundColor,
      surface: const Color(0xFF1E1E1E),
      onSurface: darkTextPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2D2D2D),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF2D2D2D),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFF3D3D3D),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textTheme: TextTheme(
      displayLarge: headingStyle.copyWith(color: darkTextPrimaryColor),
      displayMedium: subheadingStyle.copyWith(color: darkTextPrimaryColor),
      bodyLarge: bodyStyle.copyWith(color: darkTextPrimaryColor),
      bodySmall: captionStyle.copyWith(color: darkTextSecondaryColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF2D2D2D),
      selectedItemColor: darkPrimaryColor,
      unselectedItemColor: Colors.grey.shade500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}

// App constants
class AppConstants {
  static const List<String> generations = [
    'Boomers', 
    'Gen X', 
    'Millennials', 
    'Gen Z',
    'Gen Alpha'
  ];
  
  static const Map<String, String> generationInfo = {
    'Boomers': '1946-1964',
    'Gen X': '1965-1980',
    'Millennials': '1981-1996',
    'Gen Z': '1997-2012',
    'Gen Alpha': '2013-present'
  };
} 