import 'package:flutter/material.dart';
// import 'dart.ui';
import 'package:quizquest/screen/splash_screen.dart';

void main() {
  

  runApp(MaterialApp(
    title: 'ISSA - Quiz Quest',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const SplashScreen(),
    
  ));
} 
