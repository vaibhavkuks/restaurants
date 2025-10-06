import 'package:equatable/equatable.dart';
import '../../menu/domain/menu_item.dart';

class CartItem extends Equatable {
  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions;

  const CartItem({
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [menuItem, quantity, specialInstructions];
}
