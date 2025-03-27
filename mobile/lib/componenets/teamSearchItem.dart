import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/ApiService.dart';

class TeamSearchItem extends StatefulWidget {
  final Color color;
  final String name;
  final List<dynamic>? pokemon;

  const TeamSearchItem({
    super.key,
    this.color = Colors.blue,
    this.name = "Team NAME",
    this.pokemon = const [],
  });

  @override
  _TeamSearchItemState createState() => _TeamSearchItemState();
}

class _TeamSearchItemState extends State<TeamSearchItem> {
  // Function to darken a color
  Color darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final double factor = 1 - amount;
    return Color.fromRGBO(
      (color.red * factor).toInt(),
      (color.green * factor).toInt(),
      (color.blue * factor).toInt(),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the background is light or dark
    final bool isDarkBackground = widget.color.computeLuminance() < 0.5;

    // If the background is light, darken the color
    final Color backgroundColor =
        isDarkBackground ? widget.color : darkenColor(widget.color, 0.11);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 128 + 32,
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
        borderRadius: BorderRadius.circular(
          12,
        ), // Ensure child is clipped with rounded corners
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            backgroundColor:
                backgroundColor, // Use the adjusted background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Transform.rotate(
                  angle: 0.25,
                  child: Transform.translate(
                    offset: Offset(-32, 25),
                    child: Transform.scale(
                      scale: 4.5,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isDarkBackground
                              ? const Color.fromARGB(57, 255, 255, 255)
                              : widget.color,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset('assets/images/pokeball.png'),
                      ),
                    ),
                  ),
                ),
              ),

              // Generate Pokémon images in a row
              Align(
                alignment: Alignment.bottomRight,
                child: Stack(
                  children: List.generate(widget.pokemon!.length, (index) {
                    
                    int pokemon_index = widget.pokemon?[index]["index"];

                    return Transform.translate(
                      offset: Offset((index * -50) + 24, 20),
                      child: Transform.scale(
                        scale: 1.5,
                        child: Image(
                          filterQuality: FilterQuality.none,
                          image: NetworkImage(
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemon_index.png",
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Pokemon Name with dynamic text color
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name.isNotEmpty
                          ? widget.name[0].toUpperCase() +
                              widget.name.substring(1)
                          : widget.name,
                      style: TextStyle(
                        fontFamily: 'Pokemon GB',
                        wordSpacing: 0,
                        letterSpacing: 0,
                        color:
                            isDarkBackground
                                ? Colors.white
                                : const Color.fromARGB(255, 5, 19, 53),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color:
                                !isDarkBackground
                                    ? const Color.fromARGB(119, 255, 255, 255)
                                    : const Color.fromARGB(144, 5, 19, 53),
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),

                    Divider(
                      color: isDarkBackground
                          ? Colors.white.withOpacity(0.5)
                          : Colors.black.withOpacity(0.5),
                      thickness: 3, 
                      indent: 0, 
                      endIndent: 0, 
                      height: 5, 
                    ),

                  ],
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
