import 'package:flutter/material.dart';
import 'package:task_1/helpers/db_helper.dart';

import 'package:task_1/views/splash_screen.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  

  @override
  Widget build(BuildContext context) {
     DBHelper dbHelper = DBHelper();
    dbHelper.initDatabase();
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}
