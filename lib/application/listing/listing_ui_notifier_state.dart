import 'package:car_dealership/application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import 'listing_ui_state.dart';

class ListingUiStateNotifier extends StateNotifier<ListingUiState> {
  final CarListingInterface _carListingRepo;
  final ChatRepositoryInterface _chatRepo;

  ListingUiStateNotifier(this._carListingRepo, this._chatRepo) : super(const ListingUiState.initial());

  void initialiseListing(CarListingDto dto) {
    state = state.copyWith(currentListing: dto);

    Future.wait([getListingReviews(), getIsSavedListing(), checkIfNegotiationAvailable()]);
  }

  Future<void> getListingReviews() async {
    assert(state.currentListing.id.isNotEmpty, 'Listing id must be available when this method is called');

    state = state.copyWith(reviewsUiState: state.reviewsUiState.copyWith(currentState: ViewState.loading));
    final results = await Future.wait([
      _carListingRepo.fetchSellerReview(state.currentListing.sellerId),
      _carListingRepo.fetchCarListingReview(state.currentListing.id)
    ]);

    state = state.copyWith(
      reviewsUiState: results[0].fold(
        (left) => state.reviewsUiState.copyWith(currentState: ViewState.error, error: left),
        (sellerReviewDto) => results[1].fold(
          (left) => state.reviewsUiState.copyWith(currentState: ViewState.error, error: left),
          (carReviewDto) => state.reviewsUiState.copyWith(
            currentState: ViewState.success,
            currentSellerReview: sellerReviewDto as SellerReviewDto?,
            currentCarReview: carReviewDto as CarReviewDto?,
          ),
        ),
      ),
    );
  }

  Future<void> getIsSavedListing() async {
    assert(state.currentListing.id.isNotEmpty, 'Listing id must be available when this method is called');

    state = state.copyWith(savedCarUiState: state.savedCarUiState.copyWith(currentState: ViewState.loading));
    final result = await _carListingRepo.fetchSavedByUser(state.currentListing.id);

    state = state.copyWith(
      savedCarUiState: result.fold((left) => state.savedCarUiState.copyWith(currentState: ViewState.error, error: left),
          (right) => state.savedCarUiState.copyWith(currentState: ViewState.idle, isListingSaved: right)),
    );
  }

  Future<void> checkIfNegotiationAvailable() async {
    assert(state.currentListing.id.isNotEmpty, 'Listing id must be available when this method is called');

    state = state.copyWith(contactSellerUiState: state.contactSellerUiState.copyWith(currentState: ViewState.loading));
    final result = await _chatRepo.negotiationAvailable(state.currentListing.sellerId, state.currentListing.id);

    state = state.copyWith(
      contactSellerUiState: result.fold(
          (left) => state.contactSellerUiState
              .copyWith(currentState: ViewState.error, error: left, isOngoingNegotiation: false),
          (right) => state.contactSellerUiState.copyWith(currentState: ViewState.success, isOngoingNegotiation: right)),
    );
  }

  void toggleSaveListing() async {
    assert(state.currentListing.id.isNotEmpty, 'Listing id must be available when this method is called');

    if (state.savedCarUiState.currentState == ViewState.loading) return; // don't perform action when loading

    await launch(state.savedCarUiState.ref, (model) async {
      state = state.copyWith(
        savedCarUiState: model.emit(state.savedCarUiState.copyWith(currentState: ViewState.loading)),
      );
      final result = await _carListingRepo.toggleSaveCarListing(state.currentListing.id);

      state = state.copyWith(
        savedCarUiState: result.fold(
          (left) => model.emit(
            state.savedCarUiState.copyWith(currentState: ViewState.error, error: left, isListingSaved: false),
          ),
          (right) => model.emit(state.savedCarUiState.copyWith(currentState: ViewState.success)),
        ),
      );

      result.either((left) => null, (right) => getIsSavedListing());
    });

    state = state.copyWith(savedCarUiState: state.savedCarUiState.copyWith(currentState: ViewState.idle));
  }

  void ratePurchase(int rating) async {
    await launch(state.purchaseRatingUiState.ref, (model) async {
      state = state.copyWith(
          purchaseRatingUiState: model.emit(state.purchaseRatingUiState.copyWith(currentState: ViewState.loading)));
      final result =
          await _carListingRepo.reviewCarListing(CarReviewDto(carId: state.currentListing.id, rating: rating));

      state = state.copyWith(
        purchaseRatingUiState: result.fold(
            (left) => model.emit(state.purchaseRatingUiState.copyWith(currentState: ViewState.error, error: left)),
            (right) => model.emit(state.purchaseRatingUiState.copyWith(currentState: ViewState.success))),
      );
    });
  }
}

final listingUiStateNotifierProvider = StateNotifierProvider.autoDispose<ListingUiStateNotifier, ListingUiState>((ref) {
  return ListingUiStateNotifier(ref.read(carListingProvider), ref.read(chatRepositoryProvider));
});
