import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:task_1/model/user_model.dart';

class DBHelper {
  static Database? _db;

  final database_Name = "user.db";
  final table_Name = "user";
  final firstColumn = "userId";
  final secondColumn = "firstName";

  final thirdColumn = "email";
  final forthColumn = "phoneNo";
  final fifthColumn = "password";
  final sixthColumn = "password";
  final seventhColumn = "address";

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory =
        await getApplicationDocumentsDirectory(); //creating db in local storage
    String path = join(documentDirectory.path, database_Name); //path of db
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print("DATABASE CREATED");
    return db;
  }

  _onCreate(Database db, int version) async {
    String sql = '''CREATE TABLE $table_Name (
      $firstColumn TEXT PRIMARY_KEY,
       $secondColumn TEXT,
       $thirdColumn TEXT, 
       $forthColumn TEXT, 
       $fifthColumn TEXT, 
       $sixthColumn TEXT
       $seventhColumn TEXT
      );''';

    await db.execute(sql);
    print("TABLE CREATED");
  }

  Future<UserModel> insert(UserModel userModel) async {
    var client = await db;
    //client.delete();[]
    if (client != null) {
      print("user INSERT");
      print(userModel.toMap().toString());
      userModel.userId =
          (await client.insert(table_Name, userModel.toMap())) as String;
      print("user INSERTED");
      return userModel;
    } else {
      _db = await initDatabase();
      await insert(userModel);
      return userModel;
    }
  }

  // Future<List<CartProductModel>> getCartList() async{
  //   var client = await db;
  //   final List<Map<String, Object?>> queryResult = await client!.query('cart');
  //   return queryResult.map((e) => CartProductModel.fromMap(e)).toList();

  // }
}
