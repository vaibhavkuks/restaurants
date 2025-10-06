import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/menu_data_source.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuDataSource dataSource;

  MenuBloc({required this.dataSource}) : super(const MenuInitial()) {
    on<LoadMenuItems>(_onLoadMenuItems);
    on<RefreshMenuItems>(_onRefreshMenuItems);
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    emit(const MenuLoading());
    await _loadMenuItems(event.restaurantId, emit);
  }

  Future<void> _onRefreshMenuItems(
    RefreshMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    await _loadMenuItems(event.restaurantId, emit);
  }

  Future<void> _loadMenuItems(
    String restaurantId,
    Emitter<MenuState> emit,
  ) async {
    try {
      final menuItems = await dataSource.getMenuItems(restaurantId);
      emit(MenuLoaded(menuItems, restaurantId));
    } on NetworkException catch (e) {
      emit(MenuError(NetworkFailure(e.message)));
    } on ServerException catch (e) {
      emit(MenuError(ServerFailure(e.message)));
    } catch (e) {
      emit(
        MenuError(
          UnknownFailure('An unexpected error occurred: ${e.toString()}'),
        ),
      );
    }
  }
}
