import '../domain/restaurant.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/utils/extensions.dart';
import 'dart:math' as math;

abstract class RestaurantDataSource {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurantById(String id);
}

class MockRestaurantDataSource implements RestaurantDataSource {
  final List<Restaurant> _restaurants = [
    const Restaurant(
      id: '1',
      name: 'Pizza Palace',
      description: 'Authentic Italian pizzas made with fresh ingredients',
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500',
      rating: 4.5,
      deliveryTime: 25,
      deliveryFee: 199,
      categories: ['Italian', 'Pizza', 'Fast Food'],
      isOpen: true,
      address: '123 Main Street, Downtown',
    ),
    const Restaurant(
      id: '2',
      name: 'Burger Barn',
      description: 'Juicy gourmet burgers and crispy fries',
      imageUrl:
          'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500',
      rating: 4.2,
      deliveryTime: 20,
      deliveryFee: 149,
      categories: ['American', 'Burgers', 'Fast Food'],
      isOpen: true,
      address: '456 Oak Avenue, Midtown',
    ),
    const Restaurant(
      id: '3',
      name: 'Sushi Zen',
      description: 'Fresh sushi and traditional Japanese cuisine',
      imageUrl:
          'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=500',
      rating: 4.8,
      deliveryTime: 35,
      deliveryFee: 299,
      categories: ['Japanese', 'Sushi', 'Asian'],
      isOpen: true,
      address: '789 Cherry Blossom Lane, Uptown',
    ),
    const Restaurant(
      id: '4',
      name: 'Taco Fiesta',
      description: 'Authentic Mexican tacos and burritos',
      imageUrl:
          'https://images.unsplash.com/photo-1565299585323-38174c4a6471?w=500',
      rating: 4.3,
      deliveryTime: 18,
      deliveryFee: 129,
      categories: ['Mexican', 'Tacos', 'Spicy'],
      isOpen: true,
      address: '321 Spice Street, Little Mexico',
    ),
    const Restaurant(
      id: '5',
      name: 'Green Garden',
      description: 'Healthy salads and organic vegetarian meals',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500',
      rating: 4.6,
      deliveryTime: 22,
      deliveryFee: 179,
      categories: ['Healthy', 'Vegetarian', 'Salads'],
      isOpen: false,
      address: '654 Organic Way, Green District',
    ),
  ];

  @override
  Future<List<Restaurant>> getRestaurants() async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulate network delay

    // Simulate occasional network failure
    if (math.Random().nextInt(10) % 3 == 0) {
      throw const NetworkException('Failed to fetch restaurants');
    }

    return _restaurants;
  }

  @override
  Future<Restaurant> getRestaurantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final restaurant = _restaurants.where((r) => r.id == id).firstOrNull;
    if (restaurant == null) {
      throw const ServerException('Restaurant not found');
    }

    return Future.error('Simulated error');
    // return restaurant; --- IGNORE ---
  }
}
