import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:age_lingo/screens/home_screen.dart';
import 'package:age_lingo/screens/onboarding_screen.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/utils/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check if onboarding is complete
  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = !(prefs.getBool('onboarding_complete') ?? false);

  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatefulWidget {
  final bool showOnboarding;
  
  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late final SettingsProvider _settingsProvider;
  late final AnimationController _animationController;
  late bool _showOnboarding;
  
  @override
  void initState() {
    super.initState();
    _settingsProvider = SettingsProvider();
    _showOnboarding = widget.showOnboarding;
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Initialize the animation to fully visible if not showing onboarding
    if (!_showOnboarding) {
      _animationController.value = 1.0;
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _onOnboardingComplete() {
    // First refresh settings
    _settingsProvider.refreshSettings();
    
    // Then update state
    setState(() {
      _showOnboarding = false;
    });
    
    // Then start the animation
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _settingsProvider,
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'AgeLingo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: _showOnboarding 
                ? OnboardingScreen(onComplete: _onOnboardingComplete)
                : AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeIn,
                          ),
                        ),
                        child: child,
                      );
                    },
                    child: const HomeScreen(),
                  ),
          );
        },
      ),
    );
  }
}
