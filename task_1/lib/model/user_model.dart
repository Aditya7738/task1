import 'dart:core';

class UserModel {
  late String userId;
  late String name;

  late String email;
  late String phoneNo;
  late String password;
  late String userName;
   late String address;

  UserModel(
      {required this.userId,
      required this.email,
      required this.userName,
      required this.name,
      required this.phoneNo,
      required this.password,
      required this.address});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "user_id": userId,
      "name": name,
      "email": email,
      "phone_no": phoneNo,
      "password": password,
      "address": address
    };

    return map;
  }

  UserModel.fromMap(Map<String, dynamic> userData) {
    userId = userData["user_id"];
    name = userData["name"];

    email = userData["email"];
    phoneNo = userData["phone_no"];
    password = userData["password"];
    address =  userData["address"];
  }
}
