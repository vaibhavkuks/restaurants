import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../cart/presentation/cart_bloc.dart';
import '../../cart/presentation/cart_event.dart';
import '../domain/menu_item.dart';

class MenuItemDetailSheet extends StatefulWidget {
  final MenuItem menuItem;

  const MenuItemDetailSheet({super.key, required this.menuItem});

  @override
  State<MenuItemDetailSheet> createState() => _MenuItemDetailSheetState();
}

class _MenuItemDetailSheetState extends State<MenuItemDetailSheet> {
  int quantity = 1;
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppConstants.borderRadiusLarge),
        topRight: Radius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.only(
          //topLeft: Radius.circular(AppConstants.borderRadiusLarge),
          //topRight: Radius.circular(AppConstants.borderRadiusLarge),
          //),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  CachedNetworkImage(
                    imageUrl: widget.menuItem.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant, size: 48),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and vegetarian indicator
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.menuItem.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                            ),
                            if (widget.menuItem.isVegetarian)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: AppConstants.paddingSmall),

                        // Price and preparation time
                        Row(
                          children: [
                            Text(
                              '₹${widget.menuItem.price.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: AppConstants.paddingMedium),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.menuItem.preparationTime} min',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),

                        const SizedBox(height: AppConstants.paddingMedium),

                        // Description
                        Text(
                          widget.menuItem.description,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey[700]),
                        ),

                        const SizedBox(height: AppConstants.paddingMedium),

                        // Ingredients
                        if (widget.menuItem.ingredients.isNotEmpty) ...[
                          Text(
                            'Ingredients',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),
                          Wrap(
                            spacing: AppConstants.paddingSmall,
                            runSpacing: AppConstants.paddingSmall,
                            children: widget.menuItem.ingredients
                                .map(
                                  (ingredient) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppConstants.paddingSmall,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadiusSmall,
                                      ),
                                    ),
                                    child: Text(
                                      ingredient,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                        ],

                        // Special instructions
                        Text(
                          'Special Instructions (Optional)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        TextField(
                          controller: _instructionsController,
                          decoration: const InputDecoration(
                            hintText: 'Any special requests?',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),

                        const SizedBox(height: AppConstants.paddingLarge),

                        // Quantity selector and add to cart
                        Row(
                          children: [
                            Text(
                              'Quantity',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(width: AppConstants.paddingMedium),
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
                                    onPressed: quantity > 1
                                        ? () {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppConstants.paddingMedium,
                                    ),
                                    child: Text(
                                      quantity.toString(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '₹${(widget.menuItem.price * quantity).toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppConstants.paddingLarge),

                        // Add to cart button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                AddToCart(
                                  menuItem: widget.menuItem,
                                  quantity: quantity,
                                  specialInstructions:
                                      _instructionsController.text.isEmpty
                                      ? null
                                      : _instructionsController.text,
                                ),
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${widget.menuItem.name} added to cart',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text('Add to Cart'),
                          ),
                        ),

                        // Bottom safe area
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
