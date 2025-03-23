import 'package:flutter/material.dart';
import 'package:mobile/componenets/carouselItem.dart';
import 'package:mobile/themes/theme.dart'; 

class PokemonSearch extends CarouselItem {

  const PokemonSearch({
    Key? key,
    BoxDecoration decoration = const BoxDecoration(
      color: Color.fromARGB(0, 0, 255, 72),
    ),
  }) : super(
          decoration: decoration,
        );

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
