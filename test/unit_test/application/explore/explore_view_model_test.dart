import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/explore/explore_home_ui_state.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  final mockCarDealershipRepo = MockCarDealerShipRepo();

  group('Explore view model test suite', () {
    late ProviderContainer container;
    late RiverpodListener<ExploreHomeUiState> listener;

    setUpAll(() => registerFallbackValue(const ExploreHomeUiState.initial()));

    setUp(() {
      container = ProviderContainer(overrides: [carDealershipProvider.overrideWithValue(mockCarDealershipRepo)]);
      listener = RiverpodListener();
    });

    tearDown(() => container.dispose());

    test('fetch brands success test', () async {
      when(() => mockCarDealershipRepo.fetchBrands()).thenAnswer((_) => Future.value(const Right(['Chevrolet'])));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchBrands();

      verifyInOrder([
        () => listener(
            null, currState.copyWith(brandsUiState: currState.brandsUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.brandsUiState.currentState, 'brands ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.brandsUiState.currentState, 'brands ui state is success', ViewState.success)
                    .having((p0) => p0.brandsUiState.brands.isNotEmpty, 'brands list isn\'t empty check', true))),
      ]);
    });

    test('fetch brands failure test', () async {
      when(() => mockCarDealershipRepo.fetchBrands())
          .thenAnswer((_) => Future.value(const Left(MessageException('error'))));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchBrands();

      verifyInOrder([
        () => listener(
            null, currState.copyWith(brandsUiState: currState.brandsUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.brandsUiState.currentState, 'brands ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.brandsUiState.currentState, 'brands ui state is error', ViewState.error)
                    .having((p0) => p0.brandsUiState.error, 'brands error', isA<MessageException>()))),
      ]);
    });

    test('fetch sellers success test', () async {
      when(() => mockCarDealershipRepo.fetchSellers())
          .thenAnswer((_) => Future.value(const Right([SellerDto.empty()])));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchSellers();

      verifyInOrder([
        () => listener(
            null, currState.copyWith(sellersUiState: currState.sellersUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.sellersUiState.currentState, 'sellers ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.sellersUiState.currentState, 'sellers ui state is success', ViewState.success)
                    .having((p0) => p0.sellersUiState.sellers.isNotEmpty, 'sellers list isn\'t empty check', true))),
      ]);
    });

    test('fetch sellers failure test', () async {
      when(() => mockCarDealershipRepo.fetchSellers())
          .thenAnswer((_) => Future.value(const Left(MessageException('error'))));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchSellers();

      verifyInOrder([
        () => listener(
            null, currState.copyWith(sellersUiState: currState.sellersUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.sellersUiState.currentState, 'sellers ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.sellersUiState.currentState, 'sellers ui state is error', ViewState.error)
                    .having((p0) => p0.sellersUiState.error, 'sellers error', isA<MessageException>()))),
      ]);
    });

    test('fetch locations success test', () async {
      when(() => mockCarDealershipRepo.fetchLocations()).thenAnswer((_) => Future.value(const Right(['Lagos'])));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchLocations();

      verifyInOrder([
        () => listener(null,
            currState.copyWith(locationUiState: currState.locationUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>().having(
                    (p0) => p0.locationUiState.currentState, 'locations ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.locationUiState.currentState, 'locations ui state is success', ViewState.success)
                    .having(
                        (p0) => p0.locationUiState.locations.isNotEmpty, 'locations list isn\'t empty check', true))),
      ]);
    });

    test('fetch locations failure test', () async {
      when(() => mockCarDealershipRepo.fetchLocations())
          .thenAnswer((_) => Future.value(const Left(MessageException('error'))));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchLocations();

      verifyInOrder([
        () => listener(null,
            currState.copyWith(locationUiState: currState.locationUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>().having(
                    (p0) => p0.locationUiState.currentState, 'locations ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.locationUiState.currentState, 'locations ui state is error', ViewState.error)
                    .having((p0) => p0.locationUiState.error, 'locations error', isA<MessageException>()))),
      ]);
    });

    test('fetch colors success test', () async {
      when(() => mockCarDealershipRepo.fetchPopularColors()).thenAnswer((_) => Future.value(const Right(['Green'])));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchColors();

      verifyInOrder([
        () => listener(
            null, currState.copyWith(colorsUiState: currState.colorsUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.colorsUiState.currentState, 'colors ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.colorsUiState.currentState, 'colors ui state is success', ViewState.success)
                    .having((p0) => p0.colorsUiState.colors.isNotEmpty, 'colors list isn\'t empty check', true))),
      ]);
    });

    test('fetch colors failure test', () async {
      when(() => mockCarDealershipRepo.fetchPopularColors())
          .thenAnswer((_) => Future.value(const Left(MessageException('error'))));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchColors();

      verifyInOrder([
        () => listener(
            null, currState.copyWith(colorsUiState: currState.colorsUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.colorsUiState.currentState, 'colors ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.colorsUiState.currentState, 'color ui state is error', ViewState.error)
                    .having((p0) => p0.colorsUiState.error, 'locations error', isA<MessageException>()))),
      ]);
    });

    test('fetch listings success test', () async {
      when(() => mockCarDealershipRepo.fetchListing(const FilterQueryDto(make: 'Tesla')))
          .thenAnswer((_) => Future.value(const Right([CarListingDto.empty()])));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      container.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(const FilterQueryDto(make: 'Tesla'));
      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();

      verifyInOrder([
        () => listener(
            null, currState.copyWith(listingUiState: currState.listingUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>().having(
                    (p0) => p0.listingUiState.currentState, 'listings ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.listingUiState.currentState, 'listings ui state is success', ViewState.success)
                    .having((p0) => p0.listingUiState.listing.isNotEmpty, 'colors list isn\'t empty check', true))),
      ]);
    });

    testWidgets('fetch listings failure test', (tester) async {
      when(() => mockCarDealershipRepo.fetchListing(const FilterQueryDto()))
          .thenAnswer((_) => Future.value(const Left(MessageException('error'))));

      container.listen(exploreHomeUiStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(exploreHomeUiStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(
            null, currState.copyWith(listingUiState: currState.listingUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>().having(
                    (p0) => p0.listingUiState.currentState, 'listings ui state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ExploreHomeUiState>()),
            any(
                that: isA<ExploreHomeUiState>()
                    .having((p0) => p0.listingUiState.currentState, 'listings ui state is error', ViewState.error)
                    .having((p0) => p0.listingUiState.error, 'listings error', isA<MessageException>()))),
      ]);
    });
  });
}
