import 'package:car_dealership/domain/domain.dart';
import 'package:equatable/equatable.dart';

final class CheckoutConfigDto extends Equatable {
  final UserDto user;
  final CarListingDto carListing;
  final double? price;

  const CheckoutConfigDto({required this.user, required this.carListing, this.price});

  const CheckoutConfigDto.empty() : this(user: const UserDto.empty(), carListing: const CarListingDto.empty());

  @override
  List<Object?> get props => [user, carListing, price];
}
