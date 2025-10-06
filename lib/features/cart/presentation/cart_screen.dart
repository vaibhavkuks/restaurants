import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/widgets/custom_container.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_theme.dart';
import '../presentation/cart_bloc.dart';
import '../presentation/cart_event.dart';
import '../presentation/cart_state.dart';
import '../domain/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        bottom: AppTheme.appBarBottomBorder(),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && !state.isEmpty) {
                return TextButton(
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                  child: const Text('Clear'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded) {
            context.read<CartBloc>().add(const LoadCart());
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = state.items[index];
                    return _CartItemCard(cartItem: cartItem);
                  },
                ),
              ),
              _buildCartSummary(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: AppConstants.paddingLarge),
          Text(
            'Your cart is empty',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'Add some delicious items from our restaurants',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          FilledButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Browse Restaurants'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  '\$${state.subtotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Fee',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '\$${state.deliveryFee.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service Fee',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '\$${state.serviceFee.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Divider(height: AppConstants.paddingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${state.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/checkout', arguments: state);
                },
                child: Text('Proceed to Checkout (${state.totalItems} items)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                context.read<CartBloc>().add(const ClearCart());
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              AppConstants.containerBorderRadius,
            ),
            child: CachedNetworkImage(
              imageUrl: cartItem.menuItem.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant),
              ),
              errorWidget: (context, url, error) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.menuItem.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (cartItem.menuItem.isVegetarian)
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${cartItem.menuItem.price.toStringAsFixed(2)} each',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                if (cartItem.specialInstructions != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Note: ${cartItem.specialInstructions}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppConstants.paddingSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (cartItem.quantity > 1) {
                                context.read<CartBloc>().add(
                                  UpdateCartItem(
                                    menuItemId: cartItem.menuItem.id,
                                    quantity: cartItem.quantity - 1,
                                    specialInstructions:
                                        cartItem.specialInstructions,
                                  ),
                                );
                              } else {
                                context.read<CartBloc>().add(
                                  RemoveFromCart(cartItem.menuItem.id),
                                );
                              }
                            },
                            icon: const Icon(Icons.remove),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingSmall,
                            ),
                            child: Text(
                              cartItem.quantity.toString(),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                UpdateCartItem(
                                  menuItemId: cartItem.menuItem.id,
                                  quantity: cartItem.quantity + 1,
                                  specialInstructions:
                                      cartItem.specialInstructions,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
