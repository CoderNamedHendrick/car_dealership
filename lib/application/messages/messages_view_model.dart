import 'package:car_dealership/application/application.dart';
import 'package:signals/signals_flutter.dart';
import 'message_home_ui_state.dart';

import '../../domain/domain.dart';

final class MessagesViewModel extends DealershipViewModel {
  final ChatRepositoryInterface _chatRepository;
  final CarDealerShipInterface _dealerShipRepository;

  MessagesViewModel(this._chatRepository, this._dealerShipRepository);

  final _state = signal(const MessageHomeUiState.initial());

  ReadonlySignal<MessageHomeUiState> get emitter => _state.toReadonlySignal();

  MessageHomeUiState get state => _state.toReadonlySignal().value;

  Future<void> fetchAllListing() async {
    final result = await _dealerShipRepository.fetchListing(null);

    _state.value = result.fold(
      (left) => state.copyWith(listings: []),
      (right) => state.copyWith(listings: right),
    );
  }

  Future<void> fetchChats() async {
    _state.value = state.copyWith(currentState: ViewState.loading);
    final result = await _chatRepository.fetchChats();

    _state.value = result.fold(
      (left) => state.copyWith(currentState: ViewState.error, error: left),
      (right) => state.copyWith(currentState: ViewState.success, chats: right),
    );
  }

  @override
  void dispose() {
    var fn = effect(() => _state.value);
    fn();
  }
}
