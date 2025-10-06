import 'package:equatable/equatable.dart';
import '../../cart/domain/cart_item.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class PlaceOrder extends OrderEvent {
  final String restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;
  final String deliveryAddress;
  final String? specialInstructions;

  const PlaceOrder({
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
    required this.deliveryAddress,
    this.specialInstructions,
  });

  @override
  List<Object?> get props => [
    restaurantId,
    restaurantName,
    items,
    subtotal,
    deliveryFee,
    serviceFee,
    total,
    deliveryAddress,
    specialInstructions,
  ];
}

class LoadOrders extends OrderEvent {
  const LoadOrders();
}

class LoadOrderById extends OrderEvent {
  final String orderId;

  const LoadOrderById(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class RefreshOrderStatus extends OrderEvent {
  final String orderId;

  const RefreshOrderStatus(this.orderId);

  @override
  List<Object> get props => [orderId];
}
