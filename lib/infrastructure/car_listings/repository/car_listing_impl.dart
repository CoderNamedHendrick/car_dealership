import 'package:car_dealership/infrastructure/core/commons.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/domain.dart';
import 'car_dealership_impl.dart';

final class CarListingImpl implements CarListingInterface {
  const CarListingImpl(this.ref);

  final Ref ref;

  @override
  Future<Either<DealershipException, CarReviewDto>> fetchCarListingReview(String carId) async {
    await pseudoFetchDelay();
    final review = ref.read(_reviewedCarListingsProvider);

    return Right(review.firstWhere((element) => element.carId == carId, orElse: () => CarReviewDto(carId: carId)));
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>> fetchPurchasedCarListings() async {
    await pseudoFetchDelay();

    return Right(ref.read(_purchasedCarsListingProvider));
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>> fetchReviewedCarListings() async {
    await pseudoFetchDelay();

    final carListing = CarDealerShipImpl.carListing;
    final reviewedCarListing = ref.read(_reviewedCarListingsProvider);

    final result = <CarListingDto>[];

    for (var reviewedCar in reviewedCarListing) {
      result.add(carListing.firstWhere((element) => element.id == reviewedCar.carId));
    }

    return Right(result);
  }

  @override
  Future<Either<DealershipException, List<SellerDto>>> fetchReviewedSellers() async {
    await pseudoFetchDelay();

    final sellers = CarDealerShipImpl.sellers;
    final reviewSellers = ref.read(_reviewedSellersProvider);

    final result = <SellerDto>[];

    for (var reviewedSeller in reviewSellers) {
      result.add(sellers.firstWhere((element) => element.id == reviewedSeller.sellerId));
    }

    return Right(result);
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>> fetchSavedCarListings() async {
    await pseudoFetchDelay();

    return Right(ref.read(_savedCarsListingProvider));
  }

  @override
  Future<Either<DealershipException, SellerReviewDto>> fetchSellerReview(String sellerId) async {
    await pseudoFetchDelay();
    final reviews = ref.read(_reviewedSellersProvider);

    return Right(reviews.firstWhere((element) => element.sellerId == sellerId,
        orElse: () => SellerReviewDto(sellerId: sellerId)));
  }

  @override
  Future<Either<DealershipException, String>> reviewCarListing(CarReviewDto dto) async {
    await pseudoFetchDelay();

    ref.read(_reviewedCarListingsProvider.notifier).update((state) => state..add(dto));

    return const Right('successful');
  }

  @override
  Future<Either<DealershipException, String>> reviewSeller(SellerReviewDto dto) async {
    await pseudoFetchDelay();

    ref.read(_reviewedSellersProvider.notifier).update((state) => state..add(dto));

    return const Right('successful');
  }

  @override
  Future<Either<DealershipException, String>> saveCarListing(String carId) async {
    await pseudoFetchDelay();

    final carListing = CarDealerShipImpl.carListing.firstWhere((element) => element.id == carId);
    ref.read(_savedCarsListingProvider.notifier).update((state) => state..add(carListing));

    return const Right('successful');
  }

  @override
  Future<Either<DealershipException, String>> purchaseListing(String carId) async {
    await pseudoFetchDelay();

    final carListing = CarDealerShipImpl.carListing.firstWhere((element) => element.id == carId);
    ref.read(_purchasedCarsListingProvider.notifier).update((state) => state..add(carListing));

    return const Right('successful');
  }
}

// local storage with riverpod
final _reviewedCarListingsProvider = StateProvider<List<CarReviewDto>>((ref) {
  return const [];
});

final _reviewedSellersProvider = StateProvider<List<SellerReviewDto>>((ref) {
  return const [];
});

final _purchasedCarsListingProvider = StateProvider<List<CarListingDto>>((ref) {
  return const [];
});
final _savedCarsListingProvider = StateProvider<List<CarListingDto>>((ref) {
  return const [];
});
