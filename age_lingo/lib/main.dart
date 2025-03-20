import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:age_lingo/screens/home_screen.dart';
import 'package:age_lingo/screens/onboarding_screen.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/utils/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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

class _MyAppState extends State<MyApp> {
  late bool _showOnboarding;
  
  @override
  void initState() {
    super.initState();
    _showOnboarding = widget.showOnboarding;
  }

  void _completeOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'AgeLingo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            home: _showOnboarding
                ? OnboardingScreen(onComplete: _completeOnboarding)
                : const HomeScreen(),
            builder: (context, child) {
              // Optimize rendering performance for web
              return ScrollConfiguration(
                // Remove scrollbar on web and disable overscroll glow
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  physics: const ClampingScrollPhysics(),
                  platform: Theme.of(context).platform,
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
