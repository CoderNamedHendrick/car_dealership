sealed class Review {
  final int rating;

  const Review({this.rating = 0});
}

final class CarReviewDto extends Review {
  const CarReviewDto({super.rating, required this.carId});

  final String carId;
}

final class SellerReviewDto extends Review {
  const SellerReviewDto({super.rating, required this.sellerId});

  final String sellerId;
}
