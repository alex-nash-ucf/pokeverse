import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/classes/globals.dart';
import 'package:mobile/pages/editTeam.dart';

class TeamSearchItem extends StatefulWidget {
  final Map<String, dynamic>? team;

  const TeamSearchItem({super.key, 
  this.team});

  @override
  _TeamSearchItemState createState() => _TeamSearchItemState();
}

class _TeamSearchItemState extends State<TeamSearchItem> {


  @override
  Widget build(BuildContext context) {

    Color color = widget.team?["color"];
    
    // Determine if the background is light or dark
    final bool isDarkBackground = color.computeLuminance() < 0.5;

    // If the background is light, darken the color
    final Color backgroundColor =
        isDarkBackground ? color : ColorClass.darkenColor(color, 0.11);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 128 + 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
            offset: Offset(0, 4), 
            blurRadius: 6, 
            spreadRadius: 1, 
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          12,
        ), 
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            backgroundColor:
                backgroundColor, 
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
                      scale: 3.5,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isDarkBackground
                              ? const Color.fromARGB(57, 255, 255, 255)
                              : color,
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
                  children: List.generate(widget.team?["pokemon"].length, (
                    index,
                  ) {
                    int pokemon_index = widget.team?["pokemon"][index]["index"];

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
                    // Safely accessing 'name' with null check and fallback
                    Text(
                      widget.team?["name"], // Fallback text if name is null or empty
                      style: TextStyle(
                        fontFamily: 'Pokemon GB',
                        wordSpacing: -2,
                        letterSpacing: -2,
                        color:
                            isDarkBackground
                                ? Colors.white
                                : const Color.fromARGB(255, 5, 19, 53),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        
                        shadows: [
                          Shadow(
                            color:
                                !isDarkBackground
                                    ? const Color.fromARGB(230, 255, 255, 255)
                                    : const Color.fromARGB(144, 5, 19, 53),
                            offset: Offset(0, 6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,  
                      maxLines: 1, 
                    ),

                    Divider(
                      color:
                          isDarkBackground
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
            ScreenManager().setScreen(EditTeam(team: widget.team,));
          },
        ),
      ),
    );
  }
}
