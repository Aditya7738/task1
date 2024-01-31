import 'package:flutter/material.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:task_1/providers/wishlist_provider.dart';
import 'package:task_1/views/pages/catalog_page.dart';
import 'package:task_1/views/pages/login.dart';
import 'package:task_1/views/pages/splash_screen.dart';
import 'package:task_1/views/pages/wishlist_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    DBHelper dbHelper = DBHelper();
    dbHelper.initDatabase();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WishlistProvider())
      ],
      child: MaterialApp(
          theme: ThemeData(
              textTheme: TextTheme(
            headline3: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          )),
          debugShowCheckedModeBanner: false,
          home: SplashScreen()),
    );
  }
}
