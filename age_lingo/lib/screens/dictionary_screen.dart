import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:age_lingo/models/term.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/utils/term_service.dart';
import 'package:age_lingo/utils/settings_provider.dart';
import 'package:age_lingo/widgets/term_card.dart';
import 'package:age_lingo/widgets/animated_term_card.dart';
import 'package:flutter/services.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TermService _termService = TermService();
  late TabController _tabController;
  List<Term> _filteredTerms = [];
  String _selectedGeneration = 'All';
  bool _isLoading = true;
  Term? _selectedTerm;
  bool _showDetailModal = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    setState(() {
      _isLoading = true;
    });
    
    await _termService.loadTerms();
    
    _filterTerms();
    
    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      return;
    }
    
    switch (_tabController.index) {
      case 0:
        _selectedGeneration = 'All';
        break;
      case 1:
        _selectedGeneration = 'Boomers';
        break;
      case 2:
        _selectedGeneration = 'Gen X';
        break;
      case 3:
        _selectedGeneration = 'Millennials';
        break;
      case 4:
        _selectedGeneration = 'Gen Z';
        break;
      case 5:
        _selectedGeneration = 'Gen Alpha';
        break;
    }
    
    _filterTerms();
  }

  void _filterTerms() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        if (_selectedGeneration == 'All') {
          _filteredTerms = _termService.getAllTerms();
        } else {
          _filteredTerms = _termService.getTermsByGeneration(_selectedGeneration);
        }
      } else {
        List<Term> searchResults = _termService.searchTerms(query);
        
        if (_selectedGeneration != 'All') {
          searchResults = searchResults
              .where((term) => term.generation == _selectedGeneration)
              .toList();
        }
        
        // Add search term to history if there are results
        if (searchResults.isNotEmpty) {
          Provider.of<SettingsProvider>(context, listen: false)
              .addToSearchHistory(query);
        }
        
        _filteredTerms = searchResults;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterTerms();
  }
  
  void _showTermDetails(Term term) {
    setState(() {
      _selectedTerm = term;
      _showDetailModal = true;
    });
    
    HapticFeedback.selectionClick();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildDetailBottomSheet(term),
    ).then((_) {
      setState(() {
        _showDetailModal = false;
      });
    });
  }
  
  Widget _buildDetailBottomSheet(Term term) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Term content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      term.word,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildGenerationBadge(term.generation),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  term.definition,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                
                Text(
                  'Example',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getGenerationColor(term.generation),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getGenerationColor(term.generation).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getGenerationColor(term.generation).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '"${term.example}"',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  'Translations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getGenerationColor(term.generation),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Translations list
                ...term.translations.keys
                    .where((gen) => gen != term.generation)
                    .map((gen) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.black12 : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _buildGenerationDot(gen),
                                    const SizedBox(width: 8),
                                    Text(
                                      gen,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  term.translations[gen] ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGenerationBadge(String generation) {
    final color = _getGenerationColor(generation);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        generation,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildGenerationDot(String generation) {
    final color = _getGenerationColor(generation);
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
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

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Boomers'),
            Tab(text: 'Gen X'),
            Tab(text: 'Millennials'),
            Tab(text: 'Gen Z'),
            Tab(text: 'Gen Alpha'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF2D2D2D) 
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search terms...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.black12 
                    : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              onChanged: (_) => _filterTerms(),
            ),
          ),
          
          // Recent searches
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              if (settings.searchHistory.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? const Color(0xFF2D2D2D) 
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Searches',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              settings.clearSearchHistory();
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: settings.searchHistory.length,
                        itemBuilder: (context, index) {
                          final query = settings.searchHistory[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ActionChip(
                              label: Text(query),
                              onPressed: () {
                                _searchController.text = query;
                                _filterTerms();
                              },
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                ),
              );
            },
          ),
          
          // Results
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_filteredTerms.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 70,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _searchController.text.isEmpty
                          ? 'No terms found for ${_selectedGeneration == 'All' ? 'any generation' : _selectedGeneration}'
                          : 'No matches found for "${_searchController.text}"',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                itemCount: _filteredTerms.length,
                itemBuilder: (context, index) {
                  final term = _filteredTerms[index];
                  return AnimatedTermCard(
                    term: term,
                    onTap: () => _showTermDetails(term),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
} 