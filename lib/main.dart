import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/views/game_splash_screen.dart';
import 'package:remaze/views/general_menu.dart';

import 'controllers/bindings/bindings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
          primaryColorDark: Color.fromARGB(255, 29, 70, 27),
          primaryColor: Color.fromARGB(255, 28, 144, 86),
          // fontFamily: 'SignikaNegative',
          splashColor: Color.fromARGB(255, 117, 243, 45),
          visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameSplashScreen(),
      initialBinding: MainScreenBinding(),
    );
  }
}
