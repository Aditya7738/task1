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
    return _db;
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

  Future<List<UserModel>?> getAllUsers() async {
    final database = await db;
    if (database != null) {
      final List<Map<String, dynamic>> maps = await database.query(tableName);

      return List.generate(maps.length, (i) {
        return UserModel.fromMap(maps[i]);
      });
    }
    return null;
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
            userName: result[0]["username"].toString(),
            phoneNo: result[0]["phoneNo"].toString(),
            password: result[0]["password"].toString(),
            address: result[0]["address"].toString(),
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
      imageUrl TEXT
    )
  ''');
    }
  }

  Future<bool> isTableExists() async {
    final database = await db;
    if (database != null) {
      final List<Map<String, dynamic>> tables = await database.query(
          'sqlite_master',
          where: 'name = ?',
          whereArgs: [wishListTableName]);

      print("tables $tables");

      for (final table in tables) {
        print("Table $table");
        final String name = table['name'] as String;
        if (name == wishListTableName) {
          return true;
        }
      }

      return false;
    }
    return false;
  }

  Future<List<WishlistModel>?> getWishList() async {
    final database = await db;
    if (database != null) {
      final List<Map<String, dynamic>> maps =
          await database.query(wishListTableName);

      print("wishlistmaps $maps");

      List<WishlistModel> list = List.generate(maps.length, (i) {
        return WishlistModel.fromMap(maps[i]);
      });

      print("wishlist $list");

      return list;
    }
    return null;
  }

  Future<bool> isDogInFavorites(String userId, String dogId) async {
    var client = await db;

    if (client != null) {
      List<Map<String, dynamic>> results = await client.query(
        wishListTableName,
        where: "userId = ? AND dogId LIKE ?",
        whereArgs: [userId, dogId],
      );

      // If there is at least one row, it means the dog is in favorites
      return results.isNotEmpty;
    } 
    return false;
  }

  Future<List<WishlistModel>?> getFavDogsByUserId(String userId) async {
    final database = await db;
    if (database != null) {
      final List<Map<String, dynamic>> maps = await database.query(
        wishListTableName,
        where: 'userId = ?',
        whereArgs: [userId],
      );

      print("wishlistmaps $maps");

      List<WishlistModel> list = <WishlistModel>[];

      for (int i = 0; i < maps.length; i++) {
        list.add(WishlistModel(
            id: maps[i]["id"],
            userId: maps[i]["userId"],
            dogId: maps[i]["dogId"],
            name: maps[i]["name"],
            imageUrl: maps[i]["imageUrl"]));
      }

      print("wishlist $list");
      print("wishlist length ${list.length}");

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

  Future<UserModel?> getUserById(String userId) async {
    final database = await db;
    if (database != null) {
      final List<Map<String, dynamic>> maps = await database.query(
        tableName,
        where: '$firstColumn = ?',
        whereArgs: [userId],
      );

      print("user with id is there $maps");

      if (maps.isNotEmpty) {
        UserModel userModel = UserModel(
            userId: maps[0]["userId"].toString(),
            name: maps[0]["name"].toString(),
            userName: maps[0]["username"].toString(),
            phoneNo: maps[0]["phoneNo"].toString(),
            password: maps[0]["password"].toString(),
            address: maps[0]["address"].toString(),
            isLogout: maps[0]["isLogout"]);
        return userModel;
      } else {
        print("user with id is not there $maps");
        return null;
      }
    }
    return null;
  }

  Future<int> insertIntoWishlistTable(Map<String, dynamic> data) async {
    final database = await db;
    if (database != null) {
      int result = await database.insert(
        wishListTableName,
        {
          'userId': data["userId"],
          'dogId': data["dogId"],
          'name': data["name"],
          'imageUrl': data["imageUrl"]
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      getWishList();

      return result;
    } else {
      return -1;
    }
  }

  Future<void> deleteItemFromWishList(int dog_id) async {
    final database = await db;
    if (database != null) {
      await database.delete(
        wishListTableName,
        where: 'dogId = ?',
        whereArgs: [dog_id],
      );

      getWishList();
    }
  }
}
