import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/explore/explore_home_ui_state.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  group('Explore view model test suite', () {
    late SignalListener<BrandsUiState> brandsListener;
    late SignalListener<SellersUiState> sellersListener;
    late SignalListener<LocationUiState> locationListener;
    late SignalListener<ListingUiState> listingListener;
    late SignalListener<PopularColorsUiState> colorsListener;
    late CarDealerShipInterface mockCarDealershipRepo;

    setUpAll(() {
      registerFallbackValue(const ExploreHomeUiState.initial());
      registerFallbackValue(const BrandsUiState.initial());
      registerFallbackValue(const SellersUiState.initial());
      registerFallbackValue(const LocationUiState.initial());
      registerFallbackValue(const ListingUiState.initial());
      registerFallbackValue(const PopularColorsUiState.initial());
    });

    setUp(() {
      setupTestLocator();
      mockCarDealershipRepo = locator();
      brandsListener = SignalListener();
      sellersListener = SignalListener();
      locationListener = SignalListener();
      listingListener = SignalListener();
      colorsListener = SignalListener();
    });

    tearDown(() async => await GetIt.I.reset());

    test('fetch brands success test', () async {
      when(() => mockCarDealershipRepo.fetchBrands())
          .thenAnswer((_) => Future.value(const Right(['Chevrolet'])));
      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.brandsUiStateEmitter
          .onSignalUpdate(brandsListener.call);
      final currState = exploreHomeVM.brandsUiState;

      await exploreHomeVM.fetchBrands();

      verifyInOrder([
        () => brandsListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => brandsListener(
            any(that: isA<BrandsUiState>()),
            any(
                that: isA<BrandsUiState>().having((p0) => p0.currentState,
                    'brands ui state is loading', ViewState.loading))),
        () => brandsListener(
            any(that: isA<BrandsUiState>()),
            any(
                that: isA<BrandsUiState>()
                    .having((p0) => p0.currentState,
                        'brands ui state is success', ViewState.success)
                    .having((p0) => p0.brands.isNotEmpty,
                        'brands list isn\'t empty check', true))),
      ]);

      //dispose
      emitter();
    });

    test('fetch brands failure test', () async {
      when(() => mockCarDealershipRepo.fetchBrands()).thenAnswer(
          (_) => Future.value(const Left(MessageException('error'))));

      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.brandsUiStateEmitter
          .onSignalUpdate(brandsListener.call);
      final currState = exploreHomeVM.brandsUiState;

      await exploreHomeVM.fetchBrands();

      verifyInOrder([
        () => brandsListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => brandsListener(
            any(that: isA<BrandsUiState>()),
            any(
                that: isA<BrandsUiState>().having((p0) => p0.currentState,
                    'brands ui state is loading', ViewState.loading))),
        () => brandsListener(
            any(that: isA<BrandsUiState>()),
            any(
                that: isA<BrandsUiState>()
                    .having((p0) => p0.currentState, 'brands ui state is error',
                        ViewState.error)
                    .having((p0) => p0.error, 'brands error',
                        isA<MessageException>()))),
      ]);

      //dispose
      emitter();
    });

    test('fetch sellers success test', () async {
      when(() => mockCarDealershipRepo.fetchSellers())
          .thenAnswer((_) => Future.value(const Right([SellerDto.empty()])));
      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.sellersUiStateEmitter
          .onSignalUpdate(sellersListener.call);
      final currState = exploreHomeVM.sellersUiState;

      await exploreHomeVM.fetchSellers();

      verifyInOrder([
        () => sellersListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => sellersListener(
            any(that: isA<SellersUiState>()),
            any(
                that: isA<SellersUiState>().having((p0) => p0.currentState,
                    'sellers ui state is loading', ViewState.loading))),
        () => sellersListener(
            any(that: isA<SellersUiState>()),
            any(
                that: isA<SellersUiState>()
                    .having((p0) => p0.currentState,
                        'sellers ui state is success', ViewState.success)
                    .having((p0) => p0.sellers.isNotEmpty,
                        'sellers list isn\'t empty check', true))),
      ]);

      //dispose
      emitter();
    });

    test('fetch sellers failure test', () async {
      when(() => mockCarDealershipRepo.fetchSellers()).thenAnswer(
          (_) => Future.value(const Left(MessageException('error'))));

      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.sellersUiStateEmitter
          .onSignalUpdate(sellersListener.call);
      final currState = exploreHomeVM.sellersUiState;

      await exploreHomeVM.fetchSellers();

      verifyInOrder([
        () => sellersListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => sellersListener(
            any(that: isA<SellersUiState>()),
            any(
                that: isA<SellersUiState>().having((p0) => p0.currentState,
                    'sellers ui state is loading', ViewState.loading))),
        () => sellersListener(
            any(that: isA<SellersUiState>()),
            any(
                that: isA<SellersUiState>()
                    .having((p0) => p0.currentState,
                        'sellers ui state is error', ViewState.error)
                    .having((p0) => p0.error, 'sellers error',
                        isA<MessageException>()))),
      ]);

      //dispose
      emitter();
    });

    test('fetch locations success test', () async {
      when(() => mockCarDealershipRepo.fetchLocations())
          .thenAnswer((_) => Future.value(const Right(['Lagos'])));

      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.locationUiStateEmitter
          .onSignalUpdate(locationListener.call);
      final currState = exploreHomeVM.locationUiState;

      await exploreHomeVM.fetchLocations();

      verifyInOrder([
        () => locationListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => locationListener(
            any(that: isA<LocationUiState>()),
            any(
                that: isA<LocationUiState>().having((p0) => p0.currentState,
                    'locations ui state is loading', ViewState.loading))),
        () => locationListener(
            any(that: isA<LocationUiState>()),
            any(
                that: isA<LocationUiState>()
                    .having((p0) => p0.currentState,
                        'locations ui state is success', ViewState.success)
                    .having((p0) => p0.locations.isNotEmpty,
                        'locations list isn\'t empty check', true))),
      ]);

      //dispose
      emitter();
    });

    test('fetch locations failure test', () async {
      when(() => mockCarDealershipRepo.fetchLocations()).thenAnswer(
          (_) => Future.value(const Left(MessageException('error'))));

      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.locationUiStateEmitter
          .onSignalUpdate(locationListener.call);
      final currState = exploreHomeVM.locationUiState;

      await exploreHomeVM.fetchLocations();

      verifyInOrder([
        () => locationListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => locationListener(
            any(that: isA<LocationUiState>()),
            any(
                that: isA<LocationUiState>().having((p0) => p0.currentState,
                    'locations ui state is loading', ViewState.loading))),
        () => locationListener(
            any(that: isA<LocationUiState>()),
            any(
                that: isA<LocationUiState>()
                    .having((p0) => p0.currentState,
                        'locations ui state is error', ViewState.error)
                    .having((p0) => p0.error, 'locations error',
                        isA<MessageException>()))),
      ]);

      //dispose
      emitter();
    });

    test('fetch colors success test', () async {
      when(() => mockCarDealershipRepo.fetchPopularColors())
          .thenAnswer((_) => Future.value(const Right(['Green'])));

      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.colorsUiStateEmitter
          .onSignalUpdate(colorsListener.call);
      final currState = exploreHomeVM.colorsUiState;

      await exploreHomeVM.fetchColors();

      verifyInOrder([
        () => colorsListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => colorsListener(
            any(that: isA<PopularColorsUiState>()),
            any(
                that: isA<PopularColorsUiState>().having(
                    (p0) => p0.currentState,
                    'colors ui state is loading',
                    ViewState.loading))),
        () => colorsListener(
            any(that: isA<PopularColorsUiState>()),
            any(
                that: isA<PopularColorsUiState>()
                    .having((p0) => p0.currentState,
                        'colors ui state is success', ViewState.success)
                    .having((p0) => p0.colors.isNotEmpty,
                        'colors list isn\'t empty check', true))),
      ]);

      //dispose
      emitter();
    });

    test('fetch colors failure test', () async {
      when(() => mockCarDealershipRepo.fetchPopularColors()).thenAnswer(
          (_) => Future.value(const Left(MessageException('error'))));

      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.colorsUiStateEmitter
          .onSignalUpdate(colorsListener.call);
      final currState = exploreHomeVM.colorsUiState;

      await exploreHomeVM.fetchColors();

      verifyInOrder([
        () => colorsListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => colorsListener(
            any(that: isA<PopularColorsUiState>()),
            any(
                that: isA<PopularColorsUiState>().having(
                    (p0) => p0.currentState,
                    'colors ui state is loading',
                    ViewState.loading))),
        () => colorsListener(
            any(that: isA<PopularColorsUiState>()),
            any(
                that: isA<PopularColorsUiState>()
                    .having((p0) => p0.currentState, 'color ui state is error',
                        ViewState.error)
                    .having((p0) => p0.error, 'locations error',
                        isA<MessageException>()))),
      ]);

      //dispose
      emitter();
    });

    test('fetch listings success test', () async {
      when(() => mockCarDealershipRepo
              .fetchListing(const FilterQueryDto(make: 'Tesla')))
          .thenAnswer(
              (_) => Future.value(const Right([CarListingDto.empty()])));

      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.listingUiStateEmitter
          .onSignalUpdate(listingListener.call);
      final currState = exploreHomeVM.listingUiState;

      exploreHomeVM.setFilter(const FilterQueryDto(make: 'Tesla'));
      await exploreHomeVM.fetchListing();

      verifyInOrder([
        () => listingListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => listingListener(
            any(that: isA<ListingUiState>()),
            any(
                that: isA<ListingUiState>().having((p0) => p0.currentState,
                    'listings ui state is loading', ViewState.loading))),
        () => listingListener(
            any(that: isA<ListingUiState>()),
            any(
                that: isA<ListingUiState>()
                    .having((p0) => p0.currentState,
                        'listings ui state is success', ViewState.success)
                    .having((p0) => p0.listing.isNotEmpty,
                        'colors list isn\'t empty check', true))),
      ]);

      //dispose
      emitter();
    });

    testWidgets('fetch listings failure test', (tester) async {
      when(() => mockCarDealershipRepo.fetchListing(const FilterQueryDto()))
          .thenAnswer(
              (_) => Future.value(const Left(MessageException('error'))));

      final exploreHomeVM = locator<ExploreHomeViewModel>();

      var emitter = exploreHomeVM.listingUiStateEmitter
          .onSignalUpdate(listingListener.call);
      final currState = exploreHomeVM.listingUiState;

      await tester.pumpWidget(const UnitTestApp());
      await exploreHomeVM.fetchListing();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listingListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => listingListener(
            any(that: isA<ListingUiState>()),
            any(
                that: isA<ListingUiState>().having((p0) => p0.currentState,
                    'listings ui state is loading', ViewState.loading))),
        () => listingListener(
            any(that: isA<ListingUiState>()),
            any(
                that: isA<ListingUiState>()
                    .having((p0) => p0.currentState,
                        'listings ui state is error', ViewState.error)
                    .having((p0) => p0.error, 'listings error',
                        isA<MessageException>()))),
      ]);

      //dispose
      emitter();
    });
  });
}
