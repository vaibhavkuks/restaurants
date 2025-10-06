import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class LoadMenuItems extends MenuEvent {
  final String restaurantId;

  const LoadMenuItems(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

class RefreshMenuItems extends MenuEvent {
  final String restaurantId;

  const RefreshMenuItems(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}
