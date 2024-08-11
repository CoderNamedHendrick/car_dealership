import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/profile/profile_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileStateNotifier extends StateNotifier<ProfileUiState> {
  final AuthRepositoryInterface _authRepository;
  final CarListingInterface _listingRepository;

  ProfileStateNotifier(this._authRepository, this._listingRepository) : super(const ProfileUiState.initial());

  Future<void> fetchUser() async {
    state = state.copyWith(uiState: UiState.loading);
    final result = await _authRepository.fetchUser();

    state = result.fold(
      (left) => state.copyWith(error: left, uiState: UiState.error),
      (right) => state.copyWith(uiState: UiState.success, user: right),
    );
  }

  Future<void> logout() async {
    await launch(state.reference, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));
      final result = await _authRepository.logout();

      state = result.fold(
        (left) => model.emit(state.copyWith(uiState: UiState.error, error: left)),
        (right) => const ProfileUiState.initial(),
      );
    });
  }

  Future<void> fetchWishlist() async {
    await launch(state.wishlistUiState.reference, (model) async {
      state = state.copyWith(
        wishlistUiState: model.emit(state.wishlistUiState.copyWith(uiState: UiState.loading)),
      );
      final result = await _listingRepository.fetchSavedCarListings();

      state = state.copyWith(
        wishlistUiState: result.fold(
          (left) => model.emit(state.wishlistUiState.copyWith(uiState: UiState.error, error: left)),
          (right) => model.emit(state.wishlistUiState.copyWith(uiState: UiState.success, savedCars: right)),
        ),
      );
    });
  }
}

final profileStateNotifierProvider = StateNotifierProvider.autoDispose<ProfileStateNotifier, ProfileUiState>((ref) {
  return ProfileStateNotifier(ref.read(authRepositoryProvider), ref.read(carListingProvider));
});
