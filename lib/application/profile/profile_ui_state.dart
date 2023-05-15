import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/domain/domain.dart';

final class ProfileUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final UserDto? user;

  const ProfileUiState({required this.currentState, required this.error, required this.user});

  const ProfileUiState.initial() : this(currentState: ViewState.idle, error: const EmptyException(), user: null);

  ProfileUiState copyWith({ViewState? currentState, DealershipException? error, UserDto? user}) {
    return ProfileUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [currentState, error, user];
}
