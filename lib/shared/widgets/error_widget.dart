import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';

class ErrorWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const ErrorWidget({super.key, required this.failure, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForFailure(failure),
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              _getTitleForFailure(failure),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              failure.message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForFailure(Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkFailure):
        return Icons.wifi_off;
      case const (ServerFailure):
        return Icons.error_outline;
      case const (CacheFailure):
        return Icons.storage;
      case const (ValidationFailure):
        return Icons.warning;
      default:
        return Icons.error_outline;
    }
  }

  String _getTitleForFailure(Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkFailure):
        return 'Connection Error';
      case const (ServerFailure):
        return 'Server Error';
      case const (CacheFailure):
        return 'Storage Error';
      case const (ValidationFailure):
        return 'Validation Error';
      default:
        return 'Something Went Wrong';
    }
  }
}
