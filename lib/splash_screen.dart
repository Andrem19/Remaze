import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remaze/controllers/routing/app_pages.dart';
import '../AppOpenAdManager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appOpenAdManager.loadAd();

    Future.delayed(const Duration(milliseconds: 3000)).then((value) {
      appOpenAdManager.showAdIfAvailable();
      Get.toNamed(Routes.GAME_SPLASH_SCREEN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
