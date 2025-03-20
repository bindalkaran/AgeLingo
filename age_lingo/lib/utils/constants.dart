import 'package:flutter/material.dart';

// List of supported generations
const List<String> generations = [
  'Boomers',
  'Gen X',
  'Millennials',
  'Gen Z',
  'Gen Alpha',
];

// Get the appropriate color for each generation
Color getGenerationColor(String generation) {
  switch (generation) {
    case 'Boomers':
      return Colors.purple;
    case 'Gen X':
      return Colors.blue;
    case 'Millennials':
      return Colors.orange;
    case 'Gen Z':
      return Colors.green;
    case 'Gen Alpha':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

// Get a description for each generation
String getGenerationDescription(String generation) {
  switch (generation) {
    case 'Boomers':
      return 'Baby Boomers (born 1946-1964)';
    case 'Gen X':
      return 'Generation X (born 1965-1980)';
    case 'Millennials':
      return 'Millennials (born 1981-1996)';
    case 'Gen Z':
      return 'Generation Z (born 1997-2012)';
    case 'Gen Alpha':
      return 'Generation Alpha (born 2013-present)';
    default:
      return '';
  }
} 