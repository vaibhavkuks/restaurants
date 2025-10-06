import '../domain/order.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/utils/extensions.dart';
import 'package:uuid/uuid.dart';

abstract class OrderDataSource {
  Future<Order> placeOrder(Order order);
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String id);
  Future<Order> updateOrderStatus(String id, OrderStatus status);
}

class MockOrderDataSource implements OrderDataSource {
  final List<Order> _orders = [];
  final Uuid _uuid = const Uuid();

  @override
  Future<Order> placeOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Simulate occasional order placement failure
    if (DateTime.now().millisecond % 30 == 0) {
      throw const ServerException('Failed to place order. Please try again.');
    }

    final newOrder = order.copyWith(
      id: _uuid.v4(),
      status: OrderStatus.placed,
      createdAt: DateTime.now(),
    );

    _orders.add(newOrder);

    // Simulate order status updates
    _simulateOrderProgress(newOrder.id);

    return newOrder;
  }

  @override
  Future<List<Order>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_orders.reversed);
  }

  @override
  Future<Order> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final order = _orders.where((o) => o.id == id).firstOrNull;
    if (order == null) {
      throw const ServerException('Order not found');
    }

    return order;
  }

  @override
  Future<Order> updateOrderStatus(String id, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final orderIndex = _orders.indexWhere((o) => o.id == id);
    if (orderIndex == -1) {
      throw const ServerException('Order not found');
    }

    final updatedOrder = _orders[orderIndex].copyWith(
      status: status,
      deliveredAt: status == OrderStatus.delivered ? DateTime.now() : null,
    );

    _orders[orderIndex] = updatedOrder;
    return updatedOrder;
  }

  void _simulateOrderProgress(String orderId) {
    // Simulate realistic order progression
    Future.delayed(const Duration(seconds: 2), () {
      updateOrderStatus(orderId, OrderStatus.confirmed);
    });

    Future.delayed(const Duration(seconds: 5), () {
      updateOrderStatus(orderId, OrderStatus.preparing);
    });

    Future.delayed(const Duration(seconds: 15), () {
      updateOrderStatus(orderId, OrderStatus.outForDelivery);
    });

    Future.delayed(const Duration(seconds: 25), () {
      updateOrderStatus(orderId, OrderStatus.delivered);
    });
  }
}
