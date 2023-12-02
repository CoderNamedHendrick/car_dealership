import 'package:either_dart/either.dart';
import '../../core/core.dart';
import '../car_listing_domain.dart';

abstract interface class CarDealerShipInterface {
  const CarDealerShipInterface();

  Future<Either<DealershipException, List<String>>> fetchBrands();

  Future<Either<DealershipException, List<String>>> fetchPopularColors();

  Future<Either<DealershipException, List<CarListingDto>>> fetchListing(
      FilterQueryDto? query);

  Future<Either<DealershipException, int>> fetchAdsCount(FilterQueryDto? query);

  Future<Either<DealershipException, List<SellerDto>>> fetchSellers();

  Future<Either<DealershipException, List<String>>> fetchLocations();
}
