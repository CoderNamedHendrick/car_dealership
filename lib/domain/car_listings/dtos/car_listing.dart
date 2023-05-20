final class CarListingDto {
  final String id;
  final String sellerId;
  final String make;
  final String model;
  final int year;
  final num price;
  final num mileage;
  final String color;
  final Transmission transmission;
  final FuelType fuelType;
  final Availability availability;
  final List<String> features;
  final String description;
  final String location;
  final List<String> photos;

  const CarListingDto({
    required this.id,
    required this.sellerId,
    required this.make,
    required this.model,
    required this.year,
    required this.price,
    required this.mileage,
    required this.color,
    required this.transmission,
    required this.fuelType,
    required this.availability,
    required this.features,
    required this.description,
    required this.location,
    required this.photos,
  });

  const CarListingDto.empty()
      : this(
          id: '',
          sellerId: '',
          make: '',
          model: '',
          year: 0,
          price: 0,
          mileage: 0,
          color: '',
          transmission: Transmission.manual,
          fuelType: FuelType.gasoline,
          availability: Availability.open,
          features: const [],
          description: '',
          location: '',
          photos: const [],
        );

  factory CarListingDto.fromJson(Map<String, dynamic> json) => CarListingDto(
        id: json['id'] ?? '',
        sellerId: json['seller_id'] ?? '',
        make: json['make'] ?? '',
        model: json['model'] ?? '',
        year: json['year'] ?? -1,
        price: json['price'] ?? 0,
        mileage: json['mileage'] ?? 0,
        color: json['color'] ?? '',
        transmission: (json['transmission'].toString()).transmission,
        fuelType: (json['fuel_type'].toString()).fuelType,
        availability: (json['availability'].toString()).availability,
        features: (json['features'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        description: json['description'] ?? '',
        location: json['location'] ?? '',
        photos: (json['photos'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'seller_id': sellerId,
        'make': make,
        'model': model,
        'year': year,
        'price': price,
        'mileage': mileage,
        'color': color,
        'transmission': transmission.json,
        'fuel_type': fuelType.json,
        'availability': availability.json,
        'features': features,
        'description': description,
        'photos': photos,
        'location': location,
      };
}

enum Transmission {
  automatic('Automatic'),
  manual('Manual');

  final String json;

  const Transmission(this.json);
}

enum FuelType {
  gasoline('Gasoline'),
  electric('Electric'),
  hybrid('Hybrid');

  final String json;

  const FuelType(this.json);
}

enum Availability {
  open('open'),
  sold('sold'),
  preOrder('pre-order');

  final String json;

  const Availability(this.json);
}

extension TypeX on String {
  Transmission get transmission {
    return Transmission.values.firstWhere((element) => element.json == this, orElse: () => Transmission.automatic);
  }

  FuelType get fuelType {
    return FuelType.values.firstWhere((element) => element.json == this, orElse: () => FuelType.gasoline);
  }

  Availability get availability {
    return Availability.values.firstWhere((element) => element.json == this, orElse: () => Availability.open);
  }
}
