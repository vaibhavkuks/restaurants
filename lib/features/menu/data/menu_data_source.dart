import '../domain/menu_item.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/utils/extensions.dart';

abstract class MenuDataSource {
  Future<List<MenuItem>> getMenuItems(String restaurantId);
  Future<MenuItem> getMenuItemById(String id);
}

class MockMenuDataSource implements MenuDataSource {
  final Map<String, List<MenuItem>> _menuItems = {
    '1': [
      // Pizza Palace
      const MenuItem(
        id: 'p1',
        restaurantId: '1',
        name: 'Margherita Pizza',
        description: 'Classic tomato sauce, mozzarella, and fresh basil',
        price: 1249,
        imageUrl:
            'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500',
        category: 'Pizza',
        isVegetarian: true,
        isAvailable: true,
        ingredients: ['Tomato sauce', 'Mozzarella', 'Fresh basil', 'Olive oil'],
        preparationTime: 15,
      ),
      const MenuItem(
        id: 'p2',
        restaurantId: '1',
        name: 'Pepperoni Pizza',
        description: 'Classic pepperoni with mozzarella cheese',
        price: 1399,
        imageUrl:
            'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=500',
        category: 'Pizza',
        isVegetarian: false,
        isAvailable: true,
        ingredients: ['Tomato sauce', 'Mozzarella', 'Pepperoni'],
        preparationTime: 18,
      ),
      const MenuItem(
        id: 'p3',
        restaurantId: '1',
        name: 'Caesar Salad',
        description: 'Crisp romaine lettuce with Caesar dressing',
        price: 899,
        imageUrl:
            'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=500',
        category: 'Salads',
        isVegetarian: true,
        isAvailable: true,
        ingredients: [
          'Romaine lettuce',
          'Caesar dressing',
          'Croutons',
          'Parmesan',
        ],
        preparationTime: 8,
      ),
      const MenuItem(
        id: 'p4',
        restaurantId: '1',
        name: 'Tiramisu',
        description: 'Classic Italian dessert with coffee and mascarpone',
        price: 699,
        imageUrl:
            'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=500',
        category: 'Desserts',
        isVegetarian: true,
        isAvailable: true,
        ingredients: [
          'Ladyfingers',
          'Mascarpone cheese',
          'Coffee',
          'Cocoa powder',
          'Sugar',
        ],
        preparationTime: 5,
      ),
      const MenuItem(
        id: 'p5',
        restaurantId: '1',
        name: 'Garlic Bread',
        description: 'Toasted bread with garlic butter and herbs',
        price: 499,
        imageUrl:
            'https://images.unsplash.com/photo-1617191511973-4c8e2f3b8f4c?w=500',
        category: 'Appetizers',
        isVegetarian: true,
        isAvailable: true,
        ingredients: ['Bread', 'Garlic', 'Butter', 'Parsley'],
        preparationTime: 7,
      ),
    ],
    '2': [
      // Burger Barn
      const MenuItem(
        id: 'b1',
        restaurantId: '2',
        name: 'Classic Cheeseburger',
        description: 'Beef patty with cheese, lettuce, tomato, and pickles',
        price: 1099,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
        category: 'Burgers',
        isVegetarian: false,
        isAvailable: true,
        ingredients: [
          'Beef patty',
          'Cheese',
          'Lettuce',
          'Tomato',
          'Pickles',
          'Bun',
        ],
        preparationTime: 12,
      ),
      const MenuItem(
        id: 'b2',
        restaurantId: '2',
        name: 'Crispy Chicken Burger',
        description: 'Crispy fried chicken with mayo and lettuce',
        price: 1199,
        imageUrl:
            'https://images.unsplash.com/photo-1606755962773-d324e608eecb?w=500',
        category: 'Burgers',
        isVegetarian: false,
        isAvailable: true,
        ingredients: ['Fried chicken', 'Mayo', 'Lettuce', 'Bun'],
        preparationTime: 15,
      ),
      const MenuItem(
        id: 'b3',
        restaurantId: '2',
        name: 'Sweet Potato Fries',
        description: 'Crispy sweet potato fries with sea salt',
        price: 599,
        imageUrl:
            'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=500',
        category: 'Sides',
        isVegetarian: true,
        isAvailable: true,
        ingredients: ['Sweet potato', 'Sea salt', 'Oil'],
        preparationTime: 10,
      ),
    ],
    '3': [
      // Sushi Zen
      const MenuItem(
        id: 's1',
        restaurantId: '3',
        name: 'Salmon Roll',
        description: 'Fresh salmon with cucumber and avocado',
        price: 749,
        imageUrl:
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=500',
        category: 'Sushi',
        isVegetarian: false,
        isAvailable: true,
        ingredients: ['Salmon', 'Cucumber', 'Avocado', 'Rice', 'Nori'],
        preparationTime: 10,
      ),
      const MenuItem(
        id: 's2',
        restaurantId: '3',
        name: 'Vegetable Tempura',
        description: 'Lightly battered and fried seasonal vegetables',
        price: 999,
        imageUrl:
            'https://images.unsplash.com/photo-1609501676725-7186f3d37e07?w=500',
        category: 'Appetizers',
        isVegetarian: true,
        isAvailable: true,
        ingredients: ['Mixed vegetables', 'Tempura batter', 'Dipping sauce'],
        preparationTime: 8,
      ),
    ],
    '4': [
      // Taco Fiesta
      const MenuItem(
        id: 't1',
        restaurantId: '4',
        name: 'Beef Tacos',
        description: 'Seasoned ground beef with fresh toppings',
        price: 329,
        imageUrl:
            'https://images.unsplash.com/photo-1565299585323-38174c4a6471?w=500',
        category: 'Tacos',
        isVegetarian: false,
        isAvailable: true,
        ingredients: [
          'Ground beef',
          'Lettuce',
          'Tomato',
          'Cheese',
          'Sour cream',
        ],
        preparationTime: 6,
      ),
      const MenuItem(
        id: 't2',
        restaurantId: '4',
        name: 'Chicken Burrito',
        description: 'Grilled chicken with rice, beans, and salsa',
        price: 849,
        imageUrl:
            'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=500',
        category: 'Burritos',
        isVegetarian: false,
        isAvailable: true,
        ingredients: [
          'Grilled chicken',
          'Rice',
          'Black beans',
          'Salsa',
          'Cheese',
        ],
        preparationTime: 10,
      ),
    ],
    '5': [
      // Green Garden
      const MenuItem(
        id: 'g1',
        restaurantId: '5',
        name: 'Mediterranean Bowl',
        description: 'Quinoa with fresh vegetables and tahini dressing',
        price: 1099,
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500',
        category: 'Bowls',
        isVegetarian: true,
        isAvailable: true,
        ingredients: ['Quinoa', 'Cucumber', 'Tomato', 'Olives', 'Tahini'],
        preparationTime: 8,
      ),
      const MenuItem(
        id: 'g2',
        restaurantId: '5',
        name: 'Green Smoothie',
        description: 'Spinach, banana, apple, and protein powder',
        price: 649,
        imageUrl:
            'https://images.unsplash.com/photo-1638176066666-ffb2f013c7dd?w=500',
        category: 'Beverages',
        isVegetarian: true,
        isAvailable: true,
        ingredients: [
          'Spinach',
          'Banana',
          'Apple',
          'Protein powder',
          'Almond milk',
        ],
        preparationTime: 3,
      ),
    ],
  };

  @override
  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Simulate occasional network failure
    if (DateTime.now().millisecond % 25 == 0) {
      throw const NetworkException('Failed to fetch menu items');
    }

    return _menuItems[restaurantId] ?? [];
  }

  @override
  Future<MenuItem> getMenuItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    for (final menuList in _menuItems.values) {
      final item = menuList.where((item) => item.id == id).firstOrNull;
      if (item != null) {
        return item;
      }
    }

    throw const ServerException('Menu item not found');
  }
}
