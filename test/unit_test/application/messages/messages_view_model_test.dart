import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/messages/message_home_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  final mockChatRepository = MockChatRepo();
  final mockCarDealershipRepository = MockCarDealerShipRepo();

  group('Messages view model test suite', () {
    late ProviderContainer container;
    late RiverpodListener<MessageHomeUiState> listener;

    setUpAll(() => registerFallbackValue(const MessageHomeUiState.initial()));

    setUp(() {
      container = ProviderContainer(overrides: [
        chatRepositoryProvider.overrideWithValue(mockChatRepository),
        carDealershipProvider.overrideWithValue(mockCarDealershipRepository)
      ]);
      listener = RiverpodListener();
    });

    tearDown(() => container.dispose());

    test('fetch chats success test', () async {
      when(() => mockChatRepository.fetchChats())
          .thenAnswer((_) => Future.value(const Right([NegotiationDto.empty()])));

      container.listen(messagesHomeStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(messagesHomeStateNotifierProvider);

      await container.read(messagesHomeStateNotifierProvider.notifier).fetchChats();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>()
                    .having((p0) => p0.currentState, 'current state should be loading', ViewState.loading))),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>()
                    .having((p0) => p0.currentState, 'current state should be success', ViewState.success)
                    .having((p0) => p0.chats.isNotEmpty, 'checking chats returned', true))),
      ]);
    });

    testWidgets('fetch chats failure test', (tester) async {
      when(() => mockChatRepository.fetchChats())
          .thenAnswer((_) => Future.value(const Left(MessageException('failed to fetch messages'))));

      container.listen(messagesHomeStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(messagesHomeStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(messagesHomeStateNotifierProvider.notifier).fetchChats();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>()
                    .having((p0) => p0.currentState, 'current state should be loading', ViewState.loading))),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>()
                    .having((p0) => p0.currentState, 'current state should be error', ViewState.error)
                    .having((p0) => p0.error, 'checking error returned', isA<MessageException>()))),
      ]);
    });

    test('fetch all listings success test', () async {
      when(() => mockCarDealershipRepository.fetchListing(null))
          .thenAnswer((_) => Future.value(const Right([CarListingDto.empty()])));

      container.listen(messagesHomeStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(messagesHomeStateNotifierProvider);

      await container.read(messagesHomeStateNotifierProvider.notifier).fetchAllListing();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>()
                    .having((p0) => p0.listings.isNotEmpty, 'checking the list items if success', true)))
      ]);
    });

    test('fetch all listings failure test', () async {
      when(() => mockCarDealershipRepository.fetchListing(null))
          .thenAnswer((_) => Future.value(const Left(MessageException('failure'))));

      container.listen(messagesHomeStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(messagesHomeStateNotifierProvider);

      await container.read(messagesHomeStateNotifierProvider.notifier).fetchAllListing();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<MessageHomeUiState>()),
            any(
                that: isA<MessageHomeUiState>()
                    .having((p0) => p0.listings.isNotEmpty, 'checking the list items if failure', false)))
      ]);
    });
  });
}
