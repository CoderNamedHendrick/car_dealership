// coverage:ignore-file
import '../../domain/domain.dart';

sealed class UserTable {
  const UserTable({required this.userId});

  final String userId;
}

final class PurchasedCarListingTable extends UserTable {
  final List<CarListingDto> carListing;

  const PurchasedCarListingTable({required super.userId, required this.carListing});

  PurchasedCarListingTable copyWith({String? userId, List<CarListingDto>? carListing}) {
    return PurchasedCarListingTable(userId: userId ?? this.userId, carListing: carListing ?? this.carListing);
  }
}

final class SavedCarsListingTable extends UserTable {
  final List<CarListingDto> carListing;

  const SavedCarsListingTable({required super.userId, required this.carListing});

  SavedCarsListingTable copyWith({String? userId, List<CarListingDto>? carListing}) {
    return SavedCarsListingTable(userId: userId ?? this.userId, carListing: carListing ?? this.carListing);
  }
}
