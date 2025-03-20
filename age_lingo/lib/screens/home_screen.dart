import 'package:flutter/material.dart';
import 'package:age_lingo/widgets/app_button.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/screens/translator_screen.dart';
import 'package:age_lingo/screens/dictionary_screen.dart';
import 'package:age_lingo/screens/custom_terms_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.translate,
              size: 100,
              color: AppTheme.primaryColor,
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
            AppButton(
              text: 'Translator',
              icon: Icons.translate,
              width: 280,
              height: 60,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TranslatorScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Dictionary',
              icon: Icons.book,
              width: 280,
              height: 60,
              color: AppTheme.secondaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DictionaryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Custom Terms',
              icon: Icons.edit_note,
              width: 280,
              height: 60,
              color: Colors.teal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomTermsScreen(),
                  ),
                );
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
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Gen Z',
                    style: TextStyle(
                      color: AppTheme.genZColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 