import 'package:car_dealership/domain/car_listings/dtos/car_listing.dart';
import 'package:car_dealership/domain/car_listings/dtos/sellers.dart';
import 'package:car_dealership/domain/core/dealership_exception.dart';
import 'package:car_dealership/domain/car_listings/dtos/review.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/car_listings/repository/car_listing_impl.dart';

abstract interface class CarListingInterface {
  Future<Either<DealershipException, String>> reviewCarListing(CarReviewDto dto);

  Future<Either<DealershipException, String>> reviewSeller(SellerReviewDto dto);

  Future<Either<DealershipException, String>> saveCarListing(String carId);

  Future<Either<DealershipException, String>> purchaseListing(String carId);

  Future<Either<DealershipException, List<CarListingDto>>> fetchReviewedCarListings();

  Future<Either<DealershipException, List<SellerDto>>> fetchReviewedSellers();

  Future<Either<DealershipException, List<CarListingDto>>> fetchSavedCarListings();

  Future<Either<DealershipException, List<CarListingDto>>> fetchPurchasedCarListings();

  Future<Either<DealershipException, SellerReviewDto>> fetchSellerReview(String sellerId);

  Future<Either<DealershipException, CarReviewDto>> fetchCarListingReview(String carId);
}

final carListingProvider = Provider.autoDispose<CarListingInterface>((ref) {
  return CarListingImpl(ref);
});
