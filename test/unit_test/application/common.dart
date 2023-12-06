import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/router.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class RiverpodListener<T> extends Mock {
  void call(T? previous, T next);
}

class SignalListener<T> extends Mock {
  void call(T? previous, T next);
}

class MockAuthRepo extends Mock implements AuthRepositoryInterface {}

class MockChatRepo extends Mock implements ChatRepositoryInterface {}

class MockCarDealerShipRepo extends Mock implements CarDealerShipInterface {}

class MockCarListingRepo extends Mock implements CarListingInterface {}

class UnitTestApp extends StatelessWidget {
  const UnitTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(navigatorKey: AppRouter.navKey, home: const Scaffold());
  }
}

void setupTestLocator() {
  // register repositories
  GetIt.I.registerSingleton<AuthRepositoryInterface>(MockAuthRepo());
  GetIt.I.registerSingleton<ChatRepositoryInterface>(MockChatRepo());
  GetIt.I.registerSingleton<CarDealerShipInterface>(MockCarDealerShipRepo());
  GetIt.I.registerSingleton<CarListingInterface>(MockCarListingRepo());

  // register view-models
  GetIt.I.registerLazySingleton(() => SignInViewModel(locator()));
  GetIt.I.registerLazySingleton(() => SignUpViewModel(locator()));
  GetIt.I.registerLazySingleton(() => CheckoutViewModel(locator()));
  GetIt.I.registerLazySingleton(() => FilterViewModel(locator()));
  GetIt.I.registerLazySingleton(() => MessagesViewModel(locator(), locator()));
  GetIt.I.registerLazySingleton(() => NegotiationViewModel(locator()));
  GetIt.I.registerLazySingleton(() => PurchasesHomeViewModel(locator()));
  GetIt.I.registerLazySingleton(() => ProfileViewModel(locator(), locator()));
  GetIt.I.registerLazySingleton(() => ListingViewModel(locator(), locator()));
  GetIt.I.registerLazySingleton(() => ExploreHomeViewModel(locator()));
  GetIt.I.registerLazySingleton(() => AdminActionsViewModel(locator()));
}
