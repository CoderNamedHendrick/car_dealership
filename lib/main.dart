import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/infrastructure/infrastructure.dart';
import 'package:car_dealership/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

T locator<T extends Object>({
  dynamic param1,
  dynamic param2,
  String? instanceName,
  Type? type,
}) =>
    GetIt.I.get(
      param1: param1,
      param2: param2,
      instanceName: instanceName,
      type: type,
    );

void main() {
  _setupLocator();
  runApp(const ProviderScope(child: App()));
}

void _setupLocator() {
  // register repositories
  GetIt.I
      .registerSingleton<AuthRepositoryInterface>(const AuthRepositoryImpl());
  GetIt.I
      .registerSingleton<ChatRepositoryInterface>(const ChatRepositoryImpl());
  GetIt.I.registerSingleton<CarDealerShipInterface>(const CarDealerShipImpl());
  GetIt.I.registerSingleton<CarListingInterface>(const CarListingImpl());

  // register view-models
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
  GetIt.I.registerLazySingleton(
    () => FilterViewModel(locator()),
    dispose: (model) => model.dispose(),
  );
}
