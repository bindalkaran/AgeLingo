import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/widgets/animated_gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  bool _isLastPage = false;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Welcome to AgeLingo",
      description: "Bridge the generational language gap and understand slang across all ages",
      image: "assets/images/onboarding1.png",
      icon: Icons.translate,
      color: AppTheme.primaryColor,
    ),
    OnboardingPage(
      title: "Extensive Dictionary",
      description: "Browse through hundreds of slang terms from Boomers to Gen Alpha",
      image: "assets/images/onboarding2.png",
      icon: Icons.book,
      color: AppTheme.secondaryColor,
    ),
    OnboardingPage(
      title: "Smart Translator",
      description: "Instantly translate slang between different generations",
      image: "assets/images/onboarding3.png",
      icon: Icons.switch_access_shortcut,
      color: AppTheme.boomersColor,
    ),
    OnboardingPage(
      title: "Ready to Start?",
      description: "Begin your journey to understanding all generations",
      image: "assets/images/onboarding4.png",
      icon: Icons.emoji_people,
      color: AppTheme.genZColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }
  
  void _completeOnboarding() async {
    HapticFeedback.mediumImpact();
    
    // Set onboarding as completed in shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    
    // Trigger the onComplete callback
    widget.onComplete();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                    _isLastPage = page == _pages.length - 1;
                  });
                  HapticFeedback.selectionClick();
                  _animationController.reset();
                  _animationController.forward();
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildPage(_pages[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            
            // Navigation section
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _pages[_currentPage].color
                              : _pages[_currentPage].color.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Next or Get Started button
                  AnimatedGradientButton(
                    label: _isLastPage ? "Get Started" : "Next",
                    icon: Icon(
                      _isLastPage ? Icons.rocket_launch : Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    gradientColors: [
                      _pages[_currentPage].color,
                      _pages[_currentPage].color.withOpacity(0.7),
                    ],
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or Icon placeholder
          Container(
            width: 180,
            height: 180,
            margin: const EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: page.color,
            ),
          ),
          
          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white70 
                  : Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
    required this.color,
  });
} 