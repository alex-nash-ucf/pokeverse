import 'package:flutter/material.dart';
import 'package:mobile/componenets/pokemonSearchItem.dart';

class PokemonSearch extends StatelessWidget {
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
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              cursorColor: Theme.of(context).colorScheme.secondary,
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

          // GridView for displaying Pokémon items
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2, 
              crossAxisSpacing: 8, 
              mainAxisSpacing: 8, 
              shrinkWrap: true,  
              physics: NeverScrollableScrollPhysics(),  
              children:[
                PokemonSearchItem(color: Colors.greenAccent, index: 470,), 
                PokemonSearchItem(color: const Color.fromARGB(255, 240, 105, 105), index: 380,), 
                PokemonSearchItem(color: const Color.fromARGB(255, 240, 193, 105), index: 6,), 
                PokemonSearchItem(color: const Color.fromARGB(255, 229, 105, 240), index: 150,), 
              ]
            ),
          ),
        ],
      ),
    );
  }
}
