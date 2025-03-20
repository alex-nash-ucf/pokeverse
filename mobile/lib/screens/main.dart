import 'package:flutter/material.dart';
import 'package:mobile/componenets/carouselItem.dart';
import 'package:mobile/componenets/header.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  // CONTROLS SCROLL ANIMATION
  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BODY
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Theme.of(context).primaryColor,
          ),

          ClipRect(  
            clipBehavior: Clip.none,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 128), 
              painter: Header(color: Theme.of(context).primaryColor),
            ),
          ),

          // CAROUSEL
          Expanded(
            child: PageView(
              controller: _pageController,
              children: List.generate(
                5,
                (index) => CarouselItem(),
              ),
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),

          // NAVBAR
          Container(
            height: 64,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return NavBarButton(
                    icon_unpressed:
                        [
                          Icons.home_outlined,
                          Icons.table_rows_outlined,
                          Icons.favorite_border_outlined,
                          Icons.people_alt_outlined,
                          Icons.settings_outlined,
                        ][index],
                    icon_pressed:
                        [
                          Icons.home,
                          Icons.table_rows,
                          Icons.favorite,
                          Icons.people_alt,
                          Icons.settings,
                        ][index],
                    isSelected: _selectedIndex == index,
                    onPressed: () => _onNavBarTap(index),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////  NAVBAR  //////////////////////////////////

class NavBarButton extends StatelessWidget {
  final IconData icon_pressed;
  final IconData icon_unpressed;
  final VoidCallback onPressed;
  final bool isSelected;

  const NavBarButton({
    Key? key,
    required this.icon_pressed,
    required this.icon_unpressed,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isSelected ? icon_pressed : icon_unpressed,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
