import 'package:car_dealership/application/core/view_model.dart';
import 'package:car_dealership/domain/car_listings/car_listing_domain.dart';
import 'package:car_dealership/domain/core/dealership_exception.dart';
import 'package:equatable/equatable.dart';

final class ListingUiState extends Equatable {
  final CarListingDto currentListing;
  final ListingReviewsUiState reviewsUiState;
  final ListingSavedCarUiState savedCarUiState;
  final ContactSellerUiState contactSellerUiState;
  final RatePurchaseUiState purchaseRatingUiState;

  const ListingUiState({
    required this.currentListing,
    required this.reviewsUiState,
    required this.savedCarUiState,
    required this.contactSellerUiState,
    required this.purchaseRatingUiState,
  });

  const ListingUiState.initial()
      : this(
          currentListing: const CarListingDto.empty(),
          reviewsUiState: const ListingReviewsUiState.initial(),
          savedCarUiState: const ListingSavedCarUiState.initial(),
          contactSellerUiState: const ContactSellerUiState.initial(),
          purchaseRatingUiState: const RatePurchaseUiState.initial(),
        );

  ListingUiState copyWith({
    CarListingDto? currentListing,
    ListingReviewsUiState? reviewsUiState,
    ListingSavedCarUiState? savedCarUiState,
    ContactSellerUiState? contactSellerUiState,
    RatePurchaseUiState? purchaseRatingUiState,
  }) {
    return ListingUiState(
      currentListing: currentListing ?? this.currentListing,
      reviewsUiState: reviewsUiState ?? this.reviewsUiState,
      savedCarUiState: savedCarUiState ?? this.savedCarUiState,
      contactSellerUiState: contactSellerUiState ?? this.contactSellerUiState,
      purchaseRatingUiState: purchaseRatingUiState ?? this.purchaseRatingUiState,
    );
  }

  @override
  List<Object?> get props =>
      [currentListing, reviewsUiState, savedCarUiState, contactSellerUiState, purchaseRatingUiState];
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

final class ContactSellerUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final bool isOngoingNegotiation;

  const ContactSellerUiState({required this.currentState, required this.error, required this.isOngoingNegotiation});

  const ContactSellerUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          isOngoingNegotiation: false,
        );

  ContactSellerUiState copyWith({ViewState? currentState, DealershipException? error, bool? isOngoingNegotiation}) {
    return ContactSellerUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      isOngoingNegotiation: isOngoingNegotiation ?? this.isOngoingNegotiation,
    );
  }

  @override
  List<Object?> get props => [currentState, error, isOngoingNegotiation];
}

final class RatePurchaseUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;

  const RatePurchaseUiState({required this.currentState, required this.error});

  const RatePurchaseUiState.initial() : this(currentState: ViewState.idle, error: const EmptyException());

  RatePurchaseUiState copyWith({ViewState? currentState, DealershipException? error}) {
    return RatePurchaseUiState(currentState: currentState ?? this.currentState, error: error ?? this.error);
  }

  @override
  List<Object?> get props => [currentState, error];
}
