import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String splashRoute = '/';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State {
  void timeToShowSplashScreenOnScreen() async {
    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;
      SharedPreferences storage = await SharedPreferences.getInstance();
      bool? isLoggedIn = storage.getBool('isLoggedIn');
      if (isLoggedIn != null && isLoggedIn) {
        goHome();
      }else {
        goAuthenticate();
      }
    });
  }

  void goHome(){
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  void goAuthenticate(){
    Navigator.of(context).pushNamedAndRemoveUntil('/authenticate', (route) => false);
  }
  @override
  void initState() {
    super.initState();
    timeToShowSplashScreenOnScreen();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage('assets/weather-icon.png')
            )
          ],
        ),
      ),
    );
  }
}