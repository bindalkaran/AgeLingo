import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/utils/settings_provider.dart';
import 'package:age_lingo/widgets/generation_dropdown.dart';
import 'package:age_lingo/utils/constants.dart';
import 'package:age_lingo/widgets/app_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildThemeSection(context),
              const SizedBox(height: 24),
              _buildDefaultGenerationsSection(context),
              const SizedBox(height: 24),
              _buildSpeechToTextSection(context),
              const SizedBox(height: 24),
              _buildSearchHistorySection(context),
              const SizedBox(height: 24),
              _buildAboutSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark theme'),
              value: isDarkMode,
              onChanged: (value) {
                settings.toggleDarkMode();
              },
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultGenerationsSection(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Default Generations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GenerationDropdown(
              value: settings.defaultSourceGeneration,
              items: generations,
              label: 'Source Generation',
              onChanged: (generation) {
                if (generation != null) {
                  settings.updateDefaultSourceGeneration(generation);
                }
              },
            ),
            const SizedBox(height: 16),
            GenerationDropdown(
              value: settings.defaultTargetGeneration,
              items: generations,
              label: 'Target Generation',
              onChanged: (generation) {
                if (generation != null) {
                  settings.updateDefaultTargetGeneration(generation);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSpeechToTextSection(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final enableSpeechToText = settings.enableSpeechToText;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Speech Recognition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Speech-to-Text'),
              subtitle: const Text('Convert your speech to text for translation'),
              value: enableSpeechToText,
              onChanged: (value) {
                settings.toggleSpeechToText();
              },
              secondary: const Icon(Icons.mic),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSearchHistorySection(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final history = settings.searchHistory;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (history.isNotEmpty)
                  TextButton.icon(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear Search History'),
                          content: const Text('Are you sure you want to clear all your search history?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                settings.clearSearchHistory();
                                Navigator.pop(context);
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('No search history yet'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length > 5 ? 5 : history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(history[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        settings.removeFromSearchHistory(history[index]);
                      },
                    ),
                  );
                },
              ),
            if (history.length > 5)
              Center(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Full Search History'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.history),
                                title: Text(history[index]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    settings.removeFromSearchHistory(history[index]);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('View all history'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About AgeLingo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'AgeLingo helps bridge the communication gap between generations by translating slang and generational language.',
            ),
            const SizedBox(height: 16),
            const Text('Version 1.1.0'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  text: 'Rate App',
                  icon: Icons.star,
                  onPressed: () {
                    // Open app store rating page
                  },
                  width: 120,
                  height: 40,
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: 'Share App',
                  icon: Icons.share,
                  onPressed: () {
                    // Share app link
                  },
                  width: 120,
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 