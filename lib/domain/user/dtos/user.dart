import '../../car_listings/dtos/car_listing.dart';
import '../../car_listings/dtos/review.dart';

final class UserDto {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<Review> carReviews;
  final List<Review> sellerReviews;
  final List<CarListingDto> purchasedCars;
  final List<CarListingDto> favouriteCars;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.carReviews = const [],
    this.sellerReviews = const [],
    this.purchasedCars = const [],
    this.favouriteCars = const [],
  });
}
