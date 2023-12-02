import 'dart:io';

import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/negotiation/negotiation_ui_state.dart';
import 'package:signals/signals_flutter.dart';

import '../../domain/domain.dart';

final class NegotiationViewModel extends DealershipViewModel {
  final ChatRepositoryInterface _chatRepo;

  NegotiationViewModel(this._chatRepo);

  final _state = signal(NegotiationUiState.initial());

  ReadonlySignal<NegotiationUiState> get emitter => _state.toReadonlySignal();

  NegotiationUiState get state => _state.toReadonlySignal().value;

  Future<void> initialiseChat(CarListingDto listingDto, UserDto user,
      bool existingNegotiationAvailable) async {
    await launch(state.ref, (model) async {
      _state.value = model.emit(state.copyWith(
          currentState: ViewState.loading, currentListing: listingDto));
      final result = existingNegotiationAvailable
          ? await _chatRepo.fetchNegotiationChat(
              listingDto.sellerId, listingDto.id)
          : await _chatRepo.createNegotiationChat(
              NegotiationDto(
                id: '${user.id}-${listingDto.sellerId}-${listingDto.id}',
                userId: user.id,
                sellerId: listingDto.sellerId,
                carId: listingDto.id,
                price: listingDto.price.toDouble(),
              ),
            );

      _state.value = result.fold(
        (left) => model
            .emit(state.copyWith(currentState: ViewState.error, error: left)),
        (right) => model.emit(state.copyWith(
            currentState: ViewState.success, currentNegotiation: right)),
      );
    });

    _state.value = state.copyWith(currentState: ViewState.idle);
  }

  Future<void> sendChat() async {
    if (state.currentChat.failureOrNone.isNone()) {
      await launch(state.ref, (model) async {
        _state.value = model.emit(state.copyWith(isSendingMessage: true));
        final result = await _chatRepo.sendChat(state.currentNegotiation.id,
            state.currentChat.getOrCrash().toDto());

        _state.value = model.emit(state.copyWith(isSendingMessage: false));
        _state.value = result.fold(
          (left) => model
              .emit(state.copyWith(currentState: ViewState.error, error: left)),
          (right) => model.emit(state.copyWith(
              currentNegotiation: right,
              currentState: ViewState.success,
              currentChat: ChatMessage(''))),
        );
      });

      _state.value = state.copyWith(currentState: ViewState.idle);
      return;
    }

    _state.value = state.copyWith(showFormErrors: true);
  }

  Future<void> updateNegotiationPrice(double newPrice) async {
    await launch(state.ref, (model) async {
      _state.value =
          model.emit(state.copyWith(currentState: ViewState.loading));
      final result = await _chatRepo.updateNegotiationPrice(
          state.currentNegotiation.id, newPrice);

      _state.value = result.fold(
        (left) => model
            .emit(state.copyWith(currentState: ViewState.error, error: left)),
        (right) => model.emit(state.copyWith(
            currentState: ViewState.success, currentNegotiation: right)),
      );
    });

    _state.value = state.copyWith(currentState: ViewState.idle);
  }

  void messageOnChanged(String input) {
    _state.value = state.copyWith(
      currentChat: ChatMessage(
          input,
          state.currentChat.value.fold(
              (left) => left.value.imageFile, (right) => right.imageFile)),
    );
  }

  void fileOnChanged(File input) {
    _state.value = state.copyWith(
      currentChat: ChatMessage(
          state.currentChat.value
              .fold((left) => left.value.message, (right) => right.message),
          input),
    );
  }

  @override
  void dispose() {
    var fn = effect(() => _state.value);
    fn();
  }
}
