// coverage:ignore-file
import 'package:car_dealership/infrastructure/user/user_dto_x.dart';
import 'package:signals/signals.dart';
import '../../core/repositories.dart';
import '../../core/commons.dart';
import 'package:either_dart/either.dart';
import 'package:collection/collection.dart';
import '../../../domain/domain.dart';

final class ChatRepositoryImpl implements ChatRepositoryInterface {
  const ChatRepositoryImpl();

  @override
  Future<Either<DealershipException, NegotiationDto>> createNegotiationChat(
      NegotiationDto dto) async {
    await pseudoFetchDelay();

    _chatsStoreSignal.value = _chatsStoreSignal.peek().toList()..add(dto);

    return Right(_chatsStoreSignal.peek().firstWhere((element) =>
        element.carId == dto.carId &&
        element.sellerId == dto.sellerId &&
        element.userId == dto.userId));
  }

  @override
  Future<Either<DealershipException, List<NegotiationDto>>> fetchChats() async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        final chats = _chatsStoreSignal
            .peek()
            .where((element) => element.userId == user.user.id)
            .toList();
        return Right(chats);
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, NegotiationDto>> fetchNegotiationChat(
      String sellerId, String carId) async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        final negotiation = _chatsStoreSignal.peek().firstWhere((element) =>
            element.carId == carId &&
            element.sellerId == sellerId &&
            element.userId == user.user.id);

        return Right(negotiation);
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, bool>> negotiationAvailable(
      String sellerId, String carId) async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        final negotiation = _chatsStoreSignal.peek().firstWhereOrNull(
            (element) =>
                element.carId == carId &&
                element.sellerId == sellerId &&
                element.userId == user.user.id);

        final result = switch (negotiation) {
          final _? => true,
          null => false,
        };

        return Right(result);
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, NegotiationDto>> sendChat(
      String negotiationId, ChatDto dto) async {
    await pseudoFetchDelay();

    var negotiation = _chatsStoreSignal
        .peek()
        .firstWhere((element) => element.id == negotiationId);

    negotiation = negotiation.copyWith(chats: [...negotiation.chats, dto]);

    _chatsStoreSignal.value = _chatsStoreSignal.peek().toList()
      ..removeWhere((element) => element.id == negotiation.id)
      ..add(negotiation);

    return Right(_chatsStoreSignal
        .peek()
        .firstWhere((element) => element.id == negotiationId));
  }

  @override
  Future<Either<DealershipException, NegotiationDto>> updateNegotiationPrice(
      String negotiationId, double newPrice) async {
    await pseudoFetchDelay();

    var negotiation = _chatsStoreSignal
        .peek()
        .firstWhere((element) => element.id == negotiationId);

    negotiation = negotiation.copyWith(price: newPrice);

    _chatsStoreSignal.value = _chatsStoreSignal.peek().toList()
      ..removeWhere((element) => element.id == negotiation.id)
      ..add(negotiation);

    return Right(_chatsStoreSignal
        .peek()
        .firstWhere((element) => element.id == negotiationId));
  }
}

final _chatsStoreSignal = listSignal<NegotiationDto>([]);
