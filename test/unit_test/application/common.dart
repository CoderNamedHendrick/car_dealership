import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return MaterialApp(
        navigatorKey: AppRouter.navKey,
        home: const ProviderScope(child: Scaffold()));
  }
}

void setupTestLocator() {
  // initialise repositories
  GetIt.I.registerSingleton<AuthRepositoryInterface>(MockAuthRepo());
  GetIt.I.registerSingleton<ChatRepositoryInterface>(MockChatRepo());
  GetIt.I.registerSingleton<CarDealerShipInterface>(MockCarDealerShipRepo());
  GetIt.I.registerSingleton<CarListingInterface>(MockCarListingRepo());

  // initialise view-models
  GetIt.I.registerLazySingleton(
    () => SignInViewModel(locator()),
    dispose: (model) => model.dispose(),
  );
  GetIt.I.registerLazySingleton(
    () => SignUpViewModel(locator()),
    dispose: (model) => model.dispose(),
  );
  GetIt.I.registerLazySingleton(
    () => CheckoutViewModel(locator()),
    dispose: (model) => model.dispose(),
  );
}
