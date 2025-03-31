import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/componenets/pokeballLoading.dart';
import 'package:mobile/componenets/pokemonSearchItem.dart';

class PokemonSearch extends StatefulWidget {
  final Map<String, dynamic>? team;
  const PokemonSearch({super.key, this.team});

  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _pokemonResults = [];
  bool _isLoading = false;
  bool _isFetchingMore = false; 
  bool _noMoreResults = false; 
  int _offset = 0;
  Timer? _debounce; 
  String _isRequestInProgress = '';

  final ApiService apiService = ApiService();

  Future<void> _searchPokemon(String query, {int offset = 0}) async {
    if (_isRequestInProgress != query) {
      _pokemonResults = [];
      _offset = 0;
      _noMoreResults = false;
    }

    if (!mounted) return; 

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
      if (_isRequestInProgress == query && mounted) {
        // Ensure widget is still mounted
        setState(() {
          _pokemonResults.addAll(results);
          _offset = offset + results.length;

          if (results.length < 8) {
            _noMoreResults = true;
          }
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _noMoreResults = true;
          //  _pokemonResults = [];
        });
      }
    } finally {
      if (_isRequestInProgress == query && mounted) {
        // Ensure widget is still mounted
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
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel(); // Cancel previous timer
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Ensure widget is still mounted before calling _searchPokemon
        _searchPokemon(query);
      }
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
    _debounce?.cancel(); // Cancel any active debounce timer
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
                          color: ColorClass.fromCssColorName(pokemon['color']),
                          name: pokemon['name'],
                          index: pokemon['pokedexNumber'],
                          team: widget.team,
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

          SizedBox(height: 32),
        ],
      ),
    );
  }
}
