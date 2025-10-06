import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<ClearCart>(_onClearCart);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    // In a real app, this would load from local storage
    emit(const CartLoaded(items: [], subtotal: 0.0));
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is! CartLoaded) {
      emit(const CartLoaded(items: [], subtotal: 0.0));
      add(event); // Re-add the event after proper initialization
      return;
    }

    final existingItemIndex = currentState.items.indexWhere(
      (item) => item.menuItem.id == event.menuItem.id,
    );

    List<CartItem> updatedItems;

    if (existingItemIndex >= 0) {
      // Update existing item
      final existingItem = currentState.items[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
        specialInstructions:
            event.specialInstructions ?? existingItem.specialInstructions,
      );

      updatedItems = List.from(currentState.items);
      updatedItems[existingItemIndex] = updatedItem;
    } else {
      // Add new item
      final newItem = CartItem(
        menuItem: event.menuItem,
        quantity: event.quantity,
        specialInstructions: event.specialInstructions,
      );
      updatedItems = [...currentState.items, newItem];
    }

    final subtotal = _calculateSubtotal(updatedItems);
    emit(CartLoaded(items: updatedItems, subtotal: subtotal));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final updatedItems = currentState.items
        .where((item) => item.menuItem.id != event.menuItemId)
        .toList();

    final subtotal = _calculateSubtotal(updatedItems);
    emit(CartLoaded(items: updatedItems, subtotal: subtotal));
  }

  void _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final itemIndex = currentState.items.indexWhere(
      (item) => item.menuItem.id == event.menuItemId,
    );

    if (itemIndex == -1) return;

    List<CartItem> updatedItems = List.from(currentState.items);

    if (event.quantity <= 0) {
      updatedItems.removeAt(itemIndex);
    } else {
      final updatedItem = updatedItems[itemIndex].copyWith(
        quantity: event.quantity,
        specialInstructions: event.specialInstructions,
      );
      updatedItems[itemIndex] = updatedItem;
    }

    final subtotal = _calculateSubtotal(updatedItems);
    emit(CartLoaded(items: updatedItems, subtotal: subtotal));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartLoaded(items: [], subtotal: 0.0));
  }

  double _calculateSubtotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
