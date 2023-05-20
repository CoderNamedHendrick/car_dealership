import 'package:car_dealership/application/core/view_model.dart';
import 'package:car_dealership/domain/car_listings/car_listing_domain.dart';
import 'package:car_dealership/domain/core/dealership_exception.dart';

final class ListingUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final CarListingDto currentListing;
  final ListingReviewsUiState reviewsUiState;
  final ListingSavedCarUiState savedCarUiState;

  const ListingUiState({
    required this.currentState,
    required this.error,
    required this.currentListing,
    required this.reviewsUiState,
    required this.savedCarUiState,
  });

  const ListingUiState.initial()
      : this(
          currentState: ViewState.idle,
          currentListing: const CarListingDto.empty(),
          error: const EmptyException(),
          reviewsUiState: const ListingReviewsUiState.initial(),
          savedCarUiState: const ListingSavedCarUiState.initial(),
        );

  ListingUiState copyWith({
    ViewState? currentState,
    DealershipException? error,
    CarListingDto? currentListing,
    ListingReviewsUiState? reviewsUiState,
    ListingSavedCarUiState? savedCarUiState,
  }) {
    return ListingUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      currentListing: currentListing ?? this.currentListing,
      reviewsUiState: reviewsUiState ?? this.reviewsUiState,
      savedCarUiState: savedCarUiState ?? this.savedCarUiState,
    );
  }

  @override
  List<Object?> get props => [currentState, error, currentListing, reviewsUiState, savedCarUiState];
}

final class ListingReviewsUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final SellerReviewDto currentSellerReview;
  final CarReviewDto currentCarReview;

  const ListingReviewsUiState({
    required this.currentState,
    required this.error,
    required this.currentSellerReview,
    required this.currentCarReview,
  });

  const ListingReviewsUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          currentSellerReview: const SellerReviewDto(sellerId: ''),
          currentCarReview: const CarReviewDto(carId: ''),
        );

  ListingReviewsUiState copyWith(
      {ViewState? currentState,
      DealershipException? error,
      SellerReviewDto? currentSellerReview,
      CarReviewDto? currentCarReview}) {
    return ListingReviewsUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      currentSellerReview: currentSellerReview ?? this.currentSellerReview,
      currentCarReview: currentCarReview ?? this.currentCarReview,
    );
  }

  @override
  List<Object?> get props => [currentState, error, currentSellerReview, currentCarReview];
}

final class ListingSavedCarUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final bool isListingSaved;

  const ListingSavedCarUiState({required this.currentState, required this.error, required this.isListingSaved});

  const ListingSavedCarUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          isListingSaved: false,
        );

  ListingSavedCarUiState copyWith({ViewState? currentState, DealershipException? error, bool? isListingSaved}) {
    return ListingSavedCarUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      isListingSaved: isListingSaved ?? this.isListingSaved,
    );
  }

  @override
  List<Object?> get props => [currentState, error, isListingSaved];
}
