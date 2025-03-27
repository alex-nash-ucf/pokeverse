import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/componenets/pokeballLoading.dart';
import 'package:mobile/componenets/teamSearchItem.dart';

class TeamSearch extends StatefulWidget {
  const TeamSearch({super.key});

  @override
  _TeamSearchState createState() => _TeamSearchState();
}

class _TeamSearchState extends State<TeamSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _teamResults = [];
  bool _isLoading = false;
  bool _isFetchingMore = false; // Flag to track fetching more data
  bool _noMoreResults = false; // Flag to indicate no more results
  int _offset = 0; // To handle pagination offset
  Timer? _debounce; // Timer for debounce
  String _isRequestInProgress = ''; // To track if a request is in progress

  // Create an instance of ApiService
  final ApiService _apiService = ApiService();

  // Fetch Pokemon search results from the API with pagination
  Future<void> _searchPokemon(String query, {int offset = 0}) async {
    // Reset pagination and results if a new search is performed
    if (_isRequestInProgress != query) {
      _offset = 0; // Reset offset for new search
      _noMoreResults = false; // Reset noMoreResults flag for new search
    }

    // Cancel the previous request if there is an ongoing one
    if (_isRequestInProgress != '') {
      _isRequestInProgress = ''; // Mark previous request as canceled
    }

    setState(() {
      if (offset == 0) {
        _isLoading = true; // Show loading indicator for initial fetch
      } else {
        _isFetchingMore = true; // Show loading indicator for more results
      }
      _isRequestInProgress = query; // Mark new request as in progress
    });

    try {
      final result = await _apiService.fetchTeams(query, offset: offset);

      if (_isRequestInProgress == query) {
        // Proceed only if the request was not canceled
        setState(() {
          if (offset == 0) {
            _teamResults = result; // Initial results
          } else {
            _teamResults.addAll(result); // Append new results for lazy loading
          }
          _offset = offset + result.length; // Update the offset

          // Check if there are no more results to fetch
          if (result.length < 8) {
            _noMoreResults = true; // No more results to load
          }
        });
      }
    } catch (error) {
      setState(() {
        _teamResults = [];
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
        if (query.isNotEmpty || _teamResults.isNotEmpty) {
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
          SizedBox(height: 32),

          // ADD MORE TEAMS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Action for button press
              },
              style: ElevatedButton.styleFrom(
                elevation: 6,
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                minimumSize: Size(double.infinity, 64 + 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child:
                _isLoading
                    ? SizedBox(height: 16)
                    : Column(
                      spacing: 16,
                      children: List.generate(_teamResults.length, (index) {
                        final team = _teamResults[index];

                        return FutureBuilder(
                          future: ApiService().getPokemonByTeamId(team["_id"]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: (96 / 2) ,
                                ), 
                                child: PokeballLoader(),
                              );
                            }

                            if (snapshot.hasData) {
                              final pokemon = snapshot.data;

                              team["pokemon"] = pokemon;
                              return TeamSearchItem(
                                team: team,
                              );
                            }

                            return SizedBox();
                          },
                        );
                      }),
                    ),
          ),

          // BOTTOM LOADER: Positioned outside the Column
          if ((!_noMoreResults && _teamResults.isNotEmpty) || _isLoading)
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 24),
              child: Container(
                width: double.infinity,
                child: Center(child: PokeballLoader()),
              ),
            ),
        ],
      ),
    );
  }
}
