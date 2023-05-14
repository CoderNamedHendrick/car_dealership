import 'package:car_dealership/infrastructure/car_listings/repository/car_dealership_impl.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/dealership_exception.dart';
import '../dtos/car_listing.dart';
import '../dtos/filter.dart';
import '../dtos/sellers.dart';

abstract interface class CarDealerShipInterface {
  const CarDealerShipInterface();

  Future<Either<DealershipException, List<String>>> fetchBrands();

  Future<Either<DealershipException, List<CarListingDto>>> fetchListing(FilterQuery? query);

  Future<Either<DealershipException, List<SellerDto>>> fetchSellers();
}

// serves as a service locator for the car dealer repository
final carDealershipProvider = Provider.autoDispose<CarDealerShipInterface>((ref) {
  return const CarDealerShipImpl();
});
