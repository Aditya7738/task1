import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/providers/wishlist_provider.dart';
import 'package:task_1/views/pages/catalog_page.dart';
import 'package:task_1/views/pages/login.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: checkIfUserAlreadyLoggedIn(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
          print(snapshot.data);
          print(snapshot.hasError);
          print(snapshot.hasData);
          return  snapshot.data != null
                  ? CatalogPage(userModel: snapshot.data)
                  : LoginPage();
        });
  }

  // bool checkNullOrNot(UserModel? userModel) {

  // }

  // getUserModel(BuildContext context) async {
  //   final userModel = await checkIfUserAlreadyLoggedIn(context);
  //   if (userModel != null) {
  //     return userModel;
  //   }
  // }

  Future<UserModel?> checkIfUserAlreadyLoggedIn(BuildContext context) async {
   
      final userId = await Provider.of<WishlistProvider>(context, listen: false)
          .getuserSharedPrefs();

          print(userId);

      if (userId != null || userId == "") {
        DBHelper dbHelper = DBHelper();
        UserModel? userModel = await dbHelper.getUserById(userId!);
      
        if (userModel != null) {
          print("userModel return $userModel");
     
          return userModel;
        } else {
          print("userModel return null");
          return null;
        }
      }
      return null;
   
  }
}
