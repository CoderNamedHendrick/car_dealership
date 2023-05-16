import 'package:car_dealership/application/application.dart';
import '../../domain/domain.dart';

final class MessageHomeUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<NegotiationDto> chats;

  const MessageHomeUiState({required this.currentState, required this.error, required this.chats});

  const MessageHomeUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          chats: const [],
        );

  MessageHomeUiState copyWith({ViewState? currentState, DealershipException? error, List<NegotiationDto>? chats}) {
    return MessageHomeUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      chats: chats ?? this.chats,
    );
  }

  @override
  List<Object?> get props => [currentState, error, chats];
}
