import 'package:flutter/material.dart';
import 'package:age_lingo/widgets/app_button.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/screens/translator_screen.dart';
import 'package:age_lingo/screens/dictionary_screen.dart';
import 'package:age_lingo/screens/custom_terms_screen.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    
    // Start the animation
    _controller.forward();
    
    // Add haptic feedback
    HapticFeedback.lightImpact();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgeLingo'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App icon with animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: const Icon(
                        Icons.translate,
                        size: 100,
                        color: AppTheme.primaryColor,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'AgeLingo',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bridging the generational language gap',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 48),
                _buildAnimatedButton(
                  'Translator',
                  Icons.translate,
                  AppTheme.primaryColor,
                  0,
                  () {
                    _onButtonPressed(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TranslatorScreen(),
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildAnimatedButton(
                  'Dictionary',
                  Icons.book,
                  AppTheme.secondaryColor,
                  150,
                  () {
                    _onButtonPressed(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DictionaryScreen(),
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildAnimatedButton(
                  'Custom Terms',
                  Icons.edit_note,
                  Colors.teal,
                  300,
                  () {
                    _onButtonPressed(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomTermsScreen(),
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(height: 48),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Learn to speak ',
                      ),
                      TextSpan(
                        text: 'Boomer',
                        style: TextStyle(
                          color: AppTheme.boomersColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ', '),
                      TextSpan(
                        text: 'Gen X',
                        style: TextStyle(
                          color: AppTheme.genXColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ', '),
                      TextSpan(
                        text: 'Millennial',
                        style: TextStyle(
                          color: AppTheme.millennialsColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ', '),
                      TextSpan(
                        text: 'Gen Z',
                        style: TextStyle(
                          color: AppTheme.genZColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Gen Alpha',
                        style: TextStyle(
                          color: AppTheme.genAlphaColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Developed by Karan Bindal',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Animated button with staggered entrance
  Widget _buildAnimatedButton(String text, IconData icon, Color color, int delayMilliseconds, VoidCallback onPressed) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: AppButton(
              text: text,
              icon: icon,
              width: 280,
              height: 60,
              color: color,
              onPressed: onPressed,
            ),
          ),
        );
      },
    );
  }
  
  // Handle button press with haptic feedback
  void _onButtonPressed(VoidCallback callback) {
    HapticFeedback.mediumImpact();
    callback();
  }
} 