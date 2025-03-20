import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:age_lingo/models/term.dart';
import 'package:age_lingo/utils/app_theme.dart';
import 'package:age_lingo/utils/term_service.dart';
import 'package:age_lingo/utils/settings_provider.dart';
import 'package:age_lingo/widgets/term_card.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        
        _filteredTerms = searchResults;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterTerms();
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
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                ),
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
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    height: 40,
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
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                ],
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
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: _filteredTerms.length,
                itemBuilder: (context, index) {
                  final term = _filteredTerms[index];
                  return TermCard(term: term);
                },
              ),
            ),
        ],
      ),
    );
  }
} 