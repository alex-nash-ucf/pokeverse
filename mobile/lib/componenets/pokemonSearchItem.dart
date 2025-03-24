import 'dart:io';
import 'package:flutter/material.dart';

class PokemonSearchItem extends StatefulWidget {
  final Color color;
  final String name;
  final int index;

  const PokemonSearchItem({
    super.key,
    this.color = Colors.blue,
    this.name = "PokemonName",
    this.index = 0,
  });

  @override
  _PokemonSearchItemState createState() => _PokemonSearchItemState();
}

class _PokemonSearchItemState extends State<PokemonSearchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            offset: Offset(0, 4), // Shadow offset (horizontal, vertical)
            blurRadius: 6, // Spread the shadow
            spreadRadius: 1, // Spread the shadow a little more
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // Ensure child is clipped with rounded corners
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            backgroundColor: widget.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                  offset: Offset(32, 59.5),
                  child: Transform.scale(
                    scale: 2.5,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        const Color.fromARGB(75, 255, 255, 255),
                        BlendMode.srcIn, 
                      ),
                      child: Image.asset('assets/images/pokeball.png'),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                  offset: Offset(32, 0),
                  child: Transform.scale(
                    scale: 2.25,
                    child: Image(
                      filterQuality: FilterQuality.none,
                      image: NetworkImage(
                        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.index}.png",
                      ),
                    ),
                  ),
                ),
              ),

              // Pokemon Name
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              // Pokemon Index Number
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "#" + widget.index.toString(),
                  style: TextStyle(
                    color: const Color.fromARGB(200, 255, 255, 255),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          onPressed: () {
            print("Button Pressed");
          },
        ),
      ),
    );
  }
}
