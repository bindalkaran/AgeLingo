import 'package:flutter/material.dart';
import 'package:age_lingo/models/term.dart';
import 'package:age_lingo/utils/term_service.dart';
import 'package:age_lingo/widgets/term_card.dart';
import 'package:age_lingo/utils/constants.dart';

class CustomTermsScreen extends StatefulWidget {
  const CustomTermsScreen({Key? key}) : super(key: key);

  @override
  _CustomTermsScreenState createState() => _CustomTermsScreenState();
}

class _CustomTermsScreenState extends State<CustomTermsScreen> {
  final TermService _termService = TermService();
  List<Term> _customTerms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomTerms();
  }

  void _loadCustomTerms() {
    setState(() {
      _customTerms = _termService.getCustomTerms();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Terms'),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _customTerms.isEmpty 
          ? _buildEmptyState()
          : _buildTermsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditTermDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Custom Terms Yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your own generation-specific terms to enhance your translation experience',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddEditTermDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Term'),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _customTerms.length,
      itemBuilder: (context, index) {
        final term = _customTerms[index];
        return Dismissible(
          key: Key(term.word + term.generation),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Term'),
                content: Text('Are you sure you want to delete "${term.word}"?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) async {
            await _termService.deleteCustomTerm(term.word, term.generation);
            setState(() {
              _customTerms.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${term.word} has been deleted')),
            );
          },
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => _showAddEditTermDialog(term: term),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            term.word,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Chip(
                          label: Text(term.generation),
                          backgroundColor: getGenerationColor(term.generation).withOpacity(0.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(term.definition),
                    const SizedBox(height: 8),
                    Text(
                      'Example: ${term.example}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Translations:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ...term.translations.entries.map((entry) => 
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(entry.value.isEmpty ? 'Not specified' : entry.value),
                          ],
                        ),
                      ),
                    ).toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddEditTermDialog({Term? term}) {
    // Controllers
    TextEditingController wordController = TextEditingController(text: term?.word ?? '');
    TextEditingController definitionController = TextEditingController(text: term?.definition ?? '');
    TextEditingController exampleController = TextEditingController(text: term?.example ?? '');
    
    Map<String, TextEditingController> translationControllers = {};
    
    // Set up controllers for translations
    for (var generation in generations) {
      if (term != null && term.generation != generation) {
        translationControllers[generation] = TextEditingController(
          text: term.translations[generation] ?? ''
        );
      } else if (term == null) {
        translationControllers[generation] = TextEditingController();
      }
    }
    
    // Track the selected generation
    String selectedGeneration = term?.generation ?? generations.first;
    bool isEditing = term != null;
    String originalWord = term?.word ?? '';
    String originalGeneration = term?.generation ?? '';
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Term' : 'Add New Term'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: wordController,
                      decoration: const InputDecoration(
                        labelText: 'Term',
                        hintText: 'Enter the word or phrase',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Generation:'),
                    DropdownButton<String>(
                      value: selectedGeneration,
                      isExpanded: true,
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedGeneration = value;
                          });
                        }
                      },
                      items: generations.map((generation) {
                        return DropdownMenuItem<String>(
                          value: generation,
                          child: Text(generation),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: definitionController,
                      decoration: const InputDecoration(
                        labelText: 'Definition',
                        hintText: 'What does this term mean?',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: exampleController,
                      decoration: const InputDecoration(
                        labelText: 'Example',
                        hintText: 'Example usage of this term',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Translations for other generations:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...generations.where((gen) => gen != selectedGeneration).map((generation) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: translationControllers[generation],
                          decoration: InputDecoration(
                            labelText: generation,
                            hintText: 'Translation for $generation',
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validate inputs
                    if (wordController.text.isEmpty || definitionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Term and definition are required')),
                      );
                      return;
                    }
                    
                    // Create translations map
                    Map<String, String> translations = {};
                    for (var generation in generations) {
                      if (generation != selectedGeneration) {
                        translations[generation] = translationControllers[generation]!.text;
                      }
                    }
                    
                    // Create the term
                    Term newTerm = Term(
                      word: wordController.text,
                      generation: selectedGeneration,
                      definition: definitionController.text,
                      translations: translations,
                      example: exampleController.text,
                    );
                    
                    bool success;
                    if (isEditing) {
                      success = await _termService.editCustomTerm(
                        originalWord, 
                        originalGeneration,
                        newTerm
                      );
                    } else {
                      success = await _termService.addCustomTerm(newTerm);
                    }
                    
                    if (success) {
                      _loadCustomTerms();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEditing 
                            ? 'Term updated successfully' 
                            : 'New term added successfully'
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('A term with this name already exists'),
                        ),
                      );
                    }
                  },
                  child: Text(isEditing ? 'Update' : 'Add'),
                ),
              ],
            );
          }
        );
      },
    );
  }
} 