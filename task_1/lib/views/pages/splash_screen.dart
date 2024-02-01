import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:page_transition/page_transition.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/providers/wishlist_provider.dart';
import 'package:task_1/views/pages/catalog_page.dart';
import 'package:task_1/views/pages/loading_page.dart';
import 'package:task_1/views/pages/login.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // getUserModel(context);

    // final wishListProvider = Provider.of<WishlistProvider>(context);

    return AnimatedSplashScreen(
        duration: 3000,
        splash: const Text(
          "Task",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
        nextScreen: LoadingPage(),
        splashTransition: SplashTransition.slideTransition,
        pageTransitionType: PageTransitionType.rightToLeft);
  }
}
