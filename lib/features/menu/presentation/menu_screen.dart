import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart' as error_widget;
import '../../../shared/widgets/custom_container.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../restaurants/domain/restaurant.dart';
import '../../cart/presentation/cart_bloc.dart';
import '../../cart/presentation/cart_event.dart';
import '../../cart/presentation/cart_state.dart';
import '../presentation/menu_bloc.dart';
import '../presentation/menu_state.dart';
import '../presentation/menu_event.dart';
import '../domain/menu_item.dart';
import 'menu_item_detail_sheet.dart';

class MenuScreen extends StatelessWidget {
  final Restaurant restaurant;

  const MenuScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: AppTheme.appBarBottomBorder(),
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuInitial) {
            return const LoadingWidget(message: 'Loading menu...');
          } else if (state is MenuLoading) {
            return const LoadingWidget(message: 'Loading menu...');
          } else if (state is MenuError) {
            return error_widget.ErrorWidget(
              failure: state.failure,
              onRetry: () {
                context.read<MenuBloc>().add(LoadMenuItems(restaurant.id));
              },
            );
          } else if (state is MenuLoaded) {
            return _buildMenuContent(context, state.menuItems);
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is CartLoaded && !cartState.isEmpty) {
            return _CartBottomBar(cartState: cartState);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMenuContent(BuildContext context, List<MenuItem> menuItems) {
    final groupedItems = <String, List<MenuItem>>{};

    for (final item in menuItems) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView.builder(
      itemCount: groupedItems.keys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildRestaurantInfo(context);
        }

        final categories = groupedItems.keys.toList();
        final categoryIndex = index - 1;

        if (categoryIndex >= categories.length) return null;

        final category = categories[categoryIndex];
        final items = groupedItems[category]!;

        return _buildCategorySection(context, category, items);
      },
    );
  }

  Widget _buildRestaurantInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRestaurantImageSection(context),
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                children: [
                  _buildInfoChip(
                    context,
                    Icons.star,
                    restaurant.rating.toString(),
                    Colors.amber,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  _buildInfoChip(
                    context,
                    Icons.access_time,
                    '${restaurant.deliveryTime} min',
                    Colors.blue,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  _buildInfoChip(
                    context,
                    Icons.delivery_dining,
                    '₹${restaurant.deliveryFee.toStringAsFixed(0)}',
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantImageSection(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: restaurant.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[100],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[100],
              child: const Center(
                child: Icon(Icons.restaurant, size: 64, color: Colors.grey),
              ),
            ),
          ),
          // Restaurant logo overlay
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: restaurant
                      .imageUrl, // Using same image as placeholder for logo
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[50],
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[50],
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String category,
    List<MenuItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          child: Text(category, style: Theme.of(context).textTheme.titleLarge),
        ),
        ...items.map((item) => _MenuItemCard(menuItem: item)),
        const SizedBox(height: AppConstants.paddingMedium),
      ],
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;

  const _MenuItemCard({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      onTap: menuItem.isAvailable
          ? () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => MenuItemDetailSheet(menuItem: menuItem),
              );
            }
          : null,
      child: Opacity(
        opacity: menuItem.isAvailable ? 1.0 : 0.6,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            menuItem.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (menuItem.isVegetarian)
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
                      menuItem.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Row(
                      children: [
                        Text(
                          '₹${menuItem.price.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${menuItem.preparationTime} min',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (!menuItem.isAvailable) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Currently unavailable',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppConstants.containerBorderRadius,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: menuItem.imageUrl,
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
                  const SizedBox(height: AppConstants.paddingSmall),
                  if (menuItem.isAvailable)
                    _MenuItemCartControls(menuItem: menuItem),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemCartControls extends StatelessWidget {
  final MenuItem menuItem;

  const _MenuItemCartControls({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        if (cartState is CartLoaded) {
          final cartItem = cartState.items
              .where((item) => item.menuItem.id == menuItem.id)
              .firstOrNull;

          if (cartItem != null) {
            // Show quantity controls
            return Container(
              width: 80,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(
                  AppConstants.containerBorderRadius,
                ),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decrease button
                  InkWell(
                    onTap: () {
                      if (cartItem.quantity > 1) {
                        context.read<CartBloc>().add(
                          UpdateCartItem(
                            menuItemId: menuItem.id,
                            quantity: cartItem.quantity - 1,
                            specialInstructions: cartItem.specialInstructions,
                          ),
                        );
                      } else {
                        context.read<CartBloc>().add(
                          RemoveFromCart(menuItem.id),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(
                      AppConstants.containerBorderRadius,
                    ),
                    child: Container(
                      width: 24,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  // Quantity text
                  Expanded(
                    child: Text(
                      cartItem.quantity.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  // Increase button
                  InkWell(
                    onTap: () {
                      context.read<CartBloc>().add(
                        UpdateCartItem(
                          menuItemId: menuItem.id,
                          quantity: cartItem.quantity + 1,
                          specialInstructions: cartItem.specialInstructions,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(
                      AppConstants.containerBorderRadius,
                    ),
                    child: Container(
                      width: 24,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }

        // Show Add button
        return SizedBox(
          width: 80,
          height: 32,
          child: ElevatedButton(
            onPressed: () {
              context.read<CartBloc>().add(
                AddToCart(menuItem: menuItem, quantity: 1),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.containerBorderRadius,
                ),
              ),
              elevation: 0,
            ),
            child: Text(
              'Add',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  final CartLoaded cartState;

  const _CartBottomBar({required this.cartState});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      showShadow: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      borderRadius: 0,
      onTap: () {
        Navigator.pushNamed(context, '/cart');
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Cart icon with item count
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  if (cartState.totalItems > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          cartState.totalItems.toString(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onError,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppConstants.paddingMedium),

              // Cart details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${cartState.totalItems} ${cartState.totalItems == 1 ? 'item' : 'items'} in cart',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${cartState.subtotal.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // View cart button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(
                    AppConstants.containerBorderRadius,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Cart',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
