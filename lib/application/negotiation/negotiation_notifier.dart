import 'dart:io';
import '../application.dart';
import 'negotiation_ui_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';

class NegotiationStateNotifier extends StateNotifier<NegotiationUiState> {
  final ChatRepositoryInterface _chatRepo;

  NegotiationStateNotifier(this._chatRepo) : super(NegotiationUiState.initial());

  Future<void> initialiseChat(CarListingDto listingDto, UserDto user, bool existingNegotiationAvailable) async {
    await launch(state.reference, (model) async {
      state = model.emit(state.copyWith(currentState: UiState.loading, currentListing: listingDto));
      final result = existingNegotiationAvailable
          ? await _chatRepo.fetchNegotiationChat(listingDto.sellerId, listingDto.id)
          : await _chatRepo.createNegotiationChat(
              NegotiationDto(
                id: '${user.id}-${listingDto.sellerId}-${listingDto.id}',
                userId: user.id,
                sellerId: listingDto.sellerId,
                carId: listingDto.id,
                price: listingDto.price.toDouble(),
              ),
            );

      state = result.fold(
        (left) => model.emit(state.copyWith(currentState: UiState.error, error: left)),
        (right) => model.emit(state.copyWith(currentState: UiState.success, currentNegotiation: right)),
      );
    });

    state = state.copyWith(currentState: UiState.idle);
  }

  Future<void> sendChat() async {
    if (state.currentChat.failureOrNone.isNone()) {
      await launch(state.reference, (model) async {
        state = model.emit(state.copyWith(isSendingMessage: true));
        final result = await _chatRepo.sendChat(state.currentNegotiation.id, state.currentChat.getOrCrash().toDto());

        state = model.emit(state.copyWith(isSendingMessage: false));
        state = result.fold(
          (left) => model.emit(state.copyWith(currentState: UiState.error, error: left)),
          (right) => model.emit(
              state.copyWith(currentNegotiation: right, currentState: UiState.success, currentChat: ChatMessage(''))),
        );
      });

      state = state.copyWith(currentState: UiState.idle);
      return;
    }

    state = state.copyWith(showFormErrors: true);
  }

  Future<void> updateNegotiationPrice(double newPrice) async {
    await launch(state.reference, (model) async {
      state = model.emit(state.copyWith(currentState: UiState.loading));
      final result = await _chatRepo.updateNegotiationPrice(state.currentNegotiation.id, newPrice);

      state = result.fold(
        (left) => model.emit(state.copyWith(currentState: UiState.error, error: left)),
        (right) => model.emit(state.copyWith(currentState: UiState.success, currentNegotiation: right)),
      );
    });

    state = state.copyWith(currentState: UiState.idle);
  }

  void messageOnChanged(String input) {
    state = state.copyWith(
      currentChat:
          ChatMessage(input, state.currentChat.value.fold((left) => left.value.imageFile, (right) => right.imageFile)),
    );
  }

  void fileOnChanged(File input) {
    state = state.copyWith(
      currentChat:
          ChatMessage(state.currentChat.value.fold((left) => left.value.message, (right) => right.message), input),
    );
  }
}

final negotiationStateNotifierProvider =
    StateNotifierProvider.autoDispose<NegotiationStateNotifier, NegotiationUiState>((ref) {
  return NegotiationStateNotifier(ref.read(chatRepositoryProvider));
});
