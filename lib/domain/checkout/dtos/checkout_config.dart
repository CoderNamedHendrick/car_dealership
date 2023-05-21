import 'package:car_dealership/domain/domain.dart';

final class CheckoutConfigDto {
  final UserDto user;
  final CarListingDto carListing;
  final double? price;

  const CheckoutConfigDto({required this.user, required this.carListing, this.price});

  const CheckoutConfigDto.empty() : this(user: const UserDto.empty(), carListing: const CarListingDto.empty());
}
