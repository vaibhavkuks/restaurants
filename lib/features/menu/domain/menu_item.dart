import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isVegetarian;
  final bool isAvailable;
  final List<String> ingredients;
  final int preparationTime;

  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isVegetarian,
    required this.isAvailable,
    required this.ingredients,
    required this.preparationTime,
  });

  @override
  List<Object> get props => [
    id,
    restaurantId,
    name,
    description,
    price,
    imageUrl,
    category,
    isVegetarian,
    isAvailable,
    ingredients,
    preparationTime,
  ];
}
