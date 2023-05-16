import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/infrastructure.dart';
import '../../core/core.dart';
import '../user_domain.dart';

abstract interface class ChatRepositoryInterface {
  Future<Either<DealershipException, NegotiationDto>> createNegotiationChat(NegotiationDto dto);

  Future<Either<DealershipException, List<NegotiationDto>>> fetchChats();

  Future<Either<DealershipException, NegotiationDto>> fetchNegotiationChat(String sellerId, String carId);

  Future<Either<DealershipException, NegotiationDto>> sendChat(String negotiationId, ChatDto dto);

  Future<Either<DealershipException, NegotiationDto>> updateNegotiationPrice(String negotiationId, double newPrice);

  Future<Either<DealershipException, bool>> negotiationAvailable(String sellerId, String carId);
}

final chatRepositoryProvider = Provider.autoDispose<ChatRepositoryInterface>((ref) {
  return ChatRepositoryImpl(ref);
});
