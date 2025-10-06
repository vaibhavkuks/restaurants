import 'package:equatable/equatable.dart';
import '../../cart/domain/cart_item.dart';

enum OrderStatus {
  placed,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

class Order extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String deliveryAddress;
  final String? specialInstructions;
  final int estimatedDeliveryTime;

  const Order({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    required this.deliveryAddress,
    this.specialInstructions,
    required this.estimatedDeliveryTime,
  });

  Order copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? serviceFee,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? deliveredAt,
    String? deliveryAddress,
    String? specialInstructions,
    int? estimatedDeliveryTime,
  }) {
    return Order(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      serviceFee: serviceFee ?? this.serviceFee,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    );
  }

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    restaurantName,
    items,
    subtotal,
    deliveryFee,
    serviceFee,
    total,
    status,
    createdAt,
    deliveredAt,
    deliveryAddress,
    specialInstructions,
    estimatedDeliveryTime,
  ];
}
