import 'package:flutter/material.dart';
import 'package:mobile/themes/theme.dart';

class PokemonSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //PADDING
          SizedBox(height: 100),

          //SEARCH BAR
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
                  spreadRadius: -4,
                  blurRadius: 16,
                  offset: Offset(8, 8),
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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              spacing: 8,
              children: [
                Container(decoration: BoxDecoration(color: Colors.green),height: 64,),
                Container(decoration: BoxDecoration(color: Colors.red),height: 64,),
                Container(decoration: BoxDecoration(color: Colors.yellow),height: 64,),
                Container(decoration: BoxDecoration(color: Colors.blue),height: 64,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
