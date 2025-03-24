import 'dart:async';  // Add this import for Timer
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/ColorConverter.dart';
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
  Timer? _debounce;  // Timer for debounce
  bool _isRequestInProgress = false;  // To track if a request is in progress

  // Fetch Pokemon search results from the API
  Future<void> _searchPokemon(String query) async {
    if (query.isEmpty) {
      setState(() {
        _pokemonResults = [];
      });
      return;
    }

    // Cancel the previous request if there is an ongoing one
    if (_isRequestInProgress) {
      _isRequestInProgress = false; // Mark previous request as canceled
    }

    setState(() {
      _isLoading = true;
      _isRequestInProgress = true;  // Mark new request as in progress
    });

    try {
      final response = await http.get(Uri.parse('http://157.230.80.230:5001/pokemon/search/$query'));

      if (_isRequestInProgress) { // Proceed only if the request was not canceled
        if (response.statusCode == 200) {
          final List<dynamic> result = json.decode(response.body);
          setState(() {
            _pokemonResults = result;
          });
        } else {
          setState(() {
            _pokemonResults = [];
          });
        }
      }
    } catch (error) {
      setState(() {
        _pokemonResults = [];
      });
    } finally {
      if (_isRequestInProgress) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Handle the search input change with debounce
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();  // Cancel previous timer
    _debounce = Timer(const Duration(milliseconds: 500), () {  // Trigger search after a 500ms delay
      _searchPokemon(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // PADDING
          SizedBox(height: 100),

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
              onChanged: _onSearchChanged,  // Use debounced onChanged handler
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
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())  // Show loading indicator while fetching data
                : _pokemonResults.isEmpty
                    ? Center(child: Text("No Pokémon found"))  // Show message if no results found
                    : GridView.builder(
                        itemCount: _pokemonResults.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final pokemon = _pokemonResults[index];
                          return PokemonSearchItem(
                            color: CssColorConverter.fromCssColorName(pokemon['color']), 
                            name: pokemon['name'],
                            index: pokemon['pokedexNumber'],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel(); 
    super.dispose();
  }
}
