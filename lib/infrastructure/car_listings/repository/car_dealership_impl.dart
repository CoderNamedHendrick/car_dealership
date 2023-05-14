import 'dart:convert';
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
    final listing = (await _getCarListing()).toList();

    return Right(listing.map((e) => e.make).toList());
  }

  @override
  Future<Either<DealershipException, List<CarListingDto>>> fetchListing(FilterQuery? query) async {
    final result = switch (query) {
      final query? => await _getListingFromQuery(query),
      null => await _getCarListing(),
    };

    return Right(result);
  }

  @override
  Future<Either<DealershipException, List<SellerDto>>> fetchSellers() async {
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

  Future<List<CarListingDto>> _getListingFromQuery(FilterQuery query) async {
    final listing = (await _getCarListing()).toList(); // soft copy

    final (make, model) = (query.make?.toLowerCase(), query.model?.toLowerCase());
    switch ((make, model)) {
      case (!= null, == null):
        listing.retainWhere((element) => element.make.toLowerCase().contains(make!));
      case (!= null, != null):
        listing.retainWhere(
            (element) => element.make.toLowerCase().contains(make!) && element.model.toLowerCase().contains(model!));
      case (== null, != null):
        listing.retainWhere((element) => element.model.toLowerCase().contains(model!));
    }

    final (minYear, maxYear) = (query.minYear, query.maxYear);
    switch ((minYear, maxYear)) {
      case (!= null, == null):
        listing.retainWhere((element) => element.year >= minYear!);
      case (!= null, != null):
        listing.retainWhere((element) => element.year >= minYear! && element.year <= maxYear!);
    }

    final (minPrice, maxPrice) = (query.minPrice, query.maxPrice);
    switch ((minPrice, maxPrice)) {
      case (!= null, == null):
        listing.retainWhere((element) => element.price >= minPrice!);
      case (!= null, != null):
        listing.retainWhere((element) => element.price >= minPrice! && element.price <= maxPrice!);
    }

    final (minMileage, maxMilage) = (query.minMileage, query.maxMileage);
    switch ((minMileage, maxMilage)) {
      case (!= null, == null):
        listing.retainWhere((element) => element.mileage >= minMileage!);
      case (!= null, != null):
        listing.retainWhere((element) => element.mileage >= minMileage! && element.mileage <= maxMilage!);
    }

    final (color, location) = (query.color?.toLowerCase(), query.location?.toLowerCase());
    switch ((color, location)) {
      case (!= null, == null):
        listing.retainWhere((element) => element.color.toLowerCase().contains(color!));
      case (== null, != null):
        listing.retainWhere((element) => element.location.toLowerCase().contains(location!));
      case (!= null, != null):
        listing.retainWhere((element) =>
            element.color.toLowerCase().contains(color!) && element.location.toLowerCase().contains(location!));
    }

    final (transmission, fuelType, availability) = (query.transmission, query.fuelType, query.availability);

    listing.retainWhere(
      (element) =>
          element.transmission == transmission || element.fuelType == fuelType || element.availability == availability,
    );

    return listing;
  }

  Future<List<CarListingDto>> _getCarListing() async {
    switch (_carListing) {
      case final carListing?:
        return carListing;
      case _:
        final jsonText = await rootBundle.loadString('car_listings'.json);
        final json = jsonDecode(jsonText) as List<dynamic>;
        _carListing = json.map((e) => CarListingDto.fromJson(e as Map<String, dynamic>)).toList(growable: false);
        return _carListing!;
    }
  }
}
