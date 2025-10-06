import 'package:equatable/equatable.dart';
import '../domain/menu_item.dart';
import '../../../core/error/failures.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final List<MenuItem> menuItems;
  final String restaurantId;

  const MenuLoaded(this.menuItems, this.restaurantId);

  @override
  List<Object> get props => [menuItems, restaurantId];
}

class MenuError extends MenuState {
  final Failure failure;

  const MenuError(this.failure);

  @override
  List<Object> get props => [failure];
}
