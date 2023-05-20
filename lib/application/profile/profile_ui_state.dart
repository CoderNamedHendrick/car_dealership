import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/domain/domain.dart';

final class ProfileUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final UserDto? user;
  final WishlistUiState wishlistUiState;

  const ProfileUiState({
    required this.currentState,
    required this.error,
    required this.user,
    required this.wishlistUiState,
  });

  const ProfileUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          user: null,
          wishlistUiState: const WishlistUiState.initial(),
        );

  ProfileUiState copyWith({
    ViewState? currentState,
    DealershipException? error,
    UserDto? user,
    WishlistUiState? wishlistUiState,
  }) {
    return ProfileUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      user: user ?? this.user,
      wishlistUiState: wishlistUiState ?? this.wishlistUiState,
    );
  }

  @override
  List<Object?> get props => [currentState, error, user, wishlistUiState];
}

final class WishlistUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<CarListingDto> savedCars;

  const WishlistUiState({required this.currentState, required this.error, required this.savedCars});

  const WishlistUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          savedCars: const [],
        );

  WishlistUiState copyWith({ViewState? currentState, DealershipException? error, List<CarListingDto>? savedCars}) {
    return WishlistUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      savedCars: savedCars ?? this.savedCars,
    );
  }

  @override
  List<Object?> get props => [currentState, error, savedCars];
}
