import 'dart:async';

import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/router.dart';
import '../../domain/core/dealership_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'ui_state_model_mutex.dart';

typedef DealershipUiStateRef<T extends DealershipUiStateModel<T>> = List<T>;

final _$vmWriteMutex = UiStateMutex();

enum UiState {
  idle,
  loading,
  success,
  error;

  bool get isLoading => this == UiState.loading;

  bool get isError => this == UiState.error;

  bool get isSuccess => this == UiState.success;

  bool get isIdle => this == UiState.idle;
}

@immutable
abstract base class DealershipUiStateModel<T extends DealershipUiStateModel<T>>
    extends Equatable {
  const DealershipUiStateModel({
    this.currentState = UiState.idle,
    this.error = const EmptyException(),
  });

  final UiState currentState;
  final DealershipException error;

  T copyWith({
    UiState? currentState,
    DealershipException? error,
  });

  @override
  bool? get stringify => true;

  @visibleForTesting
  @override
  List<Object?> get props => [currentState, error, ...otherProps];

  List<Object?> get otherProps => [];
}

@immutable
abstract base class DealershipFormUiStateModel<
    T extends DealershipFormUiStateModel<T>> extends DealershipUiStateModel<T> {
  const DealershipFormUiStateModel({
    super.currentState,
    super.error,
    this.showFormErrors = false,
  });

  final bool showFormErrors;

  @override
  T copyWith({
    UiState? currentState,
    DealershipException? error,
    bool? showFormErrors,
  });

  @override
  List<Object?> get props =>
      [...super.props, showFormErrors, ...super.otherProps];
}

Future<void> launch<E extends DealershipUiStateModel<E>>(
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

extension DealershipFormUiStatelX<T extends DealershipFormUiStateModel<T>>
    on T {
  T toggleFormErrors([bool? showFormError]) {
    return copyWith(showFormErrors: showFormError ?? !showFormErrors);
  }

  T reset() {
    return copyWith(
      currentState: UiState.idle,
      error: const EmptyException(),
      showFormErrors: false,
    );
  }
}

extension ViewModelX<T extends DealershipUiStateModel<T>> on T {
  DealershipUiStateRef<T> get reference => [this];

  T emitTo(DealershipUiStateRef<T> model) {
    return model.emit(this);
  }

  T reset() {
    return copyWith(
      currentState: UiState.idle,
      error: const EmptyException(),
    );
  }

  T sError(DealershipException error) {
    return copyWith(
      currentState: UiState.error,
      error: error,
    );
  }

  T sSuccess() {
    return copyWith(currentState: UiState.success);
  }

  T sLoading() {
    return copyWith(currentState: UiState.loading);
  }

  void displayError() async {
    if (currentState != UiState.error) return;
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

extension ViewModelRefX<T extends DealershipUiStateModel<T>>
    on DealershipUiStateRef<T> {
  DealershipUiStateRef<T> _assign(T value) => this..insert(0, value);

  T get _state => elementAt(0);

  T emit(T value) => _assign(value)._state;
}
