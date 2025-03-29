import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/ApiService.dart';
import 'package:mobile/classes/ColorConverter.dart';

class TeamEditItem extends StatefulWidget {
  final Map<String, dynamic>? pokemon;

  const TeamEditItem({super.key, this.pokemon});

  @override
  _TeamEditItemState createState() => _TeamEditItemState();
}

class _TeamEditItemState extends State<TeamEditItem> {
  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromARGB(255, 236, 236, 236);
    String name = widget.pokemon?["name"] ?? "Empty";
    int index = widget.pokemon?["index"] ?? 0;

    final bool isDarkBackground = color.computeLuminance() < 0.5;
    final Color backgroundColor =
        isDarkBackground ? color : ColorClass.darkenColor(color, 0.11);

    return Container(
      height: 128,
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
                          child: Image.asset('assets/images/pokeball.png'),
                        ),
                      ),
                    ),
                  ),
                ),

                Align(alignment: Alignment.bottomRight),

                // NAME
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Safely accessing 'name' with null check and fallback
                      Text(
                        // Check if 'name' is null or empty, provide fallback text if necessary
                        name?.isNotEmpty ?? false
                            ? (name?.substring(0, 1).toUpperCase() ?? '') +
                                (name?.substring(1) ?? '')
                            : 'No Name', 
                        
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
                                      ? const Color.fromARGB(119, 255, 255, 255)
                                      : const Color.fromARGB(144, 5, 19, 53),
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
      ),
    );
  }
}
