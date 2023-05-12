import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'controllers/bindings/bindings.dart';
import 'controllers/routing/app_pages.dart';
import 'firebase_options.dart';
import 'keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MobileAds.instance
      .updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['1db7a663-dd6d-49a9-896f-921520fb1c62']));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: Keys.scaffoldMessengerKey,
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
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      initialBinding: MainScreenBinding(),
    );
  }
}
