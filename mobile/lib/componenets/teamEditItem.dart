import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/classes/globals.dart';
import 'package:mobile/componenets/pokeballLoading.dart';
import 'package:mobile/pages/editPokemon.dart';

class TeamEditItem extends StatefulWidget {
  final Map<String, dynamic>? pokemon;
  final Map<String, dynamic>? team;
  const TeamEditItem({super.key, this.pokemon, this.team});

  @override
  _TeamEditItemState createState() => _TeamEditItemState();
}

class _TeamEditItemState extends State<TeamEditItem> {
  @override
  Widget build(BuildContext context) {
    Future<Color> color = ApiService().fetchPokemonColor(
      widget.pokemon?["name"],
    );

    return FutureBuilder<Color>(
      future: color,
      builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
        // If the data is still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 13 ,horizontal: 8),
              padding: EdgeInsets.fromLTRB(0, 64, 0, 64), // Apply padding here
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 2, // Border width
                ),
                borderRadius: BorderRadius.circular(
                  8,
                ), // Optional: rounded corners
              ),
              child: Center(child: PokeballLoader()),
            ),
          );
        }

        // If there is an error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // If the data is fetched successfully
        if (snapshot.hasData) {
          Color color = snapshot.data ?? Color.fromRGBO(255, 255, 255, 1);
          String name =
              widget.pokemon?["nickname"] ??
              widget.pokemon?["name"] ??
              "ERROR"; // widget.pokemon?["nickname"] ?? "ERROR";
          int index = widget.pokemon?["index"] ?? 0;
          List<dynamic> moves = widget.pokemon?["moves"] ?? [];

          final bool isDarkBackground = color.computeLuminance() < 0.5;
          final Color backgroundColor =
              isDarkBackground ? color : ColorClass.darkenColor(color, 0.11);

          return Container(
            height: 128 + 64 + 16,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: backgroundColor,
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
                                      : color,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                  'assets/images/pokeball.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: Transform.translate(
                          offset: Offset(0, -20),
                          child: Transform.scale(
                            scale: 2.75,
                            child: Image(
                              filterQuality: FilterQuality.none,
                              image: NetworkImage(
                                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index}.png",
                              ),
                            ),
                          ),
                        ),
                      ),

                      // NAME
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
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
                                          ? const Color.fromARGB(
                                            119,
                                            255,
                                            255,
                                            255,
                                          )
                                          : const Color.fromARGB(
                                            144,
                                            5,
                                            19,
                                            53,
                                          ),
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                                Shadow(
                                  color: ColorClass.darkenColor(color, 0.5),
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

                          Divider(
                            thickness: 3,
                            color:
                                isDarkBackground
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 5, 19, 53),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "Moves:",
                            style: TextStyle(
                              fontFamily: 'Pokemon GB',
                              wordSpacing: -2,
                              letterSpacing: -2,
                              color:
                                  isDarkBackground
                                      ? const Color.fromARGB(255, 255, 255, 255)
                                      : const Color.fromARGB(255, 5, 19, 53),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              shadows: [
                                Shadow(
                                  color:
                                      !isDarkBackground
                                          ? const Color.fromARGB(
                                            119,
                                            255,
                                            255,
                                            255,
                                          )
                                          : const Color.fromARGB(
                                            144,
                                            5,
                                            19,
                                            53,
                                          ),
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

                          SizedBox(height: 8),

                          ...List.generate(moves.length, (num) {
                            return Text(
                              " -" + moves[num],
                              style: TextStyle(
                                fontFamily: 'Pokemon GB',
                                wordSpacing: -2,
                                letterSpacing: -2,
                                color:
                                    isDarkBackground
                                        ? const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        )
                                        : const Color.fromARGB(255, 5, 19, 53),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                shadows: [
                                  Shadow(
                                    color:
                                        !isDarkBackground
                                            ? const Color.fromARGB(
                                              119,
                                              255,
                                              255,
                                              255,
                                            )
                                            : const Color.fromARGB(
                                              144,
                                              5,
                                              19,
                                              53,
                                            ),
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          }),

                          // // ability
                          // SizedBox(height: 8,),

                          // Text(
                          //   "Ability:",
                          //   style: TextStyle(
                          //     fontFamily: 'Pokemon GB',
                          //     wordSpacing: -2,
                          //     letterSpacing: -2,
                          //     color:
                          //         isDarkBackground
                          //             ? const Color.fromARGB(255, 255, 255, 255)
                          //             : const Color.fromARGB(255, 5, 19, 53),
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //     fontStyle: FontStyle.italic,
                          //     shadows: [
                          //       Shadow(
                          //         color:
                          //             !isDarkBackground
                          //                 ? const Color.fromARGB(
                          //                   119,
                          //                   255,
                          //                   255,
                          //                   255,
                          //                 )
                          //                 : const Color.fromARGB(
                          //                   144,
                          //                   5,
                          //                   19,
                          //                   53,
                          //                 ),
                          //         offset: Offset(2, 2),
                          //         blurRadius: 4,
                          //       ),
                          //     ],
                          //   ),
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 1,
                          // ),

                          // SizedBox(height: 8,),

                          // Text(
                          //     " -" ,
                          //     style: TextStyle(
                          //       fontFamily: 'Pokemon GB',
                          //       wordSpacing: -2,
                          //       letterSpacing: -2,
                          //       color:
                          //           isDarkBackground
                          //               ? const Color.fromARGB(
                          //                 255,
                          //                 255,
                          //                 255,
                          //                 255,
                          //               )
                          //               : const Color.fromARGB(255, 5, 19, 53),
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.bold,
                          //       fontStyle: FontStyle.italic,
                          //       shadows: [
                          //         Shadow(
                          //           color:
                          //               !isDarkBackground
                          //                   ? const Color.fromARGB(
                          //                     119,
                          //                     255,
                          //                     255,
                          //                     255,
                          //                   )
                          //                   : const Color.fromARGB(
                          //                     144,
                          //                     5,
                          //                     19,
                          //                     53,
                          //                   ),
                          //           offset: Offset(2, 2),
                          //           blurRadius: 4,
                          //         ),
                          //       ],
                          //     ),
                          //     overflow: TextOverflow.ellipsis,
                          //     maxLines: 1,
                          //   )
                        ],
                      ),
                    ],
                  ),
                  onPressed: () {
                    ScreenManager().setScreen(
                      EditPokemon(
                        pokemon: widget.pokemon,
                        color: color,
                        team: widget.team,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }

        return Center(child: Text('No Data Available'));
      },
    );
  }
}
