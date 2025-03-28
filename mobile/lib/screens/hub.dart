import 'package:flutter/material.dart';
import 'package:mobile/componenets/carouselItem.dart';
import 'package:mobile/pages/editTeam.dart';
import 'package:mobile/pages/pokemonSearch.dart';
import 'package:mobile/pages/teamSearch.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  _HubScreenState createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
    final PageController _pageController = PageController(initialPage: 2);

  // CONTROLS SCROLL ANIMATION
  void slideToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BODY
      body: Column(
        children: [
          // CAROUSEL
          Expanded(
            child: PageView(
              controller: _pageController,
              physics:
                  ScrollPhysics(), // Disable manual scrolling
              children: [
                PokemonSearch(),
                TeamSearch(),
                EditTeam()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
