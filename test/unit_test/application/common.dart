import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/presentation/core/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class RiverpodListener<T> extends Mock {
  void call(T? previous, T next);
}

class MockAuthRepo extends Mock implements AuthRepositoryInterface {}

class MockChatRepo extends Mock implements ChatRepositoryInterface {}

class MockCarDealerShipRepo extends Mock implements CarDealerShipInterface {}

class MockCarListingRepo extends Mock implements CarListingInterface {}

class UnitTestApp extends StatelessWidget {
  const UnitTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(navigatorKey: AppRouter.navKey, home: const ProviderScope(child: Scaffold()));
  }
}
