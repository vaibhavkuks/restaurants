import 'package:equatable/equatable.dart';
import '../domain/order.dart';
import '../../../core/error/failures.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderPlacing extends OrderState {
  const OrderPlacing();
}

class OrderPlaced extends OrderState {
  final Order order;

  const OrderPlaced(this.order);

  @override
  List<Object> get props => [order];
}

class OrdersLoading extends OrderState {
  const OrdersLoading();
}

class OrdersLoaded extends OrderState {
  final List<Order> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderLoaded extends OrderState {
  final Order order;

  const OrderLoaded(this.order);

  @override
  List<Object> get props => [order];
}

class OrderError extends OrderState {
  final Failure failure;

  const OrderError(this.failure);

  @override
  List<Object> get props => [failure];
}
