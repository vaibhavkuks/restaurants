import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/custom_container.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_theme.dart';
import '../../cart/presentation/cart_state.dart';
import '../../cart/presentation/cart_bloc.dart';
import '../../cart/presentation/cart_event.dart';
import '../../orders/presentation/order_bloc.dart';
import '../../orders/presentation/order_event.dart';
import '../../orders/presentation/order_state.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart' as error_widget;

class CheckoutScreen extends StatefulWidget {
  final CartLoaded cartState;

  const CheckoutScreen({super.key, required this.cartState});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController(
    text: '123 Main Street, Apt 4B, New York, NY 10001',
  );
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        bottom: AppTheme.appBarBottomBorder(),
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            // Clear the cart after successful order
            context.read<CartBloc>().add(const ClearCart());

            // Navigate to order confirmation
            Navigator.pushReplacementNamed(
              context,
              '/order-confirmation',
              arguments: state.order,
            );
          }
        },
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            if (orderState is OrderPlacing) {
              return const LoadingWidget(message: 'Placing your order...');
            }

            if (orderState is OrderError) {
              return error_widget.ErrorWidget(
                failure: orderState.failure,
                onRetry: () {
                  // Retry placing the order
                  _placeOrder();
                },
              );
            }

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderSummary(),
                          const SizedBox(height: AppConstants.paddingLarge),
                          _buildDeliverySection(),
                          const SizedBox(height: AppConstants.paddingLarge),
                          _buildPaymentSection(),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return CustomContainer(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppConstants.paddingMedium),
          ...widget.cartState.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.menuItem.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '₹${item.totalPrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          _buildSummaryRow('Subtotal', widget.cartState.subtotal),
          _buildSummaryRow('Delivery Fee', widget.cartState.deliveryFee),
          _buildSummaryRow('Service Fee', widget.cartState.serviceFee),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${widget.cartState.total.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection() {
    return CustomContainer(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Delivery Address',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your delivery address';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Estimated delivery: ${AppConstants.estimatedDeliveryTime} minutes',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          TextFormField(
            controller: _instructionsController,
            decoration: const InputDecoration(
              labelText: 'Delivery Instructions (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
              hintText: 'e.g., Ring doorbell, Leave at door',
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return CustomContainer(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Credit/Debit Card'),
            subtitle: const Text('**** **** **** 1234'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // In a real app, this would open payment method selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Payment method selection not implemented in demo',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
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
                Text(
                  'Total',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${widget.cartState.total.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _placeOrder,
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      // Get the restaurant info from the first item (assuming all items are from same restaurant)
      final firstItem = widget.cartState.items.first;
      final restaurantId = firstItem.menuItem.restaurantId;

      // In a real app, you'd get the restaurant name from the restaurant service
      const restaurantName = 'Restaurant'; // Placeholder

      context.read<OrderBloc>().add(
        PlaceOrder(
          restaurantId: restaurantId,
          restaurantName: restaurantName,
          items: widget.cartState.items,
          subtotal: widget.cartState.subtotal,
          deliveryFee: widget.cartState.deliveryFee,
          serviceFee: widget.cartState.serviceFee,
          total: widget.cartState.total,
          deliveryAddress: _addressController.text.trim(),
          specialInstructions: _instructionsController.text.trim().isEmpty
              ? null
              : _instructionsController.text.trim(),
        ),
      );
    }
  }
}
