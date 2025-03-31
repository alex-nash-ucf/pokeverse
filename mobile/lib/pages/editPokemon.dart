import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/classes/globals.dart';
import 'package:mobile/componenets/pokeballLoading.dart';
import 'package:mobile/pages/editTeam.dart';
import 'package:mobile/pages/teamSearch.dart';

class EditPokemon extends StatefulWidget {
  final Color color;
  final Map<String, dynamic>? pokemon;
  final Map<String, dynamic>? team;

  const EditPokemon({super.key, this.pokemon, required this.color, this.team});

  @override
  _EditPokemonState createState() => _EditPokemonState();
}

class _EditPokemonState extends State<EditPokemon> {
  late String nickname;
  late String species;
  late int number;
  late Color backround_color;
  late Color text_color;
  late List<String> moves;
  late TextEditingController _nicknameController;
  late List<String> species_moves; // List to hold species moves

  @override
  void initState() {
    super.initState();
    nickname = widget.pokemon?["nickname"] ?? widget.pokemon?["name"] ?? "ERROR";
    species = widget.pokemon?["name"] ?? "WSPECIES";
    number = widget.pokemon?["index"] ?? 470;
    moves = List<String>.from(widget.pokemon?["moves"] ?? []);
    _nicknameController = TextEditingController(text: nickname);

    backround_color = widget.color;
    text_color =
        backround_color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    species_moves = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSpeciesMoves();
    });
  }

  void _showNicknameEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: widget.color,
          content: TextField(
            controller: _nicknameController,
            style: TextStyle(
              color:
                  widget.color.computeLuminance() < 0.5
                      ? Colors.white
                      : const Color.fromARGB(255, 5, 19, 53),
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: "Enter Nickname...",
              hintStyle: TextStyle(
                color:
                    widget.color.computeLuminance() < 0.5
                        ? Colors.white
                        : const Color.fromARGB(255, 5, 19, 53),
                fontSize: 20,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      widget.color.computeLuminance() < 0.5
                          ? Colors.white
                          : const Color.fromARGB(255, 5, 19, 53),
                  width: 2.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      widget.color.computeLuminance() < 0.5
                          ? Colors.white
                          : const Color.fromARGB(255, 5, 19, 53),
                  width: 2.0,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color:
                      widget.color.computeLuminance() < 0.5
                          ? Colors.white
                          : const Color.fromARGB(255, 5, 19, 53),
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Enter",
                style: TextStyle(
                  color:
                      widget.color.computeLuminance() < 0.5
                          ? Colors.white
                          : const Color.fromARGB(255, 5, 19, 53),
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                String newNickname = _nicknameController.text;
                if (newNickname.isNotEmpty) {
                  setState(() {
                    nickname = newNickname;
                    widget.pokemon?["nickname"] = newNickname;
                    ApiService().updatePokemonDetails(
                      widget.team?["_id"],
                      widget.pokemon?["_id"],
                      newNickname,
                      widget.pokemon?["ability"],
                      List<String>.from(widget.pokemon?["moves"]),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchSpeciesMoves() async {
    try {
      List<Map<String, dynamic>> result = await ApiService().getPokemonMoves(
        species,
      );

      setState(() {
        species_moves =
            result.map((moveData) {
              // Capitalize the first letter of each word in the move name
              String moveName = moveData['name'].toString();
              return moveName
                  .split(RegExp(r'[ _-]'))
                  .map((word) {
                    return word[0].toUpperCase() +
                        word.substring(1).toLowerCase();
                  })
                  .join(' ');
            }).toList();
      });
    } catch (error) {
      print('Failed to fetch moves: $error');
    }
  }

  void _editMoveDialog(int index) async {
    if (species_moves.isEmpty) {
      await _fetchSpeciesMoves();
    }

    if (species_moves.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: widget.color,
            content: SingleChildScrollView(
              child: Column(
                children:
                    species_moves.map((move) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            moves[index] = move;
                            widget.pokemon?["moves"] = moves;

                            ApiService().updatePokemonDetails(
                              widget.team?["_id"],
                              widget.pokemon?["_id"],
                              nickname,
                              widget.pokemon?["ability"],
                              moves,
                            );
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            move,
                            style: TextStyle(color: text_color, fontSize: 18),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: text_color, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: PokeballLoader()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Color background_color = widget.color;
    Color text_color =
        widget.color.computeLuminance() < 0.5
            ? Colors.white
            : const Color.fromARGB(255, 5, 19, 53);

    return Column(
      children: [
        Container(
          height: 256 + 256 - 128 - 64,
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
                          ColorClass.lightenColor(background_color, 0.4),
                          background_color,
                          ColorClass.darkenColor(background_color, 0.4),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32 + 32 + 16),
                      child: Transform.translate(
                        offset: Offset(0, 64 + 16),
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
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: Offset(0, 64 + 16 - 16 + 8),
                  child: Text(
                    species,
                    style: TextStyle(
                      fontFamily: 'Pokemon GB',
                      wordSpacing: -2,
                      letterSpacing: -2,
                      color: text_color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          color: const Color.fromARGB(148, 0, 0, 0),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                        Shadow(
                          color: ColorClass.darkenColor(background_color, 0.5),
                          offset: Offset(0, 7.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: Offset(0, 64 + 24 + 8 + 8),
                  child: Text(
                    "# " + number.toString(),
                    style: TextStyle(
                      fontFamily: 'Pokemon GB',
                      wordSpacing: -2,
                      letterSpacing: -2,
                      color: text_color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          color: const Color.fromARGB(148, 0, 0, 0),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                        Shadow(
                          color: ColorClass.darkenColor(background_color, 0.5),
                          offset: Offset(0, 7.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),

        // PAST ROUNDNESS
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_rounded, size: 32),
              onPressed: () {
                ScreenManager().setScreen(EditTeam(team: widget.team));
              },
              color: Colors.black,
            ),
            SizedBox(width: 8),

            // NAME
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(4, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  nickname,
                  style: TextStyle(
                    fontFamily: 'Pokemon GB',
                    wordSpacing: -2,
                    letterSpacing: -2,
                    color: text_color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(width: 8),

            // EDIT BUTTON
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black,
              onPressed: _showNicknameEditDialog, // Show the edit dialog
            ),
          ],
        ),
        SizedBox(height: 8),
        Divider(endIndent: 16, indent: 16, thickness: 3, color: Colors.grey),

        ///////////////////////// ABILITY
        // Text(
        //   "Ability:",
        //   style: TextStyle(
        //     fontFamily: 'Pokemon GB',
        //     wordSpacing: -2,
        //     letterSpacing: -2,
        //     color: Colors.black,
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //     fontStyle: FontStyle.italic,
        //   ),
        //   overflow: TextOverflow.ellipsis,
        //   maxLines: 1,
        //   textAlign: TextAlign.center,
        // ),

        // Expanded(
        //   child: EditButton(buttonText: widget.pokemon?["ability"], onPressed: () {  },)
        // ),

        // Divider(endIndent: 16, indent: 16, thickness: 3, color: Colors.grey),

        ///////////////////////// MOVES
        SizedBox(height: 8),
        Text(
          "Moves:",
          style: TextStyle(
            fontFamily: 'Pokemon GB',
            wordSpacing: -2,
            letterSpacing: -2,
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),

        ...List.generate(widget.pokemon?["moves"].length, (index) {
          return Expanded(
            child: EditButton(
              buttonText: widget.pokemon?["moves"][index],
              onPressed: () => _editMoveDialog(index),
            ),
          );
        }),

        Divider(endIndent: 16, indent: 16, thickness: 3, color: Colors.grey),

        // DELETE POKEMon
        GestureDetector(
          onTap: () {
            final pokemonId = widget.pokemon?["_id"];
            setState(() {
              widget.team?['pokemon'].removeWhere(
                (pokemon) => pokemon["_id"] == pokemonId,
              );
            });

            ApiService().deletePokemon( widget.team?["_id"], widget.pokemon?["_id"]);
            ScreenManager().setScreen(EditTeam(team: widget.team));

          },

          child: Container(
            height: 64 - 16,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 255, 71, 71),
            ),
            child: Center(
              child: Text(
                "Delete Pokemon", // Text inside the button
                style: TextStyle(
                  fontFamily: 'Pokemon GB',
                  fontSize: 18,
                  color: const Color.fromARGB(255, 255, 255, 255), // Text color
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 64),
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

//////////////////////////////////////////////////

class EditButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressed; // Callback when the button is pressed

  const EditButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: Center(
          child: Text(
            buttonText, // Text inside the button
            style: TextStyle(
              fontFamily: 'Pokemon GB',
              fontSize: 18,
              color: Colors.black, // Text color
            ),
          ),
        ),
      ),
    );
  }
}
