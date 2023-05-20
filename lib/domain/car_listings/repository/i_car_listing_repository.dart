import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/infrastructure.dart';
import '../../core/core.dart';
import '../car_listing_domain.dart';

abstract interface class CarListingInterface {
  Future<Either<DealershipException, String>> reviewCarListing(CarReviewDto dto);

  Future<Either<DealershipException, String>> reviewSeller(SellerReviewDto dto);

  Future<Either<DealershipException, String>> toggleSaveCarListing(String carId);

  Future<Either<DealershipException, String>> purchaseListing(String carId);

  Future<Either<DealershipException, List<CarListingDto>>> fetchReviewedCarListings();

  Future<Either<DealershipException, List<SellerDto>>> fetchReviewedSellers();

  Future<Either<DealershipException, List<CarListingDto>>> fetchSavedCarListings();

  Future<Either<DealershipException, List<CarListingDto>>> fetchPurchasedCarListings();

  Future<Either<DealershipException, SellerReviewDto>> fetchSellerReview(String sellerId);

  Future<Either<DealershipException, CarReviewDto>> fetchCarListingReview(String carId);

  Future<Either<DealershipException, bool>> fetchSavedByUser(String carId);
}

final carListingProvider = Provider.autoDispose<CarListingInterface>((ref) {
  return CarListingImpl(ref);
});
