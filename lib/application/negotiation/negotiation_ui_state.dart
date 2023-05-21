import '../../domain/domain.dart';
import '../core/view_model.dart';

final class NegotiationUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final NegotiationDto currentNegotiation;
  final CarListingDto currentListing;
  final ChatMessage currentChat;
  final bool isSendingMessage;
  final bool showFormErrors;

  const NegotiationUiState({
    required this.currentState,
    required this.error,
    required this.currentNegotiation,
    required this.currentListing,
    required this.currentChat,
    required this.isSendingMessage,
    required this.showFormErrors,
  });

  NegotiationUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          currentNegotiation: const NegotiationDto.empty(),
          currentListing: const CarListingDto.empty(),
          currentChat: ChatMessage(''),
          isSendingMessage: false,
          showFormErrors: false,
        );

  NegotiationUiState copyWith({
    ViewState? currentState,
    DealershipException? error,
    NegotiationDto? currentNegotiation,
    CarListingDto? currentListing,
    ChatMessage? currentChat,
    bool? isSendingMessage,
    bool? showFormErrors,
  }) {
    return NegotiationUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      currentNegotiation: currentNegotiation ?? this.currentNegotiation,
      currentListing: currentListing ?? this.currentListing,
      currentChat: currentChat ?? this.currentChat,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      showFormErrors: showFormErrors ?? this.showFormErrors,
    );
  }

  @override
  List<Object?> get props => [
        currentState,
        error,
        currentNegotiation,
        currentListing,
        currentChat,
        isSendingMessage,
        showFormErrors,
      ];
}
