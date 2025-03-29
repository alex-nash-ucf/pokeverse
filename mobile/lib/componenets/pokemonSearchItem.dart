import 'package:flutter/material.dart';
import 'package:mobile/classes/ColorConverter.dart';

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
    // Determine if the background is light or dark
    final bool isDarkBackground = widget.color.computeLuminance() < 0.5;

    final Color backgroundColor =
        isDarkBackground
            ? widget.color
            : ColorClass.darkenColor(widget.color, 0.11); 

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
                  angle: 0.3,
                  child: Transform.translate(
                    offset: Offset(32, 20.5),
                    child: Transform.scale(
                      scale: 2.0,
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
                        color:
                            isDarkBackground
                                ? Colors.white
                                : const Color.fromARGB(255, 5, 19, 53),
                        fontSize: 16,
                        letterSpacing: -1,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            color: !isDarkBackground ? const Color.fromARGB(119, 255, 255, 255)
                                : const Color.fromARGB(144, 5, 19, 53), 
                            offset: Offset(2, 2), 
                            blurRadius: 4, 
                            
                          ),]
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "#${widget.index}",
                      style: TextStyle(
                        fontFamily: 'Pokemon GB',
                        color:
                            isDarkBackground
                                ? const Color.fromARGB(150, 255, 255, 255)
                                : const Color.fromARGB(100, 0, 0, 0),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        
                      ),
                      textAlign: TextAlign.left,
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
