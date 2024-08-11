import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/domain/domain.dart';

final class ProfileUiState extends DealershipUiStateModel<ProfileUiState> {
  final UserDto? user;
  final WishlistUiState wishlistUiState;

  const ProfileUiState({
    super.uiState,
    super.error,
    required this.user,
    required this.wishlistUiState,
  });

  const ProfileUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          user: null,
          wishlistUiState: const WishlistUiState.initial(),
        );

  @override
  ProfileUiState copyWith({
    UiState? uiState,
    DealershipException? error,
    UserDto? user,
    WishlistUiState? wishlistUiState,
  }) {
    return ProfileUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      user: user ?? this.user,
      wishlistUiState: wishlistUiState ?? this.wishlistUiState,
    );
  }

  @override
  List<Object?> get props => [uiState, error, user, wishlistUiState];
}

final class WishlistUiState extends DealershipUiStateModel<WishlistUiState> {
  final List<CarListingDto> savedCars;

  const WishlistUiState({
    super.uiState,
    super.error,
    required this.savedCars,
  });

  const WishlistUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          savedCars: const [],
        );

  @override
  WishlistUiState copyWith(
      {UiState? uiState,
      DealershipException? error,
      List<CarListingDto>? savedCars}) {
    return WishlistUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      savedCars: savedCars ?? this.savedCars,
    );
  }

  @override
  List<Object?> get props => [uiState, error, savedCars];
}
