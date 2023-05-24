import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remaze/splash_screen.dart';
import 'package:remaze/views/general_menu.dart';

class GameSplashScreen extends StatelessWidget {
  const GameSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1000,
      splash: Image.asset("assets/images/maze_preview.jpg"),
      nextScreen: GeneralMenu(),
      splashTransition: SplashTransition.scaleTransition,
      splashIconSize: 250,
      backgroundColor: Colors.black,
    );
  }
}