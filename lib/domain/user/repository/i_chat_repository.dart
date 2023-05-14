import 'package:car_dealership/domain/core/dealership_exception.dart';
import 'package:car_dealership/infrastructure/user/repository/chat_repository_impl.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dtos/negotiation_dto.dart';

abstract interface class ChatRepositoryInterface {
  Future<Either<DealershipException, NegotiationDto>> createNegotiationChat(NegotiationDto dto);

  Future<Either<DealershipException, NegotiationDto>> fetchNegotiationChat(
      String userId, String sellerId, String carId);

  Future<Either<DealershipException, NegotiationDto>> sendChat(String negotiationId, ChatDto dto);

  Future<Either<DealershipException, NegotiationDto>> updateNegotiationPrice(String negotiationId, double newPrice);

  Future<Either<DealershipException, bool>> negotiationAvailable(String userId, String sellerId, String carId);
}

final chatRepositoryProvider = Provider.autoDispose<ChatRepositoryInterface>((ref) {
  return ChatRepositoryImpl(ref);
});
