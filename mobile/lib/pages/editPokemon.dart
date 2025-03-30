import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/classes/ColorConverter.dart';

class EditPokemon extends StatelessWidget {
  final Color color;
  final Map<String, dynamic>? pokemon;

  const EditPokemon({super.key, this.pokemon, required this.color});

  @override
  Widget build(BuildContext context) {
    Color background_color = color;
    Color text_color =
        color.computeLuminance() < 0.5
            ? Colors.white
            : const Color.fromARGB(255, 5, 19, 53);

    String nickname = pokemon?["nickname"] ?? "ERROR";
    String species = pokemon?["name"] ?? "WSPECIES";
    int number = pokemon?["index"] ?? 470;
    List<dynamic> moves = pokemon?["moves"] ?? [];

    return Column(
      children: [
        Container(
          height: 256 + 256 ,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipPath(
                  clipper: CustomCurveClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorClass.lightenColor(background_color, 0.1),
                          background_color,
                          ColorClass.darkenColor(background_color, 0.2),
                        ],
                      ),
                    ),

                    child: Transform.translate(
                      offset: Offset(0, 64),
                      child: Image(
                        filterQuality: FilterQuality.none,
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${number}.png",
                        ),
                      ),
                    ),
                  ),
                ),
              ),


              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(offset: Offset(0, 64 + 32 - 16),
                      child: Text(
                            species,
                            style: TextStyle(
                              fontFamily: 'Pokemon GB',
                              wordSpacing: -2,
                              letterSpacing: -2,
                              color:
                                  text_color,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              shadows: [
                                Shadow(
                                  color:
                                      const Color.fromARGB(148, 0, 0, 0),
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                                Shadow(
                                  color: ColorClass.darkenColor(color, 0.5),
                                  offset: Offset(0, 7.5),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),),
              ),
            
              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(offset: Offset(0, 64 + 24 +  32 ),
                      child: Text(
                            "# " + number.toString(),
                            style: TextStyle(
                              fontFamily: 'Pokemon GB',
                              wordSpacing: -2,
                              letterSpacing: -2,
                              color:
                                  text_color,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              shadows: [
                                Shadow(
                                  color:
                                      const Color.fromARGB(148, 0, 0, 0),
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                                Shadow(
                                  color: ColorClass.darkenColor(color, 0.5),
                                  offset: Offset(0, 7.5),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),),
              )


            ],
          ),
        ),
      ],
    );
  }
}

class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = size.height * 2;
    Offset center = Offset(size.width / 2, size.height - radius);

    path.addOval(Rect.fromCircle(center: center, radius: radius));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
