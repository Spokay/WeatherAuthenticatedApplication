import 'package:flutter/material.dart';
import 'package:zoubida/pages/home_page.dart';
import 'package:zoubida/pages/login_auth_page.dart';
import 'package:zoubida/pages/register_auth_page.dart';
import 'package:zoubida/pages/splash_screen.dart';
import 'pages/authenticate_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.splashRoute,
      routes: {
        SplashScreen.splashRoute: (context) => const SplashScreen(),
        '/authenticate': (context) => const AuthenticatePage(),
        '/register': (context) => const RegisterAuthPage(),
        '/login': (context) => const LoginAuthPage(),
        '/home': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}


