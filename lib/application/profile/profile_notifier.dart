import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/profile/profile_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileStateNotifier extends StateNotifier<ProfileUiState> {
  final AuthRepositoryInterface _authRepository;
  final CarListingInterface _listingRepository;

  ProfileStateNotifier(this._authRepository, this._listingRepository) : super(const ProfileUiState.initial()) {
    fetchUser();
  }

  void fetchUser() async {
    state = state.copyWith(currentState: ViewState.loading);
    final result = await _authRepository.fetchUser();

    state = result.fold(
      (left) => state.copyWith(error: left, currentState: ViewState.error),
      (right) => state.copyWith(currentState: ViewState.success, user: right),
    );
  }

  void logout() async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(currentState: ViewState.loading));
      final result = await _authRepository.logout();

      state = result.fold(
        (left) => model.emit(state.copyWith(currentState: ViewState.error, error: left)),
        (right) => const ProfileUiState.initial(),
      );
    });
  }

  void fetchWishlist() async {
    await launch(state.wishlistUiState.ref, (model) async {
      state = state.copyWith(
        wishlistUiState: model.emit(state.wishlistUiState.copyWith(currentState: ViewState.loading)),
      );
      final result = await _listingRepository.fetchSavedCarListings();

      state = state.copyWith(
        wishlistUiState: result.fold(
          (left) => model.emit(state.wishlistUiState.copyWith(currentState: ViewState.error, error: left)),
          (right) => model.emit(state.wishlistUiState.copyWith(currentState: ViewState.success, savedCars: right)),
        ),
      );
    });
  }
}

final profileStateNotifierProvider = StateNotifierProvider.autoDispose<ProfileStateNotifier, ProfileUiState>((ref) {
  return ProfileStateNotifier(ref.read(authRepositoryProvider), ref.read(carListingProvider));
});
