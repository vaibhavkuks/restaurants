import 'package:equatable/equatable.dart';
import '../domain/cart_item.dart';
import '../../../core/constants/app_constants.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;

  const CartLoaded({required this.items, required this.subtotal});

  double get deliveryFee => AppConstants.deliveryFee;
  double get serviceFee => AppConstants.serviceFee;
  double get total => subtotal + deliveryFee + serviceFee;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  @override
  List<Object> get props => [items, subtotal];

  CartLoaded copyWith({List<CartItem>? items, double? subtotal}) {
    return CartLoaded(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
