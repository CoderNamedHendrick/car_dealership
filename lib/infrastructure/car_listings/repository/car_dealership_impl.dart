// coverage:ignore-file
import 'dart:convert';
import 'package:car_dealership/infrastructure/core/commons.dart';
import '../../../utility/assets_extension.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/services.dart';
import '../../../domain/domain.dart';

final class CarDealerShipImpl implements CarDealerShipInterface {
  const CarDealerShipImpl();

  static List<CarListingDto>? _carListing;
  static List<SellerDto>? _sellers;

  static List<CarListingDto> get carListing => _carListing ?? [];

  static List<SellerDto> get sellers => _sellers ?? [];

  @override
  Future<Either<DealershipException, List<String>>> fetchBrands() async {
    await pseudoFetchDelay();
    final listing = (await _getCarListing()).toList();

    return Right(listing.map((e) => e.make).toSet().toList());
  }

  @override
  Future<Either<DealershipException, List<String>>> fetchPopularColors() async {
    await pseudoFetchDelay();
    final listing = (await _getCarListing()).toList();

    return Right(listing.map((e) => e.color.toLowerCase()).toSet().toList());
  }

  @override
  Future<Either<DealershipException, List<String>>> fetchLocations() async {
    await pseudoFetchDelay();
    final listing = (await _getCarListing()).toList();

    return Right(listing.map((e) => e.location).toSet().toList());
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>> fetchListing(FilterQueryDto? query) async {
    await pseudoFetchDelay();
    final result = switch (query) {
      final query? => await _getListingFromQuery(query),
      null => await _getCarListing(),
    };

    return Right(result);
  }

  @override
  Future<Either<DealershipException, int>> fetchAdsCount(FilterQueryDto? query) async {
    await pseudoFetchDelay();
    final result = switch (query) {
      final query? => await _getListingFromQuery(query),
      null => await _getCarListing(),
    };

    return Right(result.length);
  }

  @override
  Future<Either<DealershipException, List<SellerDto>>> fetchSellers() async {
    await pseudoFetchDelay();

    switch (_sellers) {
      case final sellers?:
        return Right(sellers);
      case _:
        final jsonText = await rootBundle.loadString('sellers'.json);
        final json = jsonDecode(jsonText) as List<dynamic>;
        _sellers = json.map((e) => SellerDto.fromJson(e as Map<String, dynamic>)).toList();
        return Right(_sellers!);
    }
  }

  Future<List<CarListingDto>> _getListingFromQuery(FilterQueryDto query) async {
    final listing = (await _getCarListing()).toList(); // soft copy

    final (make, model) = (query.make?.toLowerCase(), query.model?.toLowerCase());
    switch ((make, model)) {
      case (final make?, null):
        listing.retainWhere((element) => element.make.toLowerCase().contains(make));
      case (final make?, final model?):
        listing.retainWhere(
            (element) => element.make.toLowerCase().contains(make) && element.model.toLowerCase().contains(model));
      case (null, final model?):
        listing.retainWhere((element) => element.model.toLowerCase().contains(model));
    }

    final (minYear, maxYear) = (query.minYear, query.maxYear);
    switch ((minYear, maxYear)) {
      case (final minYear?, null):
        listing.retainWhere((element) => element.year >= minYear);
      case (null, final maxYear?):
        listing.retainWhere((element) => element.year <= maxYear);
      case (final minYear?, final maxYear?):
        listing.retainWhere((element) => element.year >= minYear && element.year <= maxYear);
    }

    final (minPrice, maxPrice) = (query.minPrice, query.maxPrice);
    switch ((minPrice, maxPrice)) {
      case (final minPrice?, null):
        listing.retainWhere((element) => element.price >= minPrice);
      case (null, final maxPrice?):
        listing.retainWhere((element) => element.price <= maxPrice);
      case (final minPrice?, final maxPrice?):
        listing.retainWhere((element) => element.price >= minPrice && element.price <= maxPrice);
    }

    final (minMileage, maxMileage) = (query.minMileage, query.maxMileage);
    switch ((minMileage, maxMileage)) {
      case (final minMileage?, null):
        listing.retainWhere((element) => element.mileage >= minMileage);
      case (null, final maxMileage?):
        listing.retainWhere((element) => element.mileage <= maxMileage);
      case (final minMileage?, final maxMileage?):
        listing.retainWhere((element) => element.mileage >= minMileage && element.mileage <= maxMileage);
    }

    final (color, location) = (query.color?.toLowerCase(), query.location?.toLowerCase());
    switch ((color, location)) {
      case (final color?, null):
        listing.retainWhere((element) => element.color.toLowerCase().contains(color));
      case (null, final location?):
        listing.retainWhere((element) => element.location.toLowerCase().contains(location));
      case (final color?, final location?):
        listing.retainWhere((element) =>
            element.color.toLowerCase().contains(color) && element.location.toLowerCase().contains(location));
    }

    final (transmission, fuelType, availability) = (query.transmission, query.fuelType, query.availability);
    switch ((transmission, fuelType, availability)) {
      case (null, null, null):
        break;
      case (final transmission?, null, null):
        listing.retainWhere((element) => element.transmission == transmission);
      case (null, final fuelType?, null):
        listing.retainWhere((element) => element.fuelType == fuelType);
      case (null, null, final availability?):
        listing.retainWhere((element) => element.availability == availability);
      case (final transmission?, final fuelType?, null):
        listing.retainWhere((element) => element.transmission == transmission && element.fuelType == fuelType);
      case (final transmission?, null, final availability?):
        listing.retainWhere((element) => element.transmission == transmission && element.availability == availability);
      case (null, final fuelType?, final availability?):
        listing.retainWhere((element) => element.fuelType == fuelType && element.availability == availability);
      case (final transmission?, final fuelType?, final availability?):
        listing.retainWhere((element) =>
            element.transmission == transmission &&
            element.fuelType == fuelType &&
            element.availability == availability);
    }

    if ((query.sellerId) case final id?) {
      listing.retainWhere((element) => element.sellerId == id);
    }

    return listing;
  }

  Future<List<CarListingDto>> _getCarListing() async {
    switch (_carListing) {
      case final carListing?:
        return carListing;
      case _:
        final jsonText = await rootBundle.loadString('car_listings'.json);
        final json = jsonDecode(jsonText) as List<dynamic>;
        _carListing = json.map((e) => CarListingDto.fromJson(e as Map<String, dynamic>)).toList();
        return _carListing!;
    }
  }
}
