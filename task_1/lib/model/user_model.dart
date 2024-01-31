import 'dart:core';

class UserModel {
  late String userId;
  late String name;

  late String phoneNo;
  late String password;
  late String userName;
  late String address;
  late int isLogout;

  UserModel(
      {required this.userId,
      required this.userName,
      required this.name,
      required this.phoneNo,
      required this.password,
      required this.address,
      required this.isLogout});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "userId": userId,
      "name": name,
      "username": userName,
      "phoneNo": phoneNo,
      "password": password,
      "address": address,
      "isLogout": isLogout
    };

    return map;
  }

  UserModel.fromMap(Map<String, dynamic> userData) {
    userId = userData["userId"];
    name = userData["name"];

    userName = userData["username"];
    phoneNo = userData["phoneNo"];
    password = userData["password"];
    address = userData["address"];
    isLogout = userData["isLogout"];
  }
}
