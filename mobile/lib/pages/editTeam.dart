import 'package:flutter/material.dart';
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/classes/globals.dart';
import 'package:mobile/componenets/teamEditItem.dart';
import 'package:mobile/pages/pokemonSearch.dart';
import 'package:mobile/pages/teamSearch.dart';

class EditTeam extends StatefulWidget {
  final Map<String, dynamic>? team;
  const EditTeam({super.key, this.team});

  @override
  _EditTeamState createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  late String name;
  late Color color;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Initialize state variables from the passed team data
    name = widget.team?["name"] ?? "NOT READY";
    color = widget.team?["color"] ?? ColorClass.generateColorFromString(name);
    _textController = TextEditingController(
      text: name,
    ); // Initialize the TextEditingController
  }

  void updateTeamNameAndColor(String newName, Color newColor) {
    setState(() {
      name = newName;
      color = newColor;
    });
  }

  // Function to show the edit dialog
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: color,
          content: TextField(
            controller: _textController,
            style: TextStyle(
              color:
                  color.computeLuminance() < 0.5
                      ? Colors.white
                      : const Color.fromARGB(255, 5, 19, 53),
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: "Enter Name...",
              hintStyle: TextStyle(
                color:
                    color.computeLuminance() < 0.5
                        ? Colors.white
                        : const Color.fromARGB(255, 5, 19, 53),
                fontSize: 20,
              ),
              // Change the color of the underline here
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      color.computeLuminance() < 0.5
                          ? Colors.white
                          : const Color.fromARGB(255, 5, 19, 53),
                  width: 2.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      color.computeLuminance() < 0.5
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
                      color.computeLuminance() < 0.5
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
                      color.computeLuminance() < 0.5
                          ? Colors.white
                          : const Color.fromARGB(255, 5, 19, 53),
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                String newName = _textController.text;
                if (newName.isNotEmpty) {
                  ApiService().editTeamName(widget.team?["_id"], newName);
                  updateTeamNameAndColor(
                    newName,
                    ColorClass.generateColorFromString(newName),
                  );
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
    final bool isColorDark = color.computeLuminance() < 0.5;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, // Starting point of the gradient
          end: Alignment.bottomRight, // Ending point of the gradient
          colors: [
            ColorClass.lightenColor(color, 0.5),
            color,
            ColorClass.darkenColor(color, 0.5),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          // Wrap everything in a scroll view
          child: Column(
            children: [
              SizedBox(height: 96),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_rounded, size: 32),
                    onPressed: () {
                      // Handle back action here
                      ScreenManager().setScreen(TeamSearch());
                    },
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),

                  // NAME
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      decoration: BoxDecoration(
                        color: color,
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
                        name,
                        style: TextStyle(
                          fontFamily: 'Pokemon GB',
                          wordSpacing: -2,
                          letterSpacing: -2,
                          color:
                              isColorDark
                                  ? Colors.white
                                  : const Color.fromARGB(255, 5, 19, 53),
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
                    onPressed:
                        _showEditDialog, // Show the edit dialog when pressed
                    color: Colors.black,
                  ),
                ],
              ),

              SizedBox(height: 20),
              Divider(
                thickness: 3,
                color:
                    isColorDark
                        ? const Color.fromARGB(78, 255, 255, 255)
                        : const Color.fromARGB(41, 5, 19, 53),
                indent: 32,
                endIndent: 32,
              ),
              SizedBox(height: 20),

              //TEAM
              Column(
                children: [
                  // POKEMON LOAD
                  if (widget.team?["pokemon"] != null)
                    ...List.generate(widget.team?["pokemon"].length ?? 0, (
                      index,
                    ) {
                      return TeamEditItem(
                        pokemon: widget.team?["pokemon"][index],
                        team: widget.team,
                      );
                    }),

                  //ADD MORE POKEMON BUTTON
                  if (widget.team?["pokemon"] != null &&
                      widget.team?["pokemon"].length < 6)
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 16, 12, 4),
                      child: ElevatedButton(
                        onPressed: () {
                          ScreenManager().setScreen(PokemonSearch(team: widget.team));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 6,
                          backgroundColor: const Color.fromARGB(
                            255,
                            63,
                            243,
                            102,
                          ),
                          minimumSize: Size(double.infinity, 64),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontFamily: 'Pokemon GB',
                            wordSpacing: -2,
                            letterSpacing: -2,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 20),
              Divider(
                thickness: 3,
                color:
                    isColorDark
                        ? const Color.fromARGB(78, 255, 255, 255)
                        : const Color.fromARGB(41, 5, 19, 53),
                indent: 32,
                endIndent: 32,
              ),
              SizedBox(height: 20),

              // DELETE TEAM
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    String id = widget.team?["_id"];
                    ApiService().deleteTeam(id);
                    ScreenManager().setScreen(TeamSearch());
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    backgroundColor: Colors.redAccent,
                    minimumSize: Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Delete Team",
                    style: TextStyle(
                      fontFamily: 'Pokemon GB',
                      wordSpacing: -2,
                      letterSpacing: -2,
                      color: const Color.fromARGB(255, 255, 255, 255),
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

              SizedBox(height: 64 + 32),
            ],
          ),
        ),
      ),
    );
  }
}
