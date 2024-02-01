import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider with ChangeNotifier {
  String _userId = "0";
  String get userId => _userId;

  List<int> _favDogIds = <int>[];
  List<int> get favDogIds => _favDogIds;

  void addToWishlist(int dogId) {
    _favDogIds.add(dogId);
    _setDogSharedPreference();

    notifyListeners();
  }

  void removeFromWishlist(int dogId) {
    _favDogIds.remove(dogId);
    _setDogSharedPreference();
    notifyListeners();
  }

  void setuserId(String uid) {
    _userId = uid;
    _setSharedPreference();
    notifyListeners();
  }

  // void setfavDogIds(List<int> dogids) {
  //   _favDogIds = dogids;
  //   _setDogSharedPreference();
  //   notifyListeners();
  // }

  String getuserId() {
    return _userId;
  }

  List<int> getFavDogIds() {
    return _favDogIds;
  }

  void _setSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    bool savinguserData =
        await sharedPreferences.setString("userId", getuserId());
    print("Saved savinguserData $savinguserData");
  }

  void _setDogSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savingFavDogData = await sharedPreferences.setString(
        "favDogs", jsonEncode(getFavDogIds()));
    print("Saved savingFavDogData $savingFavDogData");
  }

  Future<String?> getDogSharedPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? savingFavDogData = sharedPreferences.getString("favDogs");

    if (savingFavDogData != null) {
      try {
        _favDogIds = List<int>.from(jsonDecode(savingFavDogData));
        //print(_customerData.runtimeType);
        // _customerData = list as List<Map<String, dynamic>>;
        print("savingFavDogData ${_favDogIds[0]}");
        print("savingFavDogData ${_favDogIds.length}");
      } catch (e) {
        print("Error customer decoding ${e.toString()}");
      }
    } else {
      _favDogIds = <int>[];
    }

    print("savingFavDogData $savingFavDogData");

    notifyListeners();
    return null;
  }

  Future<String?> getuserSharedPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataString = sharedPreferences.getString("userId");

    if (userDataString != null) {
      print("userDataString $userDataString");
      return userDataString;
    }

    notifyListeners();
    return null;
  }
}
