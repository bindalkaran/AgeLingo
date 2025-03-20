import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/widgets/animated_gradient_button.dart';
import 'package:age_lingo/screens/dictionary_screen.dart';
import 'package:age_lingo/screens/translator_screen.dart';
import 'package:age_lingo/screens/settings_screen.dart';
import 'package:age_lingo/screens/custom_terms_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgeLingo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo and Tagline
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.translate,
                          size: 60,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Bridge Generational Language Gaps',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Understand language across all generations',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Dictionary Button
                AnimatedGradientButton(
                  label: 'Dictionary',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DictionaryScreen(),
                      ),
                    );
                  },
                  gradientColors: const [
                    Color(0xFF6A11CB),
                    Color(0xFF2575FC),
                  ],
                  icon: Icons.menu_book,
                ),
                
                const SizedBox(height: 20),
                
                // Translator Button
                AnimatedGradientButton(
                  label: 'Translator',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TranslatorScreen(),
                      ),
                    );
                  },
                  gradientColors: const [
                    Color(0xFF11998E),
                    Color(0xFF38EF7D),
                  ],
                  icon: Icons.translate,
                ),
                
                const SizedBox(height: 20),
                
                // Custom Terms Button
                AnimatedGradientButton(
                  label: 'Custom Terms',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomTermsScreen(),
                      ),
                    );
                  },
                  gradientColors: const [
                    Color(0xFFFF4E50),
                    Color(0xFFF9D423),
                  ],
                  icon: Icons.edit,
                ),
                
                const SizedBox(height: 40),
                
                // Generations Section
                const Text(
                  'Featured Generations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Generation Cards
                _buildGenerationCard(
                  context,
                  'Boomers',
                  'Born 1946-1964',
                  AppTheme.boomersColor,
                  isDarkMode,
                ),
                _buildGenerationCard(
                  context,
                  'Gen X',
                  'Born 1965-1980',
                  AppTheme.genXColor,
                  isDarkMode,
                ),
                _buildGenerationCard(
                  context,
                  'Millennials',
                  'Born 1981-1996',
                  AppTheme.millennialsColor,
                  isDarkMode,
                ),
                _buildGenerationCard(
                  context,
                  'Gen Z',
                  'Born 1997-2012',
                  AppTheme.genZColor,
                  isDarkMode,
                ),
                _buildGenerationCard(
                  context,
                  'Gen Alpha',
                  'Born 2013-Present',
                  AppTheme.genAlphaColor,
                  isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenerationCard(
    BuildContext context,
    String generation,
    String yearRange,
    Color color,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // Navigate to dictionary screen with the specific generation selected
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DictionaryScreen(
              initialGeneration: generation,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black12 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    generation,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    yearRange,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDarkMode ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
} 