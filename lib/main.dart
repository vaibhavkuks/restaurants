import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/app_theme.dart';
import 'features/restaurants/data/restaurant_data_source.dart';
import 'features/restaurants/presentation/restaurant_bloc.dart';
import 'features/restaurants/presentation/restaurant_list_screen.dart';
import 'features/menu/data/menu_data_source.dart';
import 'features/menu/presentation/menu_bloc.dart';
import 'features/menu/presentation/menu_screen.dart';
import 'features/menu/presentation/menu_event.dart';
import 'features/cart/presentation/cart_bloc.dart';
import 'features/cart/presentation/cart_screen.dart';
import 'features/cart/presentation/cart_event.dart';
import 'features/orders/data/order_data_source.dart';
import 'features/orders/presentation/order_bloc.dart';
import 'features/orders/presentation/checkout_screen.dart';
import 'features/orders/presentation/order_confirmation_screen.dart';
import 'features/restaurants/domain/restaurant.dart';
import 'features/orders/domain/order.dart';
import 'features/cart/presentation/cart_state.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              RestaurantBloc(dataSource: MockRestaurantDataSource()),
        ),
        BlocProvider(
          create: (context) => MenuBloc(dataSource: MockMenuDataSource()),
        ),
        BlocProvider(create: (context) => CartBloc()..add(const LoadCart())),
        BlocProvider(
          create: (context) => OrderBloc(dataSource: MockOrderDataSource()),
        ),
      ],
      child: MaterialApp(
        title: 'Food Delivery',
        theme: AppTheme.lightTheme,
        home: const RestaurantListScreen(),
        onGenerateRoute: _generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const RestaurantListScreen());
      case '/menu':
        final restaurant = settings.arguments as Restaurant;
        return MaterialPageRoute(
          builder: (context) {
            // Load menu items when navigating to menu screen
            context.read<MenuBloc>().add(LoadMenuItems(restaurant.id));
            return MenuScreen(restaurant: restaurant);
          },
        );
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case '/checkout':
        final cartState = settings.arguments as CartLoaded;
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(cartState: cartState),
        );
      case '/order-confirmation':
        final order = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(order: order),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
