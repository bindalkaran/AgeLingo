import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/utils/term_service.dart';
import 'package:age_lingo/utils/settings_provider.dart';
import 'package:age_lingo/utils/constants.dart';
import 'package:age_lingo/widgets/generation_dropdown.dart';
import 'package:age_lingo/widgets/app_button.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TermService _termService = TermService();
  late String _sourceGeneration;
  late String _targetGeneration;
  TranslationResult? _translationResult;
  bool _isTranslating = false;
  bool _isListening = false;
  bool _showHistory = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  // Suggestions for the user
  List<String> _examplePhrases = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    
    // Set initial values from settings
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _sourceGeneration = settings.defaultSourceGeneration;
    _targetGeneration = settings.defaultTargetGeneration;
    
    // Generate some examples
    _updateExamplePhrases();
    
    // Add listener to input controller to hide history when typing
    _inputController.addListener(() {
      if (_showHistory && _inputController.text.isNotEmpty) {
        setState(() {
          _showHistory = false;
        });
      }
    });
  }

  void _initSpeech() async {
    await _speech.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _inputController.text = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
              }
            });
          },
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  void _translate() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    
    // Add to search history
    Provider.of<SettingsProvider>(context, listen: false).addToSearchHistory(text);
    
    setState(() {
      _isTranslating = true;
      _showHistory = false;
    });
    
    // Simulate a brief loading time for better UX
    await Future.delayed(const Duration(milliseconds: 300));
    
    final result = _termService.translateEnhanced(
      text, 
      _sourceGeneration, 
      _targetGeneration
    );
    
    setState(() {
      _translationResult = result;
      _isTranslating = false;
    });
  }

  void _swapGenerations() {
    setState(() {
      final temp = _sourceGeneration;
      _sourceGeneration = _targetGeneration;
      _targetGeneration = temp;
      _updateExamplePhrases();
    });
    
    if (_translationResult != null) {
      _translate();
    }
  }

  void _updateExamplePhrases() {
    // Get random phrases for the selected source generation
    final terms = _termService.getTermsByGeneration(_sourceGeneration);
    _examplePhrases = [];
    
    if (terms.isNotEmpty) {
      // Select some random examples
      terms.shuffle();
      final selectedTerms = terms.take(3).toList();
      
      for (var term in selectedTerms) {
        _examplePhrases.add(term.example);
      }
    }
  }

  void _useExample(String example) {
    _inputController.text = example;
    _translate();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                
                // Input field
                _buildInputSection(),
                
                const SizedBox(height: 24),
                
                // Generation Selectors
                Row(
                  children: [
                    Expanded(
                      child: GenerationDropdown(
                        value: _sourceGeneration,
                        items: generations,
                        label: 'From',
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sourceGeneration = value;
                              _updateExamplePhrases();
                              if (_translationResult != null) {
                                _translate();
                              }
                            });
                          }
                        },
                      ),
                    ),
                    
                    // Swap button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: _swapGenerations,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    
                    Expanded(
                      child: GenerationDropdown(
                        value: _targetGeneration,
                        items: generations,
                        label: 'To',
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _targetGeneration = value;
                              if (_translationResult != null) {
                                _translate();
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Translate button
                Center(
                  child: AppButton(
                    text: 'Translate',
                    icon: Icons.translate,
                    onPressed: _translate,
                    width: 200,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Result box
                if (_isTranslating)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_translationResult != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getGenerationColor(_targetGeneration).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getGenerationColor(_targetGeneration).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Translation (${_targetGeneration}):',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (_translationResult!.translatedCount > 0)
                              Text(
                                '${_translationResult!.translatedCount} term(s) translated',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getGenerationColor(_targetGeneration),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            children: _buildTranslatedTextSpans(),
                          ),
                        ),
                        
                        // Translation details
                        if (_translationResult!.translatedCount > 0) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          const Text(
                            'Translation Details:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._buildTranslationDetailWidgets(),
                        ],
                        
                        // No translations message
                        if (_translationResult!.translatedCount == 0) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'No generational terms found to translate.',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try using more ${_sourceGeneration} slang in your text.',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: 'Enter text to translate...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_inputController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _inputController.clear();
                                  setState(() {
                                    _translationResult = null;
                                  });
                                },
                              ),
                            IconButton(
                              icon: Icon(
                                _showHistory ? Icons.history_toggle_off : Icons.history,
                                color: _showHistory ? Theme.of(context).primaryColor : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showHistory = !_showHistory;
                                });
                              },
                            ),
                            if (Provider.of<SettingsProvider>(context).enableSpeechToText)
                              IconButton(
                                icon: Icon(
                                  Icons.mic,
                                  color: _isListening ? Colors.red : null,
                                ),
                                onPressed: () {
                                  _isListening ? _stopListening() : _startListening();
                                },
                              ),
                          ],
                        ),
                        prefixIcon: const Icon(Icons.translate),
                      ),
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _translate(),
                    ),
                  ),
                ],
              ),
              
              // History list
              if (_showHistory) _buildHistoryList(),
            ],
          ),
        ),
        
        // Example phrases section
        const SizedBox(height: 16),
        _buildExamplePhrases(),
      ],
    );
  }
  
  Widget _buildHistoryList() {
    final history = Provider.of<SettingsProvider>(context).searchHistory;
    
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("No search history yet"),
      );
    }
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
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
                Provider.of<SettingsProvider>(context, listen: false)
                    .removeFromSearchHistory(history[index]);
                setState(() {});
              },
            ),
            onTap: () {
              setState(() {
                _inputController.text = history[index];
                _showHistory = false;
              });
              _translate();
            },
          );
        },
      ),
    );
  }
  
  Widget _buildExamplePhrases() {
    if (_examplePhrases.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8,
      children: _examplePhrases.map((phrase) {
        return ActionChip(
          label: Text(
            phrase.length > 30 ? '${phrase.substring(0, 27)}...' : phrase,
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: _getGenerationColor(_sourceGeneration).withOpacity(0.1),
          side: BorderSide(
            color: _getGenerationColor(_sourceGeneration).withOpacity(0.3),
          ),
          onPressed: () => _useExample(phrase),
        );
      }).toList(),
    );
  }
  
  // Create spans for the translated text with highlighting
  List<InlineSpan> _buildTranslatedTextSpans() {
    if (_translationResult == null) return [];
    
    List<InlineSpan> spans = [];
    
    for (var word in _translationResult!.words) {
      if (word.wasTranslated) {
        spans.add(TextSpan(
          text: '${word.translated} ',
          style: TextStyle(
            color: _getGenerationColor(_targetGeneration),
            fontWeight: FontWeight.bold,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: '${word.original} ',
        ));
      }
    }
    
    return spans;
  }
  
  // Build widgets showing translation details
  List<Widget> _buildTranslationDetailWidgets() {
    if (_translationResult == null) return [];
    
    List<Widget> details = [];
    
    for (var word in _translationResult!.words) {
      if (word.wasTranslated && word.term != null) {
        details.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getGenerationColor(_sourceGeneration).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '"${word.original}"',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getGenerationColor(_sourceGeneration),
                      ),
                    ),
                    const Text(' → '),
                    Text(
                      '"${word.translated}"',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getGenerationColor(_targetGeneration),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  word.term!.definition,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    
    return details;
  }
  
  Color _getGenerationColor(String generation) {
    return getGenerationColor(generation);
  }
} 