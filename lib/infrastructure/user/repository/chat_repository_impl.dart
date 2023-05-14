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
  Future<Either<DealershipException, NegotiationDto>> fetchNegotiationChat(
      String userId, String sellerId, String carId) async {
    await pseudoFetchDelay();

    final negotiation = ref
        .read(_chatsStoreProvider)
        .firstWhere((element) => element.carId == carId && element.sellerId == sellerId && element.userId == userId);

    return Right(negotiation);
  }

  @override
  Future<Either<DealershipException, bool>> negotiationAvailable(String userId, String sellerId, String carId) async {
    await pseudoFetchDelay();

    final negotiation = ref.read(_chatsStoreProvider).firstWhereOrNull(
        (element) => element.carId == carId && element.sellerId == sellerId && element.userId == userId);

    final result = switch (negotiation) {
      final _? => true,
      null => false,
    };

    return Right(result);
  }

  @override
  Future<Either<DealershipException, NegotiationDto>> sendChat(String negotiationId, ChatDto dto) async {
    await pseudoFetchDelay();

    var negotiation = ref.read(_chatsStoreProvider).firstWhere((element) => element.id == negotiationId);

    negotiation = negotiation.copyWith(chats: negotiation.chats..add(dto));
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
  return const [];
});
