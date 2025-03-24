import 'package:flutter/material.dart';

class CssColorConverter {
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
}
