import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/messages/message_home_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  group('Messages view model test suite', () {
    late SignalListener<MessageHomeUiState> listener;
    late ChatRepositoryInterface mockChatRepository;
    late CarDealerShipInterface mockCarDealershipRepository;

    setUpAll(() => registerFallbackValue(const MessageHomeUiState.initial()));

    setUp(() {
      setupTestLocator();
      mockChatRepository = locator();
      mockCarDealershipRepository = locator();
      listener = SignalListener();
    });

    tearDown(() async => await GetIt.I.reset());

    test('fetch chats success test', () async {
      when(() => mockChatRepository.fetchChats()).thenAnswer(
          (_) => Future.value(const Right([NegotiationDto.empty()])));

      final messagesVM = locator<MessagesViewModel>();

      var emitter = messagesVM.emitter.onSignalUpdate(listener.call);

      final currState = messagesVM.state;

      await messagesVM.fetchChats();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>().having((p0) => p0.currentState,
                    'current state should be loading', ViewState.loading))),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>()
                    .having((p0) => p0.currentState,
                        'current state should be success', ViewState.success)
                    .having((p0) => p0.chats.isNotEmpty,
                        'checking chats returned', true))),
      ]);

      // dispose
      emitter();
    });

    testWidgets('fetch chats failure test', (tester) async {
      when(() => mockChatRepository.fetchChats()).thenAnswer((_) =>
          Future.value(
              const Left(MessageException('failed to fetch messages'))));
      final messagesVM = locator<MessagesViewModel>();

      var emitter = messagesVM.emitter.onSignalUpdate(listener.call);

      final currState = messagesVM.state;

      await tester.pumpWidget(const UnitTestApp());
      await messagesVM.fetchChats();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>().having((p0) => p0.currentState,
                    'current state should be loading', ViewState.loading))),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>()
                    .having((p0) => p0.currentState,
                        'current state should be error', ViewState.error)
                    .having((p0) => p0.error, 'checking error returned',
                        isA<MessageException>()))),
      ]);

      // dispose
      emitter();
    });

    test('fetch all listings success test', () async {
      when(() => mockCarDealershipRepository.fetchListing(null)).thenAnswer(
          (_) => Future.value(const Right([CarListingDto.empty()])));
      final messagesVM = locator<MessagesViewModel>();

      var emitter = messagesVM.emitter.onSignalUpdate(listener.call);
      final currState = messagesVM.state;

      await messagesVM.fetchAllListing();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>().having(
                    (p0) => p0.listings.isNotEmpty,
                    'checking the list items if success',
                    true)))
      ]);

      // dispose
      emitter();
    });

    test('fetch all listings failure test', () async {
      when(() => mockCarDealershipRepository.fetchListing(null)).thenAnswer(
          (_) => Future.value(const Left(MessageException('failure'))));

      final messagesVM = locator<MessagesViewModel>();

      var emitter = messagesVM.emitter.onSignalUpdate(listener.call);
      final currState = messagesVM.state;

      await messagesVM.fetchAllListing();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
      ]);

      // dispose
      emitter();
    });
  });
}
