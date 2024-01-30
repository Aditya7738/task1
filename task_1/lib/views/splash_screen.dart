import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:page_transition/page_transition.dart';
import 'package:task_1/views/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: const Text("Task", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),),

       nextScreen: LoginPage(),
       splashTransition: SplashTransition.slideTransition,
       pageTransitionType: PageTransitionType.rightToLeft);
  }
}