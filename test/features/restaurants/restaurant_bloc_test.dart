import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurants/features/restaurants/data/restaurant_data_source.dart';
import 'package:restaurants/features/restaurants/domain/restaurant.dart';
import 'package:restaurants/features/restaurants/presentation/restaurant_bloc.dart';
import 'package:restaurants/features/restaurants/presentation/restaurant_event.dart';
import 'package:restaurants/features/restaurants/presentation/restaurant_state.dart';
import 'package:restaurants/core/error/exceptions.dart';
import 'package:restaurants/core/error/failures.dart';

class MockRestaurantDataSource extends Mock implements RestaurantDataSource {}

void main() {
  group('RestaurantBloc', () {
    late RestaurantBloc restaurantBloc;
    late MockRestaurantDataSource mockDataSource;

    const tRestaurants = [
      Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        deliveryTime: 30,
        deliveryFee: 2.99,
        categories: ['Italian', 'Pizza'],
        isOpen: true,
        address: '123 Test Street',
      ),
    ];

    setUp(() {
      mockDataSource = MockRestaurantDataSource();
      restaurantBloc = RestaurantBloc(dataSource: mockDataSource);
    });

    tearDown(() {
      restaurantBloc.close();
    });

    test('initial state is RestaurantInitial', () {
      expect(restaurantBloc.state, const RestaurantInitial());
    });

    group('LoadRestaurants', () {
      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantLoaded] when successful',
        build: () {
          when(
            () => mockDataSource.getRestaurants(),
          ).thenAnswer((_) async => tRestaurants);
          return restaurantBloc;
        },
        act: (bloc) => bloc.add(const LoadRestaurants()),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantLoaded(tRestaurants),
        ],
        verify: (_) {
          verify(() => mockDataSource.getRestaurants()).called(1);
        },
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantError] when NetworkException is thrown',
        build: () {
          when(
            () => mockDataSource.getRestaurants(),
          ).thenThrow(const NetworkException('Network error'));
          return restaurantBloc;
        },
        act: (bloc) => bloc.add(const LoadRestaurants()),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantError(NetworkFailure('Network error')),
        ],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantError] when ServerException is thrown',
        build: () {
          when(
            () => mockDataSource.getRestaurants(),
          ).thenThrow(const ServerException('Server error'));
          return restaurantBloc;
        },
        act: (bloc) => bloc.add(const LoadRestaurants()),
        expect: () => [
          const RestaurantLoading(),
          const RestaurantError(ServerFailure('Server error')),
        ],
      );

      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoading, RestaurantError] when unexpected exception is thrown',
        build: () {
          when(
            () => mockDataSource.getRestaurants(),
          ).thenThrow(Exception('Unexpected error'));
          return restaurantBloc;
        },
        act: (bloc) => bloc.add(const LoadRestaurants()),
        expect: () => [
          const RestaurantLoading(),
          predicate<RestaurantError>(
            (state) =>
                state.failure is UnknownFailure &&
                state.failure.message.contains('An unexpected error occurred'),
          ),
        ],
      );
    });

    group('RefreshRestaurants', () {
      blocTest<RestaurantBloc, RestaurantState>(
        'emits [RestaurantLoaded] when successful (no loading state)',
        build: () {
          when(
            () => mockDataSource.getRestaurants(),
          ).thenAnswer((_) async => tRestaurants);
          return restaurantBloc;
        },
        act: (bloc) => bloc.add(const RefreshRestaurants()),
        expect: () => [const RestaurantLoaded(tRestaurants)],
      );
    });
  });
}
