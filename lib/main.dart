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
  _setupViewModels();
  runApp(const ProviderScope(child: App()));
}

void _setupViewModels() {}
