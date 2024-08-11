import 'package:car_dealership/application/admin/admin_ui_state.dart';
import 'package:car_dealership/application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminActionsStateNotifier extends StateNotifier<AdminUiState> {
  final CarListingInterface _carListingRepository;

  AdminActionsStateNotifier(this._carListingRepository) : super(const AdminUiState.initial());

  Future<void> deleteListing(String carId) async {
    await launch(state.reference, (model) async {
      state = model.emit(state.copyWith(currentState: UiState.loading));
      final result = await _carListingRepository.deleteListing(carId);

      state = model.emit(result.fold(
        (left) => state.copyWith(currentState: UiState.error, error: left),
        (right) => state.copyWith(currentState: UiState.success),
      ));
    });

    state = state.copyWith(currentState: UiState.idle, error: const EmptyException());
  }

  Future<void> deleteSeller(String sellerId) async {
    await launch(state.reference, (model) async {
      state = model.emit(state.copyWith(currentState: UiState.loading));
      final result = await _carListingRepository.deleteSeller(sellerId);

      state = model.emit(result.fold(
        (left) => state.copyWith(currentState: UiState.error, error: left),
        (right) => state.copyWith(currentState: UiState.success),
      ));
    });

    state = state.copyWith(currentState: UiState.idle, error: const EmptyException());
  }
}

final adminActionsStateNotifierProvider =
    StateNotifierProvider.autoDispose<AdminActionsStateNotifier, AdminUiState>((ref) {
  return AdminActionsStateNotifier(ref.read(carListingProvider));
});
