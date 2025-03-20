import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:age_lingo/models/term.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/utils/term_service.dart';
import 'package:age_lingo/widgets/animated_gradient_button.dart';

class CustomTermsScreen extends StatefulWidget {
  const CustomTermsScreen({Key? key}) : super(key: key);

  @override
  _CustomTermsScreenState createState() => _CustomTermsScreenState();
}

class _CustomTermsScreenState extends State<CustomTermsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _definitionController = TextEditingController();
  final _exampleController = TextEditingController();
  final Map<String, TextEditingController> _translationControllers = {
    'Boomers': TextEditingController(),
    'Gen X': TextEditingController(),
    'Millennials': TextEditingController(),
    'Gen Z': TextEditingController(),
    'Gen Alpha': TextEditingController(),
  };
  
  String _selectedGeneration = 'Gen Z';
  bool _isSubmitting = false;
  final TermService _termService = TermService();
  
  @override
  void initState() {
    super.initState();
    _termService.loadTerms();
  }
  
  @override
  void dispose() {
    _wordController.dispose();
    _definitionController.dispose();
    _exampleController.dispose();
    _translationControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }
  
  void _resetForm() {
    _wordController.clear();
    _definitionController.clear();
    _exampleController.clear();
    _translationControllers.forEach((_, controller) => controller.clear());
    setState(() {
      _selectedGeneration = 'Gen Z';
      _isSubmitting = false;
    });
  }
  
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    try {
      // Create translation map
      final Map<String, String> translations = {};
      _translationControllers.forEach((generation, controller) {
        if (controller.text.isNotEmpty) {
          translations[generation] = controller.text;
        }
      });
      
      // Create new term
      final newTerm = Term(
        word: _wordController.text.trim(),
        definition: _definitionController.text.trim(),
        generation: _selectedGeneration,
        example: _exampleController.text.trim(),
        translations: translations,
      );
      
      // Add term to service
      await _termService.addCustomTerm(newTerm);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Term "${newTerm.word}" added successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Reset form
      _resetForm();
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding term: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Term'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Header
              Text(
                'Create Your Own Term',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Add slang or generational terms to your personal dictionary',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Term section
              Text(
                'TERM DETAILS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              
              // Word field
              TextFormField(
                controller: _wordController,
                decoration: InputDecoration(
                  labelText: 'Word or Phrase',
                  hintText: 'Enter the slang term',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.text_fields),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word or phrase';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Definition field
              TextFormField(
                controller: _definitionController,
                decoration: InputDecoration(
                  labelText: 'Definition',
                  hintText: 'What does this term mean?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a definition';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Example field
              TextFormField(
                controller: _exampleController,
                decoration: InputDecoration(
                  labelText: 'Example',
                  hintText: 'Example sentence using this term',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.format_quote),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide an example';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Generation selector
              DropdownButtonFormField<String>(
                value: _selectedGeneration,
                decoration: InputDecoration(
                  labelText: 'Generation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.people),
                ),
                items: const [
                  DropdownMenuItem(value: 'Boomers', child: Text('Boomers')),
                  DropdownMenuItem(value: 'Gen X', child: Text('Gen X')),
                  DropdownMenuItem(value: 'Millennials', child: Text('Millennials')),
                  DropdownMenuItem(value: 'Gen Z', child: Text('Gen Z')),
                  DropdownMenuItem(value: 'Gen Alpha', child: Text('Gen Alpha')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedGeneration = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              
              // Translations section
              Text(
                'TRANSLATIONS FOR OTHER GENERATIONS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'How would other generations say this? (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              
              // Translation fields for each generation
              ..._translationControllers.entries
                  .where((entry) => entry.key != _selectedGeneration)
                  .map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText: entry.key,
                        hintText: 'Equivalent term for ${entry.key}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(
                          Icons.translate,
                          color: _getGenerationColor(entry.key),
                        ),
                      ),
                    ),
                  ))
                  .toList(),
              
              const SizedBox(height: 32),
              
              // Submit button
              AnimatedGradientButton(
                label: _isSubmitting ? 'Adding...' : 'Add Term',
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                gradientColors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withBlue(AppTheme.primaryColor.blue - 40),
                ],
                isLoading: _isSubmitting,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 16),
              
              // Reset button
              TextButton(
                onPressed: _resetForm,
                child: const Text('Reset Form'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
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
      case 'Gen Alpha':
        return AppTheme.genAlphaColor;
      default:
        return Colors.grey;
    }
  }
} 