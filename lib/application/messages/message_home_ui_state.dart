import 'package:car_dealership/application/application.dart';
import '../../domain/domain.dart';

final class MessageHomeUiState extends DealershipUiStateModel<MessageHomeUiState> {


  final List<NegotiationDto> chats;
  final List<CarListingDto> listings;

  const MessageHomeUiState({
   super.uiState,
    super.error,
    required this.chats,
    required this.listings,
  });

  const MessageHomeUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          chats: const [],
          listings: const [],
        );

  @override
  MessageHomeUiState copyWith({
    UiState? uiState,
    DealershipException? error,
    List<NegotiationDto>? chats,
    List<CarListingDto>? listings,
  }) {
    return MessageHomeUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      chats: chats ?? this.chats,
      listings: listings ?? this.listings,
    );
  }

  @override
  List<Object?> get props => [uiState, error, chats, listings];
}
