import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/infrastructure.dart';
import '../../core/core.dart';
import '../car_listing_domain.dart';

abstract interface class CarDealerShipInterface {
  const CarDealerShipInterface();

  Future<Either<DealershipException, List<String>>> fetchBrands();

  Future<Either<DealershipException, List<String>>> fetchPopularColors();

  Future<Either<DealershipException, List<CarListingDto>>> fetchListing(FilterQueryDto? query);

  Future<Either<DealershipException, int>> fetchAdsCount(FilterQueryDto? query);

  Future<Either<DealershipException, List<SellerDto>>> fetchSellers();

  Future<Either<DealershipException, List<String>>> fetchLocations();
}

// serves as a service locator for the car dealer repository
final carDealershipProvider = Provider.autoDispose<CarDealerShipInterface>((ref) {
  return const CarDealerShipImpl();
});
