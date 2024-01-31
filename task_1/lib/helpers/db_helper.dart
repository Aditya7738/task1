import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:task_1/model/dog_data_model.dart';
import 'dart:io' as io;

import 'package:task_1/model/user_model.dart';
import 'package:task_1/model/wishlist_model.dart';

class DBHelper {
  static Database? _db;

  final databaseName = "task.db";
  final tableName = "user";

  final firstColumn = "userId";
  final secondColumn = "name";

  final forthColumn = "phoneNo";
  final fifthColumn = "password";
  final sixthColumn = "username";
  final seventhColumn = "address";
  final eighthColumn = "isLogout";
  late String path;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return null;
  }

  _onCreate(Database db, int version) async {
    String sql = '''CREATE TABLE $tableName (
      $firstColumn TEXT PRIMARY_KEY,
       $secondColumn TEXT,
    
       $forthColumn TEXT, 
       $fifthColumn TEXT, 
       $sixthColumn TEXT,
       $seventhColumn TEXT,
       $eighthColumn INTEGER
      );''';

    await db.execute(sql);
    print("TABLE CREATED");
  }

  initDatabase() async {
    io.Directory documentDirectory =
        await getApplicationDocumentsDirectory(); //creating db in local storage
    path = join(documentDirectory.path, databaseName); //path of db
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print("DATABASE CREATED");
    return db;
  }

  Future<UserModel> insert(UserModel userModel) async {
    var client = await db;

    print(userModel.toMap()[firstColumn]);

    //client.delete();[]
    if (client != null) {
      print("user INSERT");
      print(userModel.toMap().toString());

      final value = await client.insert(tableName, userModel.toMap());

      print("RESULT $value");

      await client.insert(tableName, userModel.toMap());

      print("userModel.userId ${userModel.userId}");
      print("user INSERTED");
      return userModel;
    } else {
      _db = await initDatabase();
      await insert(userModel);
      return userModel;
    }
  }

  Future<UserModel?> checkLogin(String userName, String password) async {
    final database = await db;
    if (database != null) {
      List<Map<String, Object?>> result = await database.query(tableName,
          where: "$sixthColumn = ? AND $fifthColumn = ?",
          whereArgs: [userName, password]);

      print("result.runtimeType ${result.runtimeType}");
      print("result ${result}");

      if (result.length == 0) {
        return null;
      } else {
        UserModel userModel = UserModel(
            userId: result[0]["userId"].toString(),
            name: result[0]["name"].toString(),
            userName: result[0]["phoneNo"].toString(),
            phoneNo: result[0]["password"].toString(),
            password: result[0]["username"].toString(),
            address: result[0]["username"].toString(),
            isLogout: 1);
        return userModel;
      }
    }
    return null;
  }

  Future<void> updateLogout(String userId) async {
    final database = await db;
    if (database != null) {
      await database.update(
          tableName,
          {
            "isLogout": 1,
          },
          where: "$sixthColumn = ?",
          whereArgs: [userId]);
    }
  }

  final wishListTableName = "wishlist";

  Future<void> createWishlistTable() async {
    final database = await db;
    if (database != null) {
      await database.execute('''CREATE TABLE $wishListTableName (
      id INTEGER PRIMARY KEY,
      userId TEXT,
      dogId TEXT,
      name TEXT,
      referenceImageId TEXT
    )
  ''');
    }
  }

  Future<List<WishlistModel>?> getWishList() async {
    final database = await db;
    if (database != null) {
      final List<Map<String, dynamic>> maps =
          await database.query(wishListTableName);

      return List.generate(maps.length, (i) {
        return WishlistModel.fromMap(maps[i]);
      });
    }
    return null;
  }

  Future<List<WishlistModel>?> getFavDogsByUserId(int userId) async {
    final database = await db;
    if (database != null) {
      final List<Map<String, dynamic>> maps = await database.query(
        wishListTableName,
        where: 'userId = ?',
        whereArgs: [userId],
      );

      List<WishlistModel> list = <WishlistModel>[];

      for (int i = 0; i < maps.length; i++) {
        list.add(WishlistModel(
            id: maps[i]["id"],
            userId: int.parse(maps[i]["userId"]),
            dogId: maps[i]["dogId"],
            name: maps[i]["name"],
            referenceImageId: maps[i]["referenceImageId"]));
      }

      return list;
    }
    return null;
  }

  // _onCreate(Database db, int version) async {
  //   String sql = '''CREATE TABLE $tableName (
  //     $firstColumn TEXT PRIMARY_KEY,
  //      $secondColumn TEXT,

  //      $forthColumn TEXT,
  //      $fifthColumn TEXT,
  //      $sixthColumn TEXT,
  //      $seventhColumn TEXT,
  //      $eighthColumn INTEGER
  //     );''';

  //   await db.execute(sql);
  //   print("TABLE CREATED");
  // }

  Future<UserModel?> getUserById(int userId) async {
    final database = await db;
    if (database != null) {
      final List<Map<String, dynamic>> maps = await database.query(
        tableName,
        where: '$firstColumn = ?',
        whereArgs: [userId],
      );

      if (maps.isNotEmpty) {
        UserModel userModel = UserModel(
            userId: maps[0]["userId"].toString(),
            name: maps[0]["name"].toString(),
            userName: maps[0]["phoneNo"].toString(),
            phoneNo: maps[0]["password"].toString(),
            password: maps[0]["username"].toString(),
            address: maps[0]["username"].toString(),
            isLogout: 1);
        return userModel;
      }
    }
    return null;
  }

  Future<int> insertIntoWishlistTable(Map<String, dynamic> data) async {
    final database = await db;
    if (database != null) {
      return await database.insert(
        wishListTableName,
        {
          'userId': data["userId"],
          'dogId': data["dogId"],
          'name': data["name"],
          'referenceImageId': data["referenceImageId"]
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      return -1;
    }
  }

  Future<void> deleteItemFromWishList(int dog_id) async {
    final database = await db;
    if (database != null) {
      await database.delete(
        wishListTableName,
        where: 'dog_id = ?',
        whereArgs: [dog_id],
      );
    }
  }
}
