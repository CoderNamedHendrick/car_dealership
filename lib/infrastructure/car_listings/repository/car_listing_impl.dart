// coverage:ignore-file
import 'package:car_dealership/infrastructure/core/commons.dart';
import 'package:car_dealership/infrastructure/core/repositories.dart';
import 'package:car_dealership/infrastructure/user/user_dto_x.dart';
import 'package:collection/collection.dart';
import 'package:either_dart/either.dart';
import '../../../domain/domain.dart';
import '../../core/user_table.dart';
import 'car_dealership_impl.dart';

final class CarListingImpl implements CarListingInterface {
  const CarListingImpl();

  @override
  Future<Either<DealershipException, CarReviewDto>> fetchCarListingReview(
      String carId) async {
    await pseudoFetchDelay();
    final review = reviewedCarListingsSignal.peek();

    return Right(review.firstWhere((element) => element.carId == carId,
        orElse: () => CarReviewDto(carId: carId)));
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>>
      fetchPurchasedCarListings() async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        final listing = purchasedCarsListingSignal
            .peek()
            //create a new purchase listing if it doesn't exist
            .firstWhere((element) => element.userId == user.user.id,
                orElse: () => PurchasedCarListingTable(
                    userId: user.user.id, carListing: []))
            .carListing;

        return Right(listing);

      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>>
      fetchReviewedCarListings() async {
    await pseudoFetchDelay();

    final carListing = CarDealerShipImpl.carListing;
    final reviewedCarListing = reviewedCarListingsSignal.peek();

    final result = <CarListingDto>[];

    for (var reviewedCar in reviewedCarListing) {
      result.add(
          carListing.firstWhere((element) => element.id == reviewedCar.carId));
    }

    return Right(result);
  }

  @override
  Future<Either<DealershipException, List<SellerDto>>>
      fetchReviewedSellers() async {
    await pseudoFetchDelay();

    final sellers = CarDealerShipImpl.sellers;
    final reviewSellers = reviewedSellersSignal.peek();

    final result = <SellerDto>[];

    for (var reviewedSeller in reviewSellers) {
      result.add(sellers
          .firstWhere((element) => element.id == reviewedSeller.sellerId));
    }

    return Right(result);
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>>
      fetchSavedCarListings() async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        final listing = savedCarsListingSignal
            .peek()
            .firstWhere((element) => element.userId == user.user.id,
                orElse: () =>
                    SavedCarsListingTable(userId: user.user.id, carListing: []))
            .carListing;

        return Right(listing);
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, SellerReviewDto>> fetchSellerReview(
      String sellerId) async {
    await pseudoFetchDelay();
    final reviews = reviewedSellersSignal.peek();

    return Right(reviews.firstWhere((element) => element.sellerId == sellerId,
        orElse: () => SellerReviewDto(sellerId: sellerId)));
  }

  @override
  Future<Either<DealershipException, String>> reviewCarListing(
      CarReviewDto dto) async {
    await pseudoFetchDelay();
    reviewedCarListingsSignal.value = reviewedCarListingsSignal.peek().toList()
      ..add(dto);

    return const Right('successful');
  }

  @override
  Future<Either<DealershipException, String>> reviewSeller(
      SellerReviewDto dto) async {
    await pseudoFetchDelay();

    reviewedSellersSignal.value = reviewedSellersSignal.peek().toList()
      ..add(dto);

    return const Right('successful');
  }

  @override
  Future<Either<DealershipException, String>> toggleSaveCarListing(
      String carId) async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        final carListing = CarDealerShipImpl.carListing
            .firstWhere((element) => element.id == carId);
        final savedCars = savedCarsListingSignal.peek().firstWhere(
            (element) => element.userId == user.user.id,
            orElse: () =>
                SavedCarsListingTable(userId: user.user.id, carListing: []));

        final isVehicleSaved = savedCars.carListing
                .firstWhereOrNull((element) => element.id == carId) !=
            null;
        final listing = (savedCars.carListing).toList();

        isVehicleSaved ? listing.remove(carListing) : listing.add(carListing);

        savedCarsListingSignal.value = savedCarsListingSignal.peek().toList()
          ..removeWhere((element) => element.userId == savedCars.userId)
          ..add(savedCars.copyWith(carListing: listing));

        return const Right('successful');
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, String>> purchaseListing(
      String carId) async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        final carListing = CarDealerShipImpl.carListing
            .firstWhere((element) => element.id == carId)
            .copyWith(availability: Availability.sold);
        final purchaseDto = purchasedCarsListingSignal.peek().firstWhere(
            (element) => element.userId == user.user.id,
            orElse: () =>
                PurchasedCarListingTable(userId: user.user.id, carListing: []));

        purchasedCarsListingSignal.value = purchasedCarsListingSignal
            .peek()
            .toList()
          ..removeWhere((element) => element.userId == purchaseDto.userId)
          ..add(purchaseDto.copyWith(
              carListing: purchaseDto.carListing..add(carListing)));

        return const Right('successful');
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, bool>> fetchSavedByUser(
      String carId) async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        final listing = savedCarsListingSignal
            .peek()
            .firstWhere((element) => element.userId == user.user.id,
                orElse: () =>
                    SavedCarsListingTable(userId: user.user.id, carListing: []))
            .carListing;
        final isSavedByUser =
            (listing.firstWhereOrNull((dto) => dto.id == carId) != null);
        return Right(isSavedByUser);
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, String>> deleteListing(
      String carId) async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        if (user.user.isAdmin) {
          CarDealerShipImpl.carListing
              .removeWhere((element) => element.id == carId);
          return const Right('success');
        }

        return const Left(
            MessageException('You do not have access to this resource'));
      case _:
        return const Left(AuthRequiredException());
    }
  }

  @override
  Future<Either<DealershipException, String>> deleteSeller(
      String sellerId) async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final user?:
        if (user.user.isAdmin) {
          CarDealerShipImpl.sellers
              .removeWhere((element) => element.id == sellerId);
          CarDealerShipImpl.carListing
              .removeWhere((element) => element.sellerId == sellerId);

          return const Right('success');
        }

        return const Left(
            MessageException('You do not have access to this resource'));

      case _:
        return const Left(AuthRequiredException());
    }
  }
}
