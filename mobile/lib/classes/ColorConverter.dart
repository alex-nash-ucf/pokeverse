import 'package:flutter/material.dart';

class ColorClass {
  static Color fromCssColorName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'brown':
        return Colors.brown;
      case 'cyan':
        return Colors.cyan;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'gray':
        return Colors.grey;
      case 'lime':
        return Colors.lime;
      case 'indigo':
        return Colors.indigo;
      case 'teal':
        return Colors.teal;
      case 'amber':
        return Colors.amber;
      case 'bluegrey':
        return Colors.blueGrey;
      case 'lightblue':
        return Colors.lightBlue;
      case 'lightgreen':
        return Colors.green[100]!;
      case 'lightyellow':
        return Colors.yellow[100]!;
      default:
        return Colors.transparent;
    }
  }

  static Color generateColorFromString(String seed) {
    Color special = fromCssColorName(seed);
    if (seed == "New Team") return Colors.grey;
    if (special != Colors.transparent) return special;

    int hash = seed.hashCode;

    // Use the hash to generate RGB values
    int r = (hash >> 16) & 0xFF;
    int g = (hash >> 8) & 0xFF;
    int b = hash & 0xFF;

    // beutification
    while ((r - g).abs() < 50 && (g - b).abs() < 50 && (r - b).abs() < 50) {
      hash = hash * 31 + 1;
      r = (hash >> 16) & 0xFF;
      g = (hash >> 8) & 0xFF;
      b = hash & 0xFF;

      // make bright
      r = (r >= 64 && r <= 225) ? r : (r < 64 ? 64 : 225);
      g = (g >= 64 && g <= 225) ? g : (g < 64 ? 64 : 225);
      b = (b >= 64 && b <= 225) ? b : (b < 64 ? 64 : 225);
    }

    return Color.fromRGBO(r, g, b, 1.0);
  }

  static Color darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final double factor = 1 - amount;
    return Color.fromRGBO(
      (color.red * factor).toInt(),
      (color.green * factor).toInt(),
      (color.blue * factor).toInt(),
      1,
    );
  }



static Color lightenColor(Color color, double amount) {
  assert(amount >= 0 && amount <= 1);
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;
  
  // The lightening factor to apply to each component
  final double factor = 1 + amount;

  // Lighten the color by adding the lightening factor to each component
  int newRed = (red + ((255 - red) * amount)).clamp(0, 255).toInt();
  int newGreen = (green + ((255 - green) * amount)).clamp(0, 255).toInt();
  int newBlue = (blue + ((255 - blue) * amount)).clamp(0, 255).toInt();

  return Color.fromRGBO(newRed, newGreen, newBlue, 1);
}


}
