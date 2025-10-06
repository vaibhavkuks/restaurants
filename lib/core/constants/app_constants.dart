import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const String primaryColor = '#FF6B35';
  static const String secondaryColor = '#004E89';
  static const String backgroundColor = '#F5F5F5';
  static const String surfaceColor = '#FFFFFF';
  static const String errorColor = '#E74C3C';
  static const String successColor = '#2ECC71';

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;

  // Animation Duration
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationLong = 500;

  // Text Sizes
  static const double textSizeSmall = 12.0;
  static const double textSizeMedium = 14.0;
  static const double textSizeLarge = 16.0;
  static const double textSizeXLarge = 18.0;
  static const double textSizeTitle = 20.0;
  static const double textSizeHeading = 24.0;

  // Delivery
  static const double deliveryFee = 2.50;
  static const double serviceFee = 1.00;
  static const int estimatedDeliveryTime = 30;

  // Custom Container Styling
  static const double containerBorderRadius = 16.0;
  static const double containerElevation = 4.0;
  static const BoxShadow containerShadow = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 2),
    blurRadius: 8,
    spreadRadius: 0,
  );
}
