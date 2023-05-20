import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/router.dart';
import '../../domain/core/dealership_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

typedef DealershipViewModelRef<T extends DealershipViewModel> = List<T>;

enum ViewState { idle, loading, success, error }

@immutable
abstract base class DealershipViewModel extends Equatable {
  const DealershipViewModel();

  ViewState get currentState;

  DealershipException get error;

  @override
  bool? get stringify => true;
}

Future<void> launch<E extends DealershipViewModel>(
  DealershipViewModelRef<E> model,
  Future<void> Function(DealershipViewModelRef<E> model) function, {
  bool displayError = true,
}) async {
  await Future.sync(() => function(model));

  if (model.isEmpty || !displayError) return;
  model._state.displayError();
}

extension ViewModelX<T extends DealershipViewModel> on T {
  DealershipViewModelRef<T> get ref => [this];

  void displayError() async {
    if (currentState != ViewState.error) return;
    assert(error is! EmptyException, 'Please pass appropriate exception');

    final context = AppRouter.navKey.currentContext!;
    final snackbar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: Constants.snackBarDur,
      content: Text(
        error.toString(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.surface),
      ),
    );

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackbar);
  }
}

extension ViewModelRefX<T extends DealershipViewModel> on DealershipViewModelRef<T> {
  DealershipViewModelRef<T> _assign(T value) => this..insert(0, value);

  T get _state => elementAt(0);

  T emit(T value) => _assign(value)._state;
}
