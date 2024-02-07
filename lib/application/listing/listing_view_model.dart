import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/listing/listing_ui_state.dart';
import 'package:signals/signals_flutter.dart';

import '../../domain/domain.dart';

final class ListingViewModel {
  final CarListingInterface _carListingRepo;
  final ChatRepositoryInterface _chatRepo;

  ListingViewModel(this._carListingRepo, this._chatRepo);

  final _currentListing = signal(const CarListingDto.empty());
  final _reviewsState = signal(const ListingReviewsUiState.initial());
  final _savedCarsUiState = signal(const ListingSavedCarUiState.initial());
  final _contactsSellerUiState = signal(const ContactSellerUiState.initial());
  final _purchaseRatingState = signal(const RatePurchaseUiState.initial());

  ReadonlySignal<CarListingDto> get currentListingEmitter =>
      _currentListing;

  ReadonlySignal<ListingReviewsUiState> get reviewsUiStateEmitter =>
      _reviewsState;

  ReadonlySignal<ListingSavedCarUiState> get savedCarsUiStateEmitter =>
      _savedCarsUiState;

  ReadonlySignal<ContactSellerUiState> get contactSellerUiStateEmitter =>
      _contactsSellerUiState;

  ReadonlySignal<RatePurchaseUiState> get purchaseRatingUiStateEmitter =>
      _purchaseRatingState;

  CarListingDto get currentListing => _currentListing.value;

  ListingReviewsUiState get reviewsUiState =>
      _reviewsState.value;

  ListingSavedCarUiState get savedCarsUiState =>
      _savedCarsUiState.value;

  ContactSellerUiState get contactSellerUiState =>
      _contactsSellerUiState.value;

  RatePurchaseUiState get purchaseRatingUiState =>
      _purchaseRatingState.value;

  void initialiseListing(CarListingDto dto) {
    _currentListing.value = dto;

    Future.wait([
      getListingReviews(),
      getIsSavedListing(),
      checkIfNegotiationAvailable()
    ]);
  }

  Future<void> getListingReviews() async {
    assert(currentListing.id.isNotEmpty,
        'Listing id must be available when this method is called');

    _reviewsState.value =
        reviewsUiState.copyWith(currentState: ViewState.loading);
    final results = await Future.wait([
      _carListingRepo.fetchSellerReview(currentListing.sellerId),
      _carListingRepo.fetchCarListingReview(currentListing.id)
    ]);

    _reviewsState.value = results[0].fold(
      (left) =>
          reviewsUiState.copyWith(currentState: ViewState.error, error: left),
      (sellerReviewDto) => results[1].fold(
        (left) =>
            reviewsUiState.copyWith(currentState: ViewState.error, error: left),
        (carReviewDto) => reviewsUiState.copyWith(
          currentState: ViewState.success,
          currentSellerReview: sellerReviewDto as SellerReviewDto?,
          currentCarReview: carReviewDto as CarReviewDto?,
        ),
      ),
    );
  }

  Future<void> getIsSavedListing() async {
    assert(currentListing.id.isNotEmpty,
        'Listing id must be available when this method is called');

    _savedCarsUiState.value =
        savedCarsUiState.copyWith(currentState: ViewState.loading);
    final result = await _carListingRepo.fetchSavedByUser(currentListing.id);

    _savedCarsUiState.value = result.fold(
      (left) =>
          savedCarsUiState.copyWith(currentState: ViewState.error, error: left),
      (right) => savedCarsUiState.copyWith(
          currentState: ViewState.idle, isListingSaved: right),
    );
  }

  Future<void> checkIfNegotiationAvailable() async {
    assert(currentListing.id.isNotEmpty,
        'Listing id must be available when this method is called');

    _contactsSellerUiState.value =
        contactSellerUiState.copyWith(currentState: ViewState.loading);
    final result = await _chatRepo.negotiationAvailable(
        currentListing.sellerId, currentListing.id);

    _contactsSellerUiState.value = result.fold(
      (left) => contactSellerUiState.copyWith(
          currentState: ViewState.error,
          error: left,
          isOngoingNegotiation: false),
      (right) => contactSellerUiState.copyWith(
          currentState: ViewState.success, isOngoingNegotiation: right),
    );
  }

  void toggleSaveListing() async {
    assert(currentListing.id.isNotEmpty,
        'Listing id must be available when this method is called');

    if (savedCarsUiState.currentState == ViewState.loading) {
      return; // don't perform action when loading
    }

    await launch(savedCarsUiState.ref, (model) async {
      _savedCarsUiState.value = model
          .emit(savedCarsUiState.copyWith(currentState: ViewState.loading));
      final result =
          await _carListingRepo.toggleSaveCarListing(currentListing.id);

      _savedCarsUiState.value = result.fold(
        (left) => model.emit(
          savedCarsUiState.copyWith(
              currentState: ViewState.error,
              error: left,
              isListingSaved: false),
        ),
        (right) => model
            .emit(savedCarsUiState.copyWith(currentState: ViewState.success)),
      );

      result.either((left) => null, (right) => getIsSavedListing());
    });

    _savedCarsUiState.value =
        savedCarsUiState.copyWith(currentState: ViewState.idle);
  }

  void ratePurchase(int rating) async {
    await launch(purchaseRatingUiState.ref, (model) async {
      _purchaseRatingState.value = model.emit(
          purchaseRatingUiState.copyWith(currentState: ViewState.loading));
      final result = await _carListingRepo.reviewCarListing(
          CarReviewDto(carId: currentListing.id, rating: rating));

      _purchaseRatingState.value = result.fold(
        (left) => model.emit(purchaseRatingUiState.copyWith(
            currentState: ViewState.error, error: left)),
        (right) => model.emit(
            purchaseRatingUiState.copyWith(currentState: ViewState.success)),
      );
    });
  }
}
