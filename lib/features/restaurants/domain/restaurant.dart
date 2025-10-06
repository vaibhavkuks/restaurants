import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final List<String> categories;
  final bool isOpen;
  final String address;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.categories,
    required this.isOpen,
    required this.address,
  });

  @override
  List<Object> get props => [
    id,
    name,
    description,
    imageUrl,
    rating,
    deliveryTime,
    deliveryFee,
    categories,
    isOpen,
    address,
  ];
}
