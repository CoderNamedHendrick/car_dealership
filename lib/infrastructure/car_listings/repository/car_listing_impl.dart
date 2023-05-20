import 'package:car_dealership/infrastructure/core/commons.dart';
import 'package:car_dealership/infrastructure/core/repositories.dart';
import 'package:car_dealership/infrastructure/user/user_dto_x.dart';
import 'package:collection/collection.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/domain.dart';
import '../../core/user_table.dart';
import 'car_dealership_impl.dart';

final class CarListingImpl implements CarListingInterface {
  const CarListingImpl(this.ref);

  final Ref ref;

  @override
  Future<Either<DealershipException, CarReviewDto>> fetchCarListingReview(String carId) async {
    await pseudoFetchDelay();
    final review = ref.read(reviewedCarListingsProvider);

    return Right(review.firstWhere((element) => element.carId == carId, orElse: () => CarReviewDto(carId: carId)));
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>> fetchPurchasedCarListings() async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final user?:
        final listing = ref
            .read(purchasedCarsListingProvider)
            //create a new purchase listing if it doesn't exist
            .firstWhere((element) => element.userId == user.user.id,
                orElse: () => PurchasedCarListingTable(userId: user.user.id, carListing: []))
            .carListing;

        return Right(listing);

      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>> fetchReviewedCarListings() async {
    await pseudoFetchDelay();

    final carListing = CarDealerShipImpl.carListing;
    final reviewedCarListing = ref.read(reviewedCarListingsProvider);

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
    final reviewSellers = ref.read(reviewedSellersProvider);

    final result = <SellerDto>[];

    for (var reviewedSeller in reviewSellers) {
      result.add(sellers.firstWhere((element) => element.id == reviewedSeller.sellerId));
    }

    return Right(result);
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>> fetchSavedCarListings() async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final user?:
        final listing = ref
            .read(savedCarsListingProvider)
            .firstWhere((element) => element.userId == user.user.id,
                orElse: () => SavedCarsListingTable(userId: user.user.id, carListing: []))
            .carListing;

        return Right(listing);
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, SellerReviewDto>> fetchSellerReview(String sellerId) async {
    await pseudoFetchDelay();
    final reviews = ref.read(reviewedSellersProvider);

    return Right(reviews.firstWhere((element) => element.sellerId == sellerId,
        orElse: () => SellerReviewDto(sellerId: sellerId)));
  }

  @override
  Future<Either<DealershipException, String>> reviewCarListing(CarReviewDto dto) async {
    await pseudoFetchDelay();

    ref.read(reviewedCarListingsProvider.notifier).update((state) => state..add(dto));

    return const Right('successful');
  }

  @override
  Future<Either<DealershipException, String>> reviewSeller(SellerReviewDto dto) async {
    await pseudoFetchDelay();

    ref.read(reviewedSellersProvider.notifier).update((state) => state..add(dto));

    return const Right('successful');
  }

  @override
  Future<Either<DealershipException, String>> toggleSaveCarListing(String carId) async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final user?:
        final carListing = CarDealerShipImpl.carListing.firstWhere((element) => element.id == carId);
        final savedCars = ref.read(savedCarsListingProvider).firstWhere((element) => element.userId == user.user.id,
            orElse: () => SavedCarsListingTable(userId: user.user.id, carListing: []));

        final isVehicleSaved = savedCars.carListing.firstWhereOrNull((element) => element.id == carId) != null;
        final listing = (savedCars.carListing).toList();

        isVehicleSaved ? listing.remove(carListing) : listing.add(carListing);

        ref.read(savedCarsListingProvider.notifier).update((state) => state
          ..removeWhere((element) => element.userId == savedCars.userId)
          ..add(savedCars.copyWith(carListing: listing)));

        return const Right('successful');
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, String>> purchaseListing(String carId) async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final user?:
        final carListing = CarDealerShipImpl.carListing.firstWhere((element) => element.id == carId);
        final purchaseDto = ref.read(purchasedCarsListingProvider).firstWhere(
            (element) => element.userId == user.user.id,
            orElse: () => PurchasedCarListingTable(userId: user.user.id, carListing: []));

        ref.read(purchasedCarsListingProvider.notifier).update((state) => state
          ..removeWhere((element) => element.userId == purchaseDto.userId)
          ..add(purchaseDto.copyWith(carListing: purchaseDto.carListing..add(carListing))));

        return const Right('successful');
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, bool>> fetchSavedByUser(String carId) async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final user?:
        final listing = ref
            .read(savedCarsListingProvider)
            .firstWhere((element) => element.userId == user.user.id,
                orElse: () => SavedCarsListingTable(userId: user.user.id, carListing: []))
            .carListing;
        final isSavedByUser = (listing.firstWhereOrNull((dto) => dto.id == carId) != null);
        return Right(isSavedByUser);
      case _:
        return const Left(AuthRequiredException());
    }
  }
}
