import 'package:fitness_app_api_use/src/page/homePage.dart';
import 'package:fitness_app_api_use/src/page/splashscreen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
