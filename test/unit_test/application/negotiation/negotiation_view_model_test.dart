import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/negotiation/negotiation_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  final mockChatRepository = MockChatRepo();
  const negotiation = NegotiationDto(
      id: 'test-id-test-seller-id-test-car-id',
      userId: 'test-id',
      sellerId: 'test-seller-id',
      price: 10000,
      carId: 'test-car-id');
  final listingDto = const CarListingDto.empty().copyWith(id: 'test-car-id', sellerId: 'test-seller-id', price: 10000);
  const testUser = UserDto(id: 'test-id', name: 'Testing Doe', email: 'testdoe@gmail.com', phone: '04924');
  const testChat = ChatDto(isUser: true, message: 'john doe');

  group('Negotiation view model test suite', () {
    late ProviderContainer container;
    late RiverpodListener<NegotiationUiState> listener;

    setUp(() => registerFallbackValue(NegotiationUiState.initial()));

    setUp(() {
      container = ProviderContainer(overrides: [chatRepositoryProvider.overrideWithValue(mockChatRepository)]);
      listener = RiverpodListener();
    });

    tearDown(() => container.dispose());

    test('initialise chat success test', () async {
      when(() => mockChatRepository.createNegotiationChat(negotiation))
          .thenAnswer((_) => Future.value(const Right(negotiation)));

      container.listen(negotiationStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(negotiationStateNotifierProvider);

      await container.read(negotiationStateNotifierProvider.notifier).initialiseChat(listingDto, testUser, false);

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading)
                    .having((p0) => p0.currentListing, 'ensure the current listing is updated', listingDto))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is success', ViewState.success)
                    .having((p0) => p0.currentNegotiation, 'ensure the current negotiation is correct', negotiation)))
      ]);
    });

    testWidgets('initialise chat failure test', (tester) async {
      when(() => mockChatRepository.fetchNegotiationChat(negotiation.sellerId, negotiation.carId))
          .thenAnswer((_) => Future.value(const Left(MessageException('error'))));

      container.listen(negotiationStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(negotiationStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(negotiationStateNotifierProvider.notifier).initialiseChat(listingDto, testUser, true);
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading)
                    .having((p0) => p0.currentListing, 'ensure the current listing is updated', listingDto))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is error', ViewState.error)
                    .having((p0) => p0.error, 'ensure error is filled', isA<MessageException>())))
      ]);
    });

    test('send chat success test', () async {
      when(() => mockChatRepository.sendChat(negotiation.id, testChat))
          .thenAnswer((_) => Future.value(Right(negotiation.copyWith(chats: [testChat]))));
      when(() => mockChatRepository.createNegotiationChat(negotiation))
          .thenAnswer((_) => Future.value(const Right(negotiation)));
      await container.read(negotiationStateNotifierProvider.notifier).initialiseChat(listingDto, testUser, false);

      container.listen(negotiationStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(negotiationStateNotifierProvider);

      container.read(negotiationStateNotifierProvider.notifier).messageOnChanged(testChat.message);
      await container.read(negotiationStateNotifierProvider.notifier).sendChat();

      verifyInOrder([
        () => listener(null, currState.copyWith()),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.isSendingMessage, 'request is been made, message sending state is true', true))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>().having(
                    (p0) => p0.isSendingMessage, 'request has been made, message sending state is false', false))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'view state updates to success', ViewState.success)
                    .having((p0) => p0.currentNegotiation.chats.isNotEmpty, 'ensure the chats list isn\'t empty', true)
                    .having((p0) => p0.currentChat.failureOrNone.isSome(),
                        'clear current chat so it goes to invalid state', true))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that:
                    isA<NegotiationUiState>().having((p0) => p0.currentState, 'current state is idle', ViewState.idle)))
      ]);
    });

    testWidgets('send chat failure test', (tester) async {
      when(() => mockChatRepository.sendChat(negotiation.id, testChat))
          .thenAnswer((_) => Future.value(const Left(MessageException('can\'t send message'))));
      when(() => mockChatRepository.createNegotiationChat(negotiation))
          .thenAnswer((_) => Future.value(const Right(negotiation)));
      await container.read(negotiationStateNotifierProvider.notifier).initialiseChat(listingDto, testUser, false);

      container.listen(negotiationStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(negotiationStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      container.read(negotiationStateNotifierProvider.notifier).messageOnChanged(testChat.message);
      await container.read(negotiationStateNotifierProvider.notifier).sendChat();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith()),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.isSendingMessage, 'request is been made, message sending state is true', true))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>().having(
                    (p0) => p0.isSendingMessage, 'request has been made, message sending state is false', false))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'view state updates to error', ViewState.error)
                    .having((p0) => p0.error, 'ensure error is filled', isA<MessageException>())
                    .having((p0) => p0.currentChat.failureOrNone.isNone(),
                        'current chat is still alive since it wasn\'t cleared so it goes to invalid state', true))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that:
                    isA<NegotiationUiState>().having((p0) => p0.currentState, 'current state is idle', ViewState.idle)))
      ]);
    });

    test('update negotiation price success test', () async {
      when(() => mockChatRepository.updateNegotiationPrice(negotiation.id, 20000))
          .thenAnswer((invocation) => Future.value(Right(negotiation.copyWith(price: 20000))));

      when(() => mockChatRepository.createNegotiationChat(negotiation))
          .thenAnswer((_) => Future.value(const Right(negotiation)));
      await container.read(negotiationStateNotifierProvider.notifier).initialiseChat(listingDto, testUser, false);

      container.listen(negotiationStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(negotiationStateNotifierProvider);

      await container.read(negotiationStateNotifierProvider.notifier).updateNegotiationPrice(20000);

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is success', ViewState.success)
                    .having((p0) => p0.currentNegotiation, 'ensure negotiation model is updated to new price',
                        negotiation.copyWith(price: 20000)))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is idle', ViewState.idle))),
      ]);
    });

    testWidgets('update negotiation price failure test', (tester) async {
      when(() => mockChatRepository.updateNegotiationPrice(negotiation.id, 20000))
          .thenAnswer((invocation) => Future.value(const Left(MessageException('error'))));
      when(() => mockChatRepository.createNegotiationChat(negotiation))
          .thenAnswer((_) => Future.value(const Right(negotiation)));
      await container.read(negotiationStateNotifierProvider.notifier).initialiseChat(listingDto, testUser, false);

      container.listen(negotiationStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(negotiationStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(negotiationStateNotifierProvider.notifier).updateNegotiationPrice(20000);
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is error', ViewState.error)
                    .having((p0) => p0.error, 'ensure error is filled', isA<MessageException>()))),
        () => listener(
            any(that: isA<NegotiationUiState>()),
            any(
                that: isA<NegotiationUiState>()
                    .having((p0) => p0.currentState, 'current state is idle', ViewState.idle))),
      ]);
    });
  });
}
