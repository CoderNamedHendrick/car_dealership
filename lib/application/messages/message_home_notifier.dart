import 'package:car_dealership/application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import 'message_home_ui_state.dart';

class MessagesHomeStateNotifier extends StateNotifier<MessageHomeUiState> {
  final ChatRepositoryInterface _chatRepository;

  MessagesHomeStateNotifier(this._chatRepository) : super(const MessageHomeUiState.initial()) {
    fetchChats();
  }

  void fetchChats() async {
    state = state.copyWith(currentState: ViewState.loading);
    final result = await _chatRepository.fetchChats();

    state = result.fold(
      (left) => state.copyWith(currentState: ViewState.error, error: left),
      (right) => state.copyWith(currentState: ViewState.success, chats: right),
    );
  }
}

final messagesHomeStateNotifierProvider =
    StateNotifierProvider.autoDispose<MessagesHomeStateNotifier, MessageHomeUiState>((ref) {
  return MessagesHomeStateNotifier(ref.read(chatRepositoryProvider));
});
