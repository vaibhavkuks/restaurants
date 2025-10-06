import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurants/features/cart/presentation/cart_bloc.dart';
import 'package:restaurants/features/cart/presentation/cart_event.dart';
import 'package:restaurants/features/cart/presentation/cart_state.dart';
import 'package:restaurants/features/cart/domain/cart_item.dart';
import 'package:restaurants/features/menu/domain/menu_item.dart';

void main() {
  group('CartBloc', () {
    late CartBloc cartBloc;

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
      quantity: 1,
      specialInstructions: null,
    );

    setUp(() {
      cartBloc = CartBloc();
    });

    tearDown(() {
      cartBloc.close();
    });

    test('initial state is CartInitial', () {
      expect(cartBloc.state, const CartInitial());
    });

    group('LoadCart', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] with empty cart',
        build: () => cartBloc,
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [const CartLoaded(items: [], subtotal: 0.0)],
      );
    });

    group('AddToCart', () {
      blocTest<CartBloc, CartState>(
        'adds new item to empty cart',
        build: () => cartBloc,
        seed: () => const CartLoaded(items: [], subtotal: 0.0),
        act: (bloc) => bloc.add(
          const AddToCart(
            menuItem: tMenuItem,
            quantity: 2,
            specialInstructions: 'Extra spicy',
          ),
        ),
        expect: () => [
          CartLoaded(
            items: [
              const CartItem(
                menuItem: tMenuItem,
                quantity: 2,
                specialInstructions: 'Extra spicy',
              ),
            ],
            subtotal: 25.98, // 12.99 * 2
          ),
        ],
      );

      blocTest<CartBloc, CartState>(
        'updates existing item quantity when adding same item',
        build: () => cartBloc,
        seed: () => const CartLoaded(items: [tCartItem], subtotal: 12.99),
        act: (bloc) =>
            bloc.add(const AddToCart(menuItem: tMenuItem, quantity: 1)),
        expect: () => [
          CartLoaded(
            items: [
              const CartItem(
                menuItem: tMenuItem,
                quantity: 2,
                specialInstructions: null,
              ),
            ],
            subtotal: 25.98, // 12.99 * 2
          ),
        ],
      );
    });

    group('UpdateCartItem', () {
      blocTest<CartBloc, CartState>(
        'updates item quantity',
        build: () => cartBloc,
        seed: () => const CartLoaded(items: [tCartItem], subtotal: 12.99),
        act: (bloc) =>
            bloc.add(const UpdateCartItem(menuItemId: '1', quantity: 3)),
        expect: () => [
          CartLoaded(
            items: [
              const CartItem(
                menuItem: tMenuItem,
                quantity: 3,
                specialInstructions: null,
              ),
            ],
            subtotal: 38.97, // 12.99 * 3
          ),
        ],
      );

      blocTest<CartBloc, CartState>(
        'removes item when quantity is 0',
        build: () => cartBloc,
        seed: () => const CartLoaded(items: [tCartItem], subtotal: 12.99),
        act: (bloc) =>
            bloc.add(const UpdateCartItem(menuItemId: '1', quantity: 0)),
        expect: () => [const CartLoaded(items: [], subtotal: 0.0)],
      );
    });

    group('RemoveFromCart', () {
      blocTest<CartBloc, CartState>(
        'removes item from cart',
        build: () => cartBloc,
        seed: () => const CartLoaded(items: [tCartItem], subtotal: 12.99),
        act: (bloc) => bloc.add(const RemoveFromCart('1')),
        expect: () => [const CartLoaded(items: [], subtotal: 0.0)],
      );
    });

    group('ClearCart', () {
      blocTest<CartBloc, CartState>(
        'clears all items from cart',
        build: () => cartBloc,
        seed: () => const CartLoaded(items: [tCartItem], subtotal: 12.99),
        act: (bloc) => bloc.add(const ClearCart()),
        expect: () => [const CartLoaded(items: [], subtotal: 0.0)],
      );
    });

    group('CartLoaded calculations', () {
      test('calculates total correctly', () {
        const cartState = CartLoaded(items: [tCartItem], subtotal: 12.99);
        expect(cartState.total, closeTo(16.49, 0.01)); // 12.99 + 2.50 + 1.00
      });

      test('calculates total items correctly', () {
        const cartState = CartLoaded(
          items: [
            CartItem(menuItem: tMenuItem, quantity: 2),
            CartItem(menuItem: tMenuItem, quantity: 3),
          ],
          subtotal: 64.95,
        );
        expect(cartState.totalItems, 5);
      });

      test('isEmpty returns true for empty cart', () {
        const cartState = CartLoaded(items: [], subtotal: 0.0);
        expect(cartState.isEmpty, true);
      });

      test('isEmpty returns false for non-empty cart', () {
        const cartState = CartLoaded(items: [tCartItem], subtotal: 12.99);
        expect(cartState.isEmpty, false);
      });
    });
  });
}
