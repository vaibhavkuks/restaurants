import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/custom_container.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_theme.dart';
import '../domain/order.dart';
import '../presentation/order_bloc.dart';
import '../presentation/order_event.dart';
import '../presentation/order_state.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final Order order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    // Start polling for order status updates
    _startStatusUpdates();
  }

  void _startStatusUpdates() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && widget.order.status != OrderStatus.delivered) {
        context.read<OrderBloc>().add(RefreshOrderStatus(widget.order.id));
        _startStatusUpdates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        automaticallyImplyLeading: false,
        bottom: AppTheme.appBarBottomBorder(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoaded) {
            // Update the order status if it has changed
            if (state.order.status != widget.order.status) {
              setState(() {
                // The order object is immutable, so we need to handle this in the UI
              });
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            children: [
              _buildSuccessHeader(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildOrderInfo(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildOrderStatus(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildOrderItems(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildDeliveryInfo(),
              const SizedBox(height: AppConstants.paddingXLarge),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return CustomContainer(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'Order Placed Successfully!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Thank you for your order. We\'ll prepare it with care!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    return CustomContainer(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildInfoRow(
            'Order ID',
            widget.order.id.substring(0, 8).toUpperCase(),
          ),
          _buildInfoRow('Restaurant', widget.order.restaurantName),
          _buildInfoRow('Order Time', _formatDateTime(widget.order.createdAt)),
          _buildInfoRow(
            'Total Amount',
            '₹${widget.order.total.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.containerBorderRadius),
        boxShadow: const [AppConstants.containerShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Status', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.paddingMedium),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                OrderStatus currentStatus = widget.order.status;
                if (state is OrderLoaded) {
                  currentStatus = state.order.status;
                }

                return _buildStatusTimeline(currentStatus);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(OrderStatus currentStatus) {
    final statuses = [
      OrderStatus.placed,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    final currentIndex = statuses.indexOf(currentStatus);

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusTitle(status),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isCompleted ? Colors.green : Colors.grey[600],
                    ),
                  ),
                  if (isCurrent && status != OrderStatus.delivered) ...[
                    const SizedBox(height: 4),
                    Text(
                      _getStatusDescription(status),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOrderItems() {
    return CustomContainer(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items (${widget.order.items.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          ...widget.order.items.map(
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
                '₹${widget.order.total.toStringAsFixed(0)}',
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

  Widget _buildDeliveryInfo() {
    return CustomContainer(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: Text(
                  widget.order.deliveryAddress,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Estimated delivery: ${widget.order.estimatedDeliveryTime} minutes',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (widget.order.specialInstructions != null) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.note, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: Text(
                    'Special instructions: ${widget.order.specialInstructions}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Continue Shopping'),
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // In a real app, this would show order tracking
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Order tracking feature not implemented in demo',
                  ),
                ),
              );
            },
            child: const Text('Track Order'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getStatusTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Your Order';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'We received your order and will confirm it shortly';
      case OrderStatus.confirmed:
        return 'Restaurant confirmed your order and started preparing';
      case OrderStatus.preparing:
        return 'Your delicious meal is being prepared with care';
      case OrderStatus.outForDelivery:
        return 'Your order is on the way to you';
      case OrderStatus.delivered:
        return 'Enjoy your meal!';
      case OrderStatus.cancelled:
        return 'Order was cancelled';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
