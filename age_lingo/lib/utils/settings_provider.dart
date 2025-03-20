import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _defaultSourceGeneration = 'Gen Z';
  String _defaultTargetGeneration = 'Boomers';
  bool _enableSpeechToText = true;
  List<String> _searchHistory = [];
  final int _maxSearchHistoryItems = 10;

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get defaultSourceGeneration => _defaultSourceGeneration;
  String get defaultTargetGeneration => _defaultTargetGeneration;
  bool get enableSpeechToText => _enableSpeechToText;
  List<String> get searchHistory => _searchHistory;

  SettingsProvider() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _defaultSourceGeneration = prefs.getString('defaultSourceGeneration') ?? 'Gen Z';
    _defaultTargetGeneration = prefs.getString('defaultTargetGeneration') ?? 'Boomers';
    _enableSpeechToText = prefs.getBool('enableSpeechToText') ?? true;
    
    final historyJson = prefs.getString('searchHistory');
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      _searchHistory = decoded.map((item) => item.toString()).toList();
    }
    
    notifyListeners();
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('defaultSourceGeneration', _defaultSourceGeneration);
    await prefs.setString('defaultTargetGeneration', _defaultTargetGeneration);
    await prefs.setBool('enableSpeechToText', _enableSpeechToText);
    await prefs.setString('searchHistory', jsonEncode(_searchHistory));
  }

  // Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveSettings();
    notifyListeners();
  }

  // Update default source generation
  void updateDefaultSourceGeneration(String generation) {
    _defaultSourceGeneration = generation;
    _saveSettings();
    notifyListeners();
  }

  // Update default target generation
  void updateDefaultTargetGeneration(String generation) {
    _defaultTargetGeneration = generation;
    _saveSettings();
    notifyListeners();
  }

  // Toggle speech-to-text
  void toggleSpeechToText() {
    _enableSpeechToText = !_enableSpeechToText;
    _saveSettings();
    notifyListeners();
  }
  
  // Add search query to history
  void addToSearchHistory(String query) {
    if (query.trim().isEmpty) return;
    
    // Remove if already exists to avoid duplicates
    _searchHistory.removeWhere((item) => item == query);
    
    // Add to beginning of list
    _searchHistory.insert(0, query);
    
    // Trim list if needed
    if (_searchHistory.length > _maxSearchHistoryItems) {
      _searchHistory = _searchHistory.sublist(0, _maxSearchHistoryItems);
    }
    
    _saveSettings();
    notifyListeners();
  }
  
  // Clear search history
  void clearSearchHistory() {
    _searchHistory = [];
    _saveSettings();
    notifyListeners();
  }
  
  // Remove a specific search history item
  void removeFromSearchHistory(String query) {
    _searchHistory.removeWhere((item) => item == query);
    _saveSettings();
    notifyListeners();
  }
} 