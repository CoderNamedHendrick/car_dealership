import 'package:car_dealership/application/core/ui_state.dart';
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
      purchaseRatingUiState:
          purchaseRatingUiState ?? this.purchaseRatingUiState,
    );
  }

  @override
  List<Object?> get props => [
        currentListing,
        reviewsUiState,
        savedCarUiState,
        contactSellerUiState,
        purchaseRatingUiState
      ];
}

final class ListingReviewsUiState
    extends DealershipUiStateModel<ListingReviewsUiState> {
  final SellerReviewDto currentSellerReview;
  final CarReviewDto currentCarReview;

  const ListingReviewsUiState({
    super.uiState,
    super.error,
    required this.currentSellerReview,
    required this.currentCarReview,
  });

  const ListingReviewsUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          currentSellerReview: const SellerReviewDto(sellerId: ''),
          currentCarReview: const CarReviewDto(carId: ''),
        );

  @override
  ListingReviewsUiState copyWith(
      {UiState? uiState,
      DealershipException? error,
      SellerReviewDto? currentSellerReview,
      CarReviewDto? currentCarReview}) {
    return ListingReviewsUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      currentSellerReview: currentSellerReview ?? this.currentSellerReview,
      currentCarReview: currentCarReview ?? this.currentCarReview,
    );
  }

  @override
  List<Object?> get props =>
      [uiState, error, currentSellerReview, currentCarReview];
}

final class ListingSavedCarUiState
    extends DealershipUiStateModel<ListingSavedCarUiState> {
  final bool isListingSaved;

  const ListingSavedCarUiState({
    super.uiState,
    super.error,
    required this.isListingSaved,
  });

  const ListingSavedCarUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          isListingSaved: false,
        );

  @override
  ListingSavedCarUiState copyWith(
      {UiState? uiState,
      DealershipException? error,
      bool? isListingSaved}) {
    return ListingSavedCarUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      isListingSaved: isListingSaved ?? this.isListingSaved,
    );
  }

  @override
  List<Object?> get props => [uiState, error, isListingSaved];
}

final class ContactSellerUiState
    extends DealershipUiStateModel<ContactSellerUiState> {
  final bool isOngoingNegotiation;

  const ContactSellerUiState({
    super.uiState,
    super.error,
    required this.isOngoingNegotiation,
  });

  const ContactSellerUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          isOngoingNegotiation: false,
        );

  @override
  ContactSellerUiState copyWith(
      {UiState? uiState,
      DealershipException? error,
      bool? isOngoingNegotiation}) {
    return ContactSellerUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      isOngoingNegotiation: isOngoingNegotiation ?? this.isOngoingNegotiation,
    );
  }

  @override
  List<Object?> get props => [uiState, error, isOngoingNegotiation];
}

final class RatePurchaseUiState extends DealershipUiStateModel<RatePurchaseUiState> {
  const RatePurchaseUiState({super.uiState, super.error});

  const RatePurchaseUiState.initial()
      : this(uiState: UiState.idle, error: const EmptyException());

  @override
  RatePurchaseUiState copyWith(
      {UiState? uiState, DealershipException? error}) {
    return RatePurchaseUiState(
        uiState: uiState ?? this.uiState,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [uiState, error];
}
