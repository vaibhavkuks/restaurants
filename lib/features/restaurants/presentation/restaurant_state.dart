import 'package:equatable/equatable.dart';
import '../domain/restaurant.dart';
import '../../../core/error/failures.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object> get props => [];
}

class RestaurantInitial extends RestaurantState {
  const RestaurantInitial();
}

class RestaurantLoading extends RestaurantState {
  const RestaurantLoading();
}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;

  const RestaurantLoaded(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class RestaurantError extends RestaurantState {
  final Failure failure;

  const RestaurantError(this.failure);

  @override
  List<Object> get props => [failure];
}
