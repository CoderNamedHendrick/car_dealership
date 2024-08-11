import 'dart:async';

import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/router.dart';
import '../../domain/core/dealership_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'ui_state_mutex.dart';

typedef DealershipUiStateRef<T extends DealershipUiState<T>> = List<T>;

final _$vmWriteMutex = UiStateMutex();

enum ViewState {
  idle,
  loading,
  success,
  error;

  bool get isLoading => this == ViewState.loading;

  bool get isError => this == ViewState.error;

  bool get isSuccess => this == ViewState.success;

  bool get isIdle => this == ViewState.idle;
}

@immutable
abstract base class DealershipUiState<T extends DealershipUiState<T>>
    extends Equatable {
  const DealershipUiState({
    this.currentState = ViewState.idle,
    this.error = const EmptyException(),
  });

  final ViewState currentState;
  final DealershipException error;

  T copyWith({
    ViewState? currentState,
    DealershipException? error,
  });

  @override
  bool? get stringify => true;

  @visibleForTesting
  @override
  List<Object?> get props => [currentState, error, ...otherProps];

  List<Object?> get otherProps => [];
}

Future<void> launch<E extends DealershipUiState<E>>(
  DealershipUiStateRef<E> model,
  FutureOr<void> Function(DealershipUiStateRef<E> model) function, {
  bool displayError = true,
  bool Function(E state) canDisplayError = _kDisplayError,
}) async {
  final result = await _$vmWriteMutex.protect<E>(() async {
    await function(model);
    return model._state;
  });

  if (result.reference.isEmpty || !displayError || !(canDisplayError(result))) {
    return;
  }
  result.displayError();
}

bool _kDisplayError([_]) => true;

extension ViewModelX<T extends DealershipUiState<T>> on T {
  DealershipUiStateRef<T> get reference => [this];

  T emitTo(DealershipUiStateRef<T> model) {
    return model.emit(this);
  }

  T reset() {
    return copyWith(
      currentState: ViewState.idle,
      error: const EmptyException(),
    );
  }

  T sError(DealershipException error) {
    return copyWith(
      currentState: ViewState.error,
      error: error,
    );
  }

  T sSuccess() {
    return copyWith(currentState: ViewState.success);
  }

  T sLoading() {
    return copyWith(currentState: ViewState.loading);
  }

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

extension ViewModelRefX<T extends DealershipUiState<T>>
    on DealershipUiStateRef<T> {
  DealershipUiStateRef<T> _assign(T value) => this..insert(0, value);

  T get _state => elementAt(0);

  T emit(T value) => _assign(value)._state;
}
