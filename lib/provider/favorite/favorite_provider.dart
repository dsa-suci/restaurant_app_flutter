import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/db/favorite_db_helper.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteDbHelper dbHelper;
  List<Restaurant> _favorites = [];
  bool _isLoading = false;

  FavoriteProvider({required this.dbHelper}) {
    loadFavorites();
  }

  List<Restaurant> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    _favorites = await dbHelper.getFavorites();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    await dbHelper.insertFavorite(restaurant);
    await loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await dbHelper.removeFavorite(id);
    await loadFavorites();
  }

  Future<bool> isFavorite(String id) async {
    return await dbHelper.isFavorite(id);
  }
}
