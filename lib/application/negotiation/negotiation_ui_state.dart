import '../../domain/domain.dart';
import '../core/ui_state.dart';

final class NegotiationUiState extends DealershipUiStateModel<NegotiationUiState> {


  final NegotiationDto currentNegotiation;
  final CarListingDto currentListing;
  final ChatMessage currentChat;
  final bool isSendingMessage;
  final bool showFormErrors;

  const NegotiationUiState({
   super.uiState,
    super.error,
    required this.currentNegotiation,
    required this.currentListing,
    required this.currentChat,
    required this.isSendingMessage,
    required this.showFormErrors,
  });

  NegotiationUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          currentNegotiation: const NegotiationDto.empty(),
          currentListing: const CarListingDto.empty(),
          currentChat: ChatMessage(''),
          isSendingMessage: false,
          showFormErrors: false,
        );

  @override
  NegotiationUiState copyWith({
    UiState? uiState,
    DealershipException? error,
    NegotiationDto? currentNegotiation,
    CarListingDto? currentListing,
    ChatMessage? currentChat,
    bool? isSendingMessage,
    bool? showFormErrors,
  }) {
    return NegotiationUiState(
      uiState: uiState ?? this.uiState,
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
        uiState,
        error,
        currentNegotiation,
        currentListing,
        currentChat,
        isSendingMessage,
        showFormErrors,
      ];
}
