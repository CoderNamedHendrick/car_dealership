// coverage:ignore-file
import 'package:car_dealership/infrastructure/user/user_dto_x.dart';

import '../../core/repositories.dart';

import '../../core/commons.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../../domain/domain.dart';

final class ChatRepositoryImpl implements ChatRepositoryInterface {
  const ChatRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<Either<DealershipException, NegotiationDto>> createNegotiationChat(NegotiationDto dto) async {
    await pseudoFetchDelay();

    ref.read(_chatsStoreProvider.notifier).update((state) => state..add(dto));

    return Right(ref.read(_chatsStoreProvider).firstWhere(
        (element) => element.carId == dto.carId && element.sellerId == dto.sellerId && element.userId == dto.userId));
  }

  @override
  Future<Either<DealershipException, List<NegotiationDto>>> fetchChats() async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final user?:
        final chats = ref.read(_chatsStoreProvider).where((element) => element.userId == user.user.id).toList();
        return Right(chats);
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, NegotiationDto>> fetchNegotiationChat(String sellerId, String carId) async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final user?:
        final negotiation = ref.read(_chatsStoreProvider).firstWhere(
            (element) => element.carId == carId && element.sellerId == sellerId && element.userId == user.user.id);

        return Right(negotiation);
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, bool>> negotiationAvailable(String sellerId, String carId) async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final user?:
        final negotiation = ref.read(_chatsStoreProvider).firstWhereOrNull(
            (element) => element.carId == carId && element.sellerId == sellerId && element.userId == user.user.id);

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
  Future<Either<DealershipException, NegotiationDto>> sendChat(String negotiationId, ChatDto dto) async {
    await pseudoFetchDelay();

    var negotiation = ref.read(_chatsStoreProvider).firstWhere((element) => element.id == negotiationId);

    negotiation = negotiation.copyWith(chats: [...negotiation.chats, dto]);
    ref.read(_chatsStoreProvider.notifier).update((state) => state
      ..removeWhere((element) => element.id == negotiation.id)
      ..add(negotiation));

    return Right(ref.read(_chatsStoreProvider).firstWhere((element) => element.id == negotiationId));
  }

  @override
  Future<Either<DealershipException, NegotiationDto>> updateNegotiationPrice(
      String negotiationId, double newPrice) async {
    await pseudoFetchDelay();

    var negotiation = ref.read(_chatsStoreProvider).firstWhere((element) => element.id == negotiationId);

    negotiation = negotiation.copyWith(price: newPrice);

    ref.read(_chatsStoreProvider.notifier).update((state) => state
      ..removeWhere((element) => element.id == negotiation.id)
      ..add(negotiation));
    return Right(ref.read(_chatsStoreProvider).firstWhere((element) => element.id == negotiationId));
  }
}

final _chatsStoreProvider = StateProvider<List<NegotiationDto>>((ref) {
  return [];
});
