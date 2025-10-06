import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurants/features/orders/data/order_data_source.dart';
import 'package:restaurants/features/orders/domain/order.dart';
import 'package:restaurants/features/orders/presentation/order_bloc.dart';
import 'package:restaurants/features/orders/presentation/order_event.dart';
import 'package:restaurants/features/orders/presentation/order_state.dart';
import 'package:restaurants/features/cart/domain/cart_item.dart';
import 'package:restaurants/features/menu/domain/menu_item.dart';
import 'package:restaurants/core/error/exceptions.dart';
import 'package:restaurants/core/error/failures.dart';

class MockOrderDataSource extends Mock implements OrderDataSource {}

void main() {
  group('OrderBloc', () {
    late OrderBloc orderBloc;
    late MockOrderDataSource mockDataSource;

    const tMenuItem = MenuItem(
      id: '1',
      restaurantId: '1',
      name: 'Test Item',
      description: 'A test menu item',
      price: 12.99,
      imageUrl: 'https://example.com/item.jpg',
      category: 'Main',
      isVegetarian: false,
      isAvailable: true,
      ingredients: ['ingredient1', 'ingredient2'],
      preparationTime: 15,
    );

    const tCartItem = CartItem(
      menuItem: tMenuItem,
      quantity: 2,
      specialInstructions: 'Extra spicy',
    );

    final tOrder = Order(
      id: 'order-123',
      restaurantId: '1',
      restaurantName: 'Test Restaurant',
      items: const [tCartItem],
      subtotal: 25.98,
      deliveryFee: 2.50,
      serviceFee: 1.00,
      total: 29.48,
      status: OrderStatus.placed,
      createdAt: DateTime.now(),
      deliveryAddress: '123 Test Street',
      estimatedDeliveryTime: 30,
    );

    const tPlaceOrderEvent = PlaceOrder(
      restaurantId: '1',
      restaurantName: 'Test Restaurant',
      items: [tCartItem],
      subtotal: 25.98,
      deliveryFee: 2.50,
      serviceFee: 1.00,
      total: 29.48,
      deliveryAddress: '123 Test Street',
      specialInstructions: 'Ring doorbell',
    );

    setUp(() {
      mockDataSource = MockOrderDataSource();
      orderBloc = OrderBloc(dataSource: mockDataSource);
    });

    tearDown(() {
      orderBloc.close();
    });

    setUpAll(() {
      registerFallbackValue(tOrder);
    });

    test('initial state is OrderInitial', () {
      expect(orderBloc.state, const OrderInitial());
    });

    group('PlaceOrder', () {
      blocTest<OrderBloc, OrderState>(
        'emits [OrderPlacing, OrderPlaced] when order is placed successfully',
        build: () {
          when(
            () => mockDataSource.placeOrder(any()),
          ).thenAnswer((_) async => tOrder);
          return orderBloc;
        },
        act: (bloc) => bloc.add(tPlaceOrderEvent),
        expect: () => [const OrderPlacing(), OrderPlaced(tOrder)],
        verify: (_) {
          verify(() => mockDataSource.placeOrder(any())).called(1);
        },
      );

      blocTest<OrderBloc, OrderState>(
        'emits [OrderPlacing, OrderError] when NetworkException is thrown',
        build: () {
          when(
            () => mockDataSource.placeOrder(any()),
          ).thenThrow(const NetworkException('Network error'));
          return orderBloc;
        },
        act: (bloc) => bloc.add(tPlaceOrderEvent),
        expect: () => [
          const OrderPlacing(),
          const OrderError(NetworkFailure('Network error')),
        ],
      );

      blocTest<OrderBloc, OrderState>(
        'emits [OrderPlacing, OrderError] when ServerException is thrown',
        build: () {
          when(
            () => mockDataSource.placeOrder(any()),
          ).thenThrow(const ServerException('Server error'));
          return orderBloc;
        },
        act: (bloc) => bloc.add(tPlaceOrderEvent),
        expect: () => [
          const OrderPlacing(),
          const OrderError(ServerFailure('Server error')),
        ],
      );
    });

    group('LoadOrders', () {
      blocTest<OrderBloc, OrderState>(
        'emits [OrdersLoading, OrdersLoaded] when orders are loaded successfully',
        build: () {
          when(
            () => mockDataSource.getOrders(),
          ).thenAnswer((_) async => [tOrder]);
          return orderBloc;
        },
        act: (bloc) => bloc.add(const LoadOrders()),
        expect: () => [
          const OrdersLoading(),
          OrdersLoaded([tOrder]),
        ],
        verify: (_) {
          verify(() => mockDataSource.getOrders()).called(1);
        },
      );
    });

    group('LoadOrderById', () {
      blocTest<OrderBloc, OrderState>(
        'emits [OrderLoading, OrderLoaded] when order is loaded successfully',
        build: () {
          when(
            () => mockDataSource.getOrderById('order-123'),
          ).thenAnswer((_) async => tOrder);
          return orderBloc;
        },
        act: (bloc) => bloc.add(const LoadOrderById('order-123')),
        expect: () => [const OrderLoading(), OrderLoaded(tOrder)],
        verify: (_) {
          verify(() => mockDataSource.getOrderById('order-123')).called(1);
        },
      );
    });

    group('RefreshOrderStatus', () {
      blocTest<OrderBloc, OrderState>(
        'emits [OrderLoaded] when order status is refreshed successfully',
        build: () {
          when(
            () => mockDataSource.getOrderById('order-123'),
          ).thenAnswer((_) async => tOrder);
          return orderBloc;
        },
        act: (bloc) => bloc.add(const RefreshOrderStatus('order-123')),
        expect: () => [OrderLoaded(tOrder)],
      );
    });
  });
}
