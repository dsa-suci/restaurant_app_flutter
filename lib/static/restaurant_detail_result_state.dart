import 'package:restaurant_app/data/model/restaurant_detail.dart';

abstract class RestaurantDetailResultState {}

class RestaurantDetailNoneState extends RestaurantDetailResultState {}

class RestaurantDetailLoadingState extends RestaurantDetailResultState {}

class RestaurantDetailLoadedState extends RestaurantDetailResultState {
  final RestaurantDetail restaurant;

  RestaurantDetailLoadedState(this.restaurant);
}

class RestaurantDetailErrorState extends RestaurantDetailResultState {
  final String message;

  RestaurantDetailErrorState(this.message);
}
