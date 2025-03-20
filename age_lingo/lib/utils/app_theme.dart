import 'package:flutter/material.dart';

class AppTheme {
  // App Colors
  static const Color primaryColor = Color(0xFF6A5ACD); // Purple/Indigo
  static const Color secondaryColor = Color(0xFF87CEEB); // Light Blue
  static const Color accentColor = Color(0xFFFFB6C1); // Light Pink
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light Grey/Off-White
  static const Color textPrimaryColor = Color(0xFF333333); // Dark Gray
  static const Color textSecondaryColor = Color(0xFF666666); // Medium Gray
  
  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF6A5ACD);
  static const Color darkSecondaryColor = Color(0xFF4682B4); // Darker Blue
  static const Color darkAccentColor = Color(0xFFFF6B81); // Darker Pink
  static const Color darkBackgroundColor = Color(0xFF121212); // Dark Background
  static const Color darkTextPrimaryColor = Color(0xFFEEEEEE); // Light Gray
  static const Color darkTextSecondaryColor = Color(0xFFAAAAAA); // Medium Light Gray

  // Generation Colors
  static const Color boomersColor = Color(0xFF87CEFA); // Light Sky Blue
  static const Color genXColor = Color(0xFFDA70D6); // Orchid
  static const Color millennialsColor = Color(0xFF90EE90); // Light Green
  static const Color genZColor = Color(0xFFFFB6C1); // Light Pink
  static const Color genAlphaColor = Color(0xFFFF6347); // Tomato Red

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
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
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: headingStyle,
      displayMedium: subheadingStyle,
      bodyLarge: bodyStyle,
      bodySmall: captionStyle,
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
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: headingStyle.copyWith(color: darkTextPrimaryColor),
      displayMedium: subheadingStyle.copyWith(color: darkTextPrimaryColor),
      bodyLarge: bodyStyle.copyWith(color: darkTextPrimaryColor),
      bodySmall: captionStyle.copyWith(color: darkTextSecondaryColor),
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