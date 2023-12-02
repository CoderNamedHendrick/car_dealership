import 'package:car_dealership/application/application.dart';
import '../../domain/domain.dart';

final class MessageHomeUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<NegotiationDto> chats;
  final List<CarListingDto> listings;

  const MessageHomeUiState({
    required this.currentState,
    required this.error,
    required this.chats,
    required this.listings,
  });

  const MessageHomeUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          chats: const [],
          listings: const [],
        );

  MessageHomeUiState copyWith({
    ViewState? currentState,
    DealershipException? error,
    List<NegotiationDto>? chats,
    List<CarListingDto>? listings,
  }) {
    return MessageHomeUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      chats: chats ?? this.chats,
      listings: listings ?? this.listings,
    );
  }

  @override
  List<Object?> get props => [currentState, error, chats, listings];
}
