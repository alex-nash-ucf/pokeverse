import 'package:flutter/material.dart';
import 'package:mobile/componenets/carouselItem.dart';
import 'package:mobile/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokeverse',
      home: GettingStartedScreen(),
      theme: lightMode,
    );
  }
}

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0; 

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Pokeverse demo",
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          // CAROUSEL
          Expanded(
            child: PageView(
              controller: _pageController,
              children: List.generate(5, (index) => CarouselItem()),
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
                    icon: [
                      Icons.home,
                      Icons.table_rows,
                      Icons.favorite,
                      Icons.people_alt,
                      Icons.exit_to_app
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

class NavBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSelected;

  const NavBarButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isSelected ? const Color.fromARGB(255, 145, 24, 24) : Theme.of(context).scaffoldBackgroundColor,
        
      ),
    );
  }
}
