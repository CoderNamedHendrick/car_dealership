import 'car_listing.dart';

final class FilterQuery {
  final String? make;
  final String? model;
  final int? minYear;
  final int? maxYear;
  final double? minPrice;
  final double? maxPrice;
  final double? minMileage;
  final double? maxMileage;
  final String? color;
  final Transmission? transmission;
  final FuelType? fuelType;
  final Availability? availability;
  final String? location;

  const FilterQuery({
    this.make,
    this.model,
    this.minYear,
    this.maxYear,
    this.minPrice,
    this.maxPrice,
    this.minMileage,
    this.maxMileage,
    this.color,
    this.transmission,
    this.fuelType,
    this.availability,
    this.location,
  });
}
