import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/profile/profile_ui_state.dart';
import 'package:signals/signals_flutter.dart';

import '../../domain/domain.dart';

final class ProfileViewModel extends DealershipViewModel {
  final AuthRepositoryInterface _authRepository;
  final CarListingInterface _listingRepository;

  ProfileViewModel(this._authRepository, this._listingRepository);

  final _profileState = signal(const ProfileUiState.initial());
  final _wishlistState = signal(const WishlistUiState.initial());

  ReadonlySignal<ProfileUiState> get profileEmitter =>
      _profileState.toReadonlySignal();

  ReadonlySignal<WishlistUiState> get wishlistEmitter =>
      _wishlistState.toReadonlySignal();

  ProfileUiState get profileState => _profileState.toReadonlySignal().value;

  WishlistUiState get wishlistState => _wishlistState.toReadonlySignal().value;

  Future<void> fetchUser() async {
    _profileState.value =
        profileState.copyWith(currentState: ViewState.loading);
    final result = await _authRepository.fetchUser();

    _profileState.value = result.fold(
      (left) =>
          profileState.copyWith(error: left, currentState: ViewState.error),
      (right) =>
          profileState.copyWith(currentState: ViewState.success, user: right),
    );
  }

  Future<void> logout() async {
    await launch(profileState.ref, (model) async {
      _profileState.value =
          model.emit(profileState.copyWith(currentState: ViewState.loading));
      final result = await _authRepository.logout();

      _profileState.value = result.fold(
        (left) => model.emit(
            profileState.copyWith(currentState: ViewState.error, error: left)),
        (right) => const ProfileUiState.initial(),
      );
    });
  }

  Future<void> fetchWishlist() async {
    await launch(wishlistState.ref, (model) async {
      _wishlistState.value =
          model.emit(wishlistState.copyWith(currentState: ViewState.loading));
      final result = await _listingRepository.fetchSavedCarListings();

      _wishlistState.value = result.fold(
        (left) => model.emit(
            wishlistState.copyWith(currentState: ViewState.error, error: left)),
        (right) => model.emit(wishlistState.copyWith(
            currentState: ViewState.success, savedCars: right)),
      );
    });
  }

  @override
  void dispose() {
    var fn = effect(() => _profileState.value);
    fn();
    fn = effect(() => _wishlistState.value);
    fn();
  }
}
