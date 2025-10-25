import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/db/favorite_db_helper.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteDbHelper databaseHelper;

  FavoriteProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  Future<void> _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    notifyListeners();
  }

  Future<void> checkFavorite(String id) async {
    _isFavorite = await databaseHelper.isFavorite(id);
    notifyListeners();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    await databaseHelper.insertFavorite(restaurant);
    _isFavorite = true;
    _getFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await databaseHelper.removeFavorite(id);
    _isFavorite = false;
    _getFavorites();
  }
}
