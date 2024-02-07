import 'package:car_dealership/application/admin/admin_ui_state.dart';
import 'package:car_dealership/application/application.dart';
import 'package:signals/signals_flutter.dart';

final class AdminActionsViewModel {
  final CarListingInterface _carListingRepository;

  AdminActionsViewModel(this._carListingRepository);

  final _state = signal(const AdminUiState.initial());

  ReadonlySignal<AdminUiState> get emitter => _state;

  AdminUiState get state => _state.value;

  Future<void> deleteListing(String carId) async {
    await launch(state.ref, (model) async {
      _state.value =
          model.emit(state.copyWith(currentState: ViewState.loading));
      final result = await _carListingRepository.deleteListing(carId);

      _state.value = model.emit(result.fold(
        (left) => state.copyWith(currentState: ViewState.error, error: left),
        (right) => state.copyWith(currentState: ViewState.success),
      ));
    });

    _state.value = state.copyWith(
        currentState: ViewState.idle, error: const EmptyException());
  }

  Future<void> deleteSeller(String sellerId) async {
    await launch(state.ref, (model) async {
      _state.value =
          model.emit(state.copyWith(currentState: ViewState.loading));
      final result = await _carListingRepository.deleteSeller(sellerId);

      _state.value = model.emit(result.fold(
        (left) => state.copyWith(currentState: ViewState.error, error: left),
        (right) => state.copyWith(currentState: ViewState.success),
      ));
    });

    _state.value = state.copyWith(
        currentState: ViewState.idle, error: const EmptyException());
  }
}
