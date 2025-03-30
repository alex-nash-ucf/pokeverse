import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/classes/globals.dart';
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
  late List<dynamic> moves;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    nickname = widget.pokemon?["nickname"] ?? "ERROR";
    species = widget.pokemon?["name"] ?? "WSPECIES";
    number = widget.pokemon?["index"] ?? 470;
    moves = widget.pokemon?["moves"] ?? [];
    _nicknameController = TextEditingController(text: nickname);
  }

  // Function to show the edit nickname dialog
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
          height: 256 + 256 - 64 - 64,
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
                      padding: EdgeInsets.symmetric(horizontal: 32 + 32),
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
                  offset: Offset(0, 64 + 32 - 16),
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
                  offset: Offset(0, 64 + 24 + 32),
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
              onPressed: () {
                print("Move pressed: ${widget.pokemon?["moves"][index]}");
              },
            ),
          );
        }),


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
