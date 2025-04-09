import 'package:flutter/material.dart';
import 'package:quizquest/screen/my_home_page.dart';

import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 222, 217),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 300.0,
        ), // Your splash logo here
      ),
    );
  }
}
