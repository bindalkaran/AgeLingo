import 'package:flutter/material.dart';
import 'package:age_lingo/models/term.dart';
import 'package:age_lingo/utils/app_theme.dart';

class TermCard extends StatelessWidget {
  final Term term;
  final VoidCallback? onTap;

  const TermCard({
    Key? key,
    required this.term,
    this.onTap,
  }) : super(key: key);

  Color _getGenerationColor(String generation) {
    switch (generation) {
      case 'Boomers':
        return AppTheme.boomersColor;
      case 'Gen X':
        return AppTheme.genXColor;
      case 'Millennials':
        return AppTheme.millennialsColor;
      case 'Gen Z':
        return AppTheme.genZColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final generationColor = _getGenerationColor(term.generation);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: generationColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    term.word,
                    style: AppTheme.subheadingStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLightMode ? AppTheme.textPrimaryColor : AppTheme.darkTextPrimaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: generationColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: generationColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      term.generation,
                      style: TextStyle(
                        color: generationColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                term.definition,
                style: AppTheme.bodyStyle.copyWith(
                  color: isLightMode ? AppTheme.textPrimaryColor : AppTheme.darkTextPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Example: "${term.example}"',
                style: AppTheme.captionStyle.copyWith(
                  fontStyle: FontStyle.italic,
                  color: isLightMode ? AppTheme.textSecondaryColor : AppTheme.darkTextSecondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Translations:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isLightMode ? AppTheme.textPrimaryColor : AppTheme.darkTextPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: term.translations.entries.map((entry) {
                  final translationGenColor = _getGenerationColor(entry.key);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: translationGenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: translationGenColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${entry.key}: ',
                            style: TextStyle(
                              color: translationGenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: entry.value,
                            style: TextStyle(
                              color: isLightMode ? AppTheme.textPrimaryColor : AppTheme.darkTextPrimaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 