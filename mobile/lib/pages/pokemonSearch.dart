import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/componenets/pokeballLoading.dart';
import 'package:mobile/componenets/pokemonSearchItem.dart';

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({super.key});

  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _pokemonResults = [];
  bool _isLoading = false;
  bool _isFetchingMore = false; // Flag to track fetching more data
  bool _noMoreResults = false; // Flag to indicate no more results
  int _offset = 0; // To handle pagination offset
  Timer? _debounce; // Timer for debounce
  String _isRequestInProgress = ''; // To track if a request is in progress

  // Instance of ApiService to fetch data
  final ApiService apiService = ApiService();

  // Fetch Pokemon search results from the API with pagination
  Future<void> _searchPokemon(String query, {int offset = 0}) async {
    // Reset pagination and results if a new search is performed
    if (_isRequestInProgress != query) {
      _offset = 0; // Reset offset for new search
      _noMoreResults = false; // Reset noMoreResults flag for new search
    }

    if (_isRequestInProgress != '') {
      _isRequestInProgress = '';
    }

    setState(() {
      if (offset == 0) {
        _isLoading = true;
      } else {
        _isFetchingMore = true;
      }
      _isRequestInProgress = query;
    });

    try {
      final results = await apiService.searchPokemon(query, offset: offset);

      // request relevant?
      if (_isRequestInProgress == query) {
        setState(() {
          _pokemonResults.addAll(results);
          _offset = offset + results.length;

          if (results.length < 8) {
            _noMoreResults = true;
          }
        });
      }
    } catch (error) {
      setState(() {
        _pokemonResults = [];
      });
    } finally {
      if (_isRequestInProgress == query) {
        setState(() {
          if (offset == 0) {
            _isLoading = false;
          } else {
            _isFetchingMore = false;
          }
        });
      }
    }
  }

  // Handle the search input change with debounce
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false)
      _debounce?.cancel(); // Cancel previous timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Trigger search after a 500ms delay
      _searchPokemon(query);
    });
  }

  // Detect when user has scrolled to the bottom and fetch more data
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Fetch more data when scrolled to the bottom
      if (!_isFetchingMore && !_noMoreResults) {
        final query = _searchController.text;
        if (query.isNotEmpty || _pokemonResults.isNotEmpty) {
          _searchPokemon(query, offset: _offset); // Fetch more data
        }
      }
    }
  }

  // Scroll controller to monitor scrolling behavior
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Trigger the initial search when the widget is loaded
    _searchPokemon('', offset: 0); // Ensure the first fetch happens
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          // PADDING
          SizedBox(height: 64 + 24),

          // SEARCH BAR
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            height: 42,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: -8,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              cursorColor: Theme.of(context).colorScheme.secondary,
              onChanged: _onSearchChanged, // Use debounced onChanged handler
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).shadowColor,
                ),
              ),
            ),
          ),

          // POKEMON DISPLAY
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child:
                _isLoading
                    ? SizedBox(height: 16)
                    : _pokemonResults.isEmpty
                    ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "No Pokémon found",
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(117, 0, 0, 0),
                          ),
                        ),
                      ),
                    ) // Show message if no results found
                    : GridView.builder(
                      itemCount:
                          _pokemonResults
                              .length, // Add an extra item for the loading indicator
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        if (index == _pokemonResults.length &&
                            _isFetchingMore) {
                          return SizedBox.shrink(); // Remove the loading spinner from GridView
                        }
                        final pokemon = _pokemonResults[index];
                        return PokemonSearchItem(
                          color: CssColorConverter.fromCssColorName(
                            pokemon['color'],
                          ),
                          name: pokemon['name'],
                          index: pokemon['pokedexNumber'],
                        );
                      },
                    ),
          ),

          // BOTTOM LOADER: Positioned outside the GridView
          if ((!_noMoreResults && _pokemonResults.isNotEmpty) || _isLoading)
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Container(
                width: double.infinity, // Make it stretch across the screen
                child: Center(
                  child: PokeballLoader(),
                ), // Show loading indicator
              ),
            ),
        ],
      ),
    );
  }
}
