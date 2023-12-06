import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/router.dart';
import '../../domain/core/dealership_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

typedef DealershipUiStateModelRef<T extends DealershipUiStateModel> = List<T>;

enum ViewState { idle, loading, success, error }

@immutable
abstract base class DealershipUiStateModel extends Equatable {
  const DealershipUiStateModel();

  ViewState get currentState;

  DealershipException get error;

  @override
  bool? get stringify => true;
}

Future<void> launch<E extends DealershipUiStateModel>(
  DealershipUiStateModelRef<E> model,
  Future<void> Function(DealershipUiStateModelRef<E> model) function, {
  bool displayError = true,
}) async {
  await Future.sync(() => function(model));

  if (model.isEmpty || !displayError) return;
  model._state.displayError();
}

extension ViewModelX<T extends DealershipUiStateModel> on T {
  DealershipUiStateModelRef<T> get ref => [this];

  void displayError() async {
    if (currentState != ViewState.error) return;
    assert(error is! EmptyException, 'Please pass appropriate exception');

    final context = AppRouter.navKey.currentContext!;
    final snackbar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: Constants.snackBarDur,
      content: Text(
        error.toString(),
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.surface),
      ),
    );

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackbar);
  }
}

extension ViewModelRefX<T extends DealershipUiStateModel>
    on DealershipUiStateModelRef<T> {
  DealershipUiStateModelRef<T> _assign(T value) => this..insert(0, value);

  T get _state => elementAt(0);

  T emit(T value) => _assign(value)._state;
}
