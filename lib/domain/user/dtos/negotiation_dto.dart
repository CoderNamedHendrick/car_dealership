import 'dart:io';

final class NegotiationDto {
  final String id;
  final String userId;
  final String sellerId;
  final String carId;
  final double price;
  final List<ChatDto> chats;

  const NegotiationDto({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.price,
    required this.carId,
    this.chats = const [],
  });

  NegotiationDto copyWith(
      {String? id, String? userId, String? sellerId, String? carId, double? price, List<ChatDto>? chats}) {
    return NegotiationDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sellerId: sellerId ?? this.sellerId,
      price: price ?? this.price,
      carId: carId ?? this.carId,
    );
  }
}

final class ChatDto {
  final bool isUser;
  final String message;
  final File? imageFile;

  const ChatDto({required this.isUser, required this.message, this.imageFile});
}
