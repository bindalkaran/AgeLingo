import 'package:flutter/material.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/utils/constants.dart';

class GenerationDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final String label;
  final ValueChanged<String?> onChanged;

  const GenerationDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  Color _getGenerationColor(String generation) {
    return getGenerationColor(generation);
  }

  String _getGenerationYears(String generation) {
    switch (generation) {
      case 'Boomers':
        return '1946-1964';
      case 'Gen X':
        return '1965-1980';
      case 'Millennials':
        return '1981-1996';
      case 'Gen Z':
        return '1997-2012';
      case 'Gen Alpha':
        return '2013-present';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? AppTheme.darkTextSecondaryColor : AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getGenerationColor(value).withOpacity(0.5),
              width: 1.5,
            ),
            color: _getGenerationColor(value).withOpacity(0.1),
          ),
          child: DropdownButton<String>(
            value: value,
            icon: Icon(
              Icons.arrow_drop_down,
              color: _getGenerationColor(value),
            ),
            elevation: 16,
            isExpanded: true,
            underline: Container(
              height: 0,
            ),
            style: TextStyle(
              color: isDarkMode ? AppTheme.darkTextPrimaryColor : AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            dropdownColor: isDarkMode ? AppTheme.darkBackgroundColor : Colors.white,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _getGenerationColor(value),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          color: isDarkMode ? AppTheme.darkTextPrimaryColor : AppTheme.textPrimaryColor,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        '(${_getGenerationYears(value)})',
                        style: TextStyle(
                          color: isDarkMode ? AppTheme.darkTextSecondaryColor : AppTheme.textSecondaryColor,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
} 