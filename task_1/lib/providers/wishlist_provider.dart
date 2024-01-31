import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  int _userId = 0;
  int get userId => _userId;

  List<int> _favDogIds = <int>[];
  List<int> get favDogIds => _favDogIds;

  void addToWishlist(int dogId) {
    _favDogIds.add(dogId);
    notifyListeners();
  }

  void removeFromWishlist(int dogId) {
    _favDogIds.remove(dogId);
    notifyListeners();
  }

  void setuserId(int uid) {
    _userId = uid;
    notifyListeners();
  }

  int getuserId() {
    return _userId;
  }
}
