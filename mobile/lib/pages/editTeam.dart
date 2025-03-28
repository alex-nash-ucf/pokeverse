import 'package:flutter/material.dart';
import 'package:mobile/classes/ColorConverter.dart';
import 'package:mobile/componenets/teamEditItem.dart';

class EditTeam extends StatelessWidget {
  final Map<String, dynamic>? team;

  const EditTeam({super.key, this.team});

  @override
  Widget build(BuildContext context) {
    String name = team?["name"] ?? "New Team";
    Color color = team?["color"] ?? const Color.fromARGB(255, 79, 79, 79);
    final bool isColorDark = color.computeLuminance() < 0.5;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,  // Starting point of the gradient
          end: Alignment.bottomRight,  // Ending point of the gradient
          colors: [
            ColorClass.lightenColor(color, 0.6),  // Lighter version of the main color
            color, 
            color,  // Original color
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(  // Wrap everything in a scroll view
          child: Column(
            children: [
              SizedBox(height: 72),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_rounded, size: 32),
                    onPressed: () {
                      // Handle back action here
                      print("Back button pressed");
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
                          color: isColorDark
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
                    onPressed: () {
                      // Handle edit action here
                      print("Edit button pressed");
                    },
                    color: Colors.black,
                  ),
                ],
              ),

              SizedBox(height: 20),
              Divider(
                thickness: 3,
                color: isColorDark
                    ? const Color.fromARGB(78, 255, 255, 255)
                    : const Color.fromARGB(41, 5, 19, 53),
                indent: 32,
                endIndent: 32,
              ),
              SizedBox(height: 20),

              //TEAM
              Column(
                children: List.generate(6, (index) {
                  return TeamEditItem();
                }),
              ),

              SizedBox(height: 20),
              Divider(
                thickness: 3,
                color: isColorDark
                    ? const Color.fromARGB(78, 255, 255, 255)
                    : const Color.fromARGB(41, 5, 19, 53),
                indent: 32,
                endIndent: 32,
              ),
              SizedBox(height: 20),

              // DELETE TEAM
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Action for button press
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

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
