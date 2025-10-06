import 'package:equatable/equatable.dart';
import '../../menu/domain/menu_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions;

  const AddToCart({
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
  });

  @override
  List<Object?> get props => [menuItem, quantity, specialInstructions];
}

class RemoveFromCart extends CartEvent {
  final String menuItemId;

  const RemoveFromCart(this.menuItemId);

  @override
  List<Object> get props => [menuItemId];
}

class UpdateCartItem extends CartEvent {
  final String menuItemId;
  final int quantity;
  final String? specialInstructions;

  const UpdateCartItem({
    required this.menuItemId,
    required this.quantity,
    this.specialInstructions,
  });

  @override
  List<Object?> get props => [menuItemId, quantity, specialInstructions];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class LoadCart extends CartEvent {
  const LoadCart();
}
