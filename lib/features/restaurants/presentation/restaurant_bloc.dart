import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/restaurant_data_source.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantDataSource dataSource;

  RestaurantBloc({required this.dataSource})
    : super(const RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<RefreshRestaurants>(_onRefreshRestaurants);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());
    await _loadRestaurants(emit);
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    await _loadRestaurants(emit);
  }

  Future<void> _loadRestaurants(Emitter<RestaurantState> emit) async {
    try {
      final restaurants = await dataSource.getRestaurants();
      emit(RestaurantLoaded(restaurants));
    } on NetworkException catch (e) {
      emit(RestaurantError(NetworkFailure(e.message)));
    } on ServerException catch (e) {
      emit(RestaurantError(ServerFailure(e.message)));
    } catch (e) {
      emit(
        RestaurantError(
          UnknownFailure('An unexpected error occurred: ${e.toString()}'),
        ),
      );
    }
  }
}
