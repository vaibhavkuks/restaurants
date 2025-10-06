import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// A reusable custom container widget with consistent styling throughout the app.
///
/// This widget provides a unified design system with consistent border radius,
/// shadow, and theming for all containers in the application.
class CustomContainer extends StatelessWidget {
  /// The child widget to be displayed inside the container
  final Widget child;

  /// Optional margin around the container
  final EdgeInsets? margin;

  /// Optional padding inside the container
  final EdgeInsets? padding;

  /// Optional width constraint
  final double? width;

  /// Optional height constraint
  final double? height;

  /// Optional background color override (defaults to theme surface color)
  final Color? backgroundColor;

  /// Optional border radius override (defaults to AppConstants.containerBorderRadius)
  final double? borderRadius;

  /// Whether to show shadow (defaults to true)
  final bool showShadow;

  /// Optional onTap callback to make the container tappable
  final VoidCallback? onTap;

  /// Optional border radius for InkWell ripple effect
  final BorderRadius? inkWellBorderRadius;

  const CustomContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.showShadow = true,
    this.onTap,
    this.inkWellBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? AppConstants.containerBorderRadius;
    final effectiveInkWellBorderRadius =
        inkWellBorderRadius ?? BorderRadius.circular(effectiveBorderRadius);

    Widget containerChild = child;

    // Add padding if specified
    if (padding != null) {
      containerChild = Padding(padding: padding!, child: containerChild);
    }

    // Add InkWell if onTap is provided
    if (onTap != null) {
      containerChild = InkWell(
        borderRadius: effectiveInkWellBorderRadius,
        onTap: onTap,
        child: containerChild,
      );
    }

    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        boxShadow: showShadow ? const [AppConstants.containerShadow] : null,
      ),
      child: containerChild,
    );
  }
}

/// A specialized version of CustomContainer for card-like items with default padding
class CustomCard extends StatelessWidget {
  /// The child widget to be displayed inside the card
  final Widget child;

  /// Optional margin around the card (defaults to bottom margin only)
  final EdgeInsets? margin;

  /// Optional padding inside the card (defaults to medium padding)
  final EdgeInsets? padding;

  /// Optional onTap callback to make the card tappable
  final VoidCallback? onTap;

  /// Optional background color override
  final Color? backgroundColor;

  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin:
          margin ?? const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: padding ?? const EdgeInsets.all(AppConstants.paddingMedium),
      backgroundColor: backgroundColor,
      onTap: onTap,
      child: child,
    );
  }
}
