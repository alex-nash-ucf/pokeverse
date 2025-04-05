import 'package:flutter/material.dart';
import 'package:mobile/classes/globals.dart'; // Assuming this contains your globals, like ScreenManager
import 'package:mobile/componenets/header.dart';
import 'package:mobile/pages/teamSearch.dart';

class ScreenContainer extends StatefulWidget {
  const ScreenContainer({super.key});

  @override
  _ScreenContainerState createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Body
          Column(
            children: [
              SizedBox(height: 38),
              Expanded(
                child: StreamBuilder<Widget>(
                  stream: ScreenManager().screenStream,  
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    Widget currentScreen = snapshot.data ?? const SizedBox();
                    return currentScreen;
                  },
                ),
              ),
              SizedBox(height: 32),
            ],
          ),

          // Header
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top,
                color: Theme.of(context).primaryColor,
              ),
              Transform.translate(
                offset: Offset(0, 0),
                child: HeaderWithSvg(
                  primaryColor: Theme.of(context).colorScheme.primary,
                  secondaryColor: Theme.of(context).colorScheme.secondary,
                  topHeight: screenHeight + 16,
                ),
              ),
            ],
          ),

          // Footer
          Transform.translate(
            offset: Offset(0, 0),
            child: IgnorePointer(
              child: FooterWithSvg(
                primaryColor: Theme.of(context).colorScheme.primary,
                secondaryColor: Theme.of(context).colorScheme.secondary,
                bottomHeight: screenHeight + 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
