import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class LoadRestaurants extends RestaurantEvent {
  const LoadRestaurants();
}

class RefreshRestaurants extends RestaurantEvent {
  const RefreshRestaurants();
}
