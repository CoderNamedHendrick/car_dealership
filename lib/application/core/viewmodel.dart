import 'package:car_dealership/presentation/core/router.dart';
import '../../domain/core/dealership_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

typedef DealershipViewModelRef<T extends DealershipViewModel> = List<T>;

enum ViewState { idle, loading, success, error }

@immutable
abstract class DealershipViewModel extends Equatable {
  const DealershipViewModel();

  ViewState get currentState;

  DealershipException get exception;

  @override
  bool? get stringify => true;
}

Future<void> launch<E extends DealershipViewModel>(
  DealershipViewModelRef<E> model,
  Future<void> Function(DealershipViewModelRef<E> model) function, {
  bool displayError = true,
  ErrorConfiguration configuration = const ErrorConfiguration(),
}) async {
  await Future.sync(() => function(model));

  if (model.isEmpty || !displayError) return;
  model._state.displayError(configuration);
}

class ErrorConfiguration {
  final String? title;
  final Duration flushBarDuration;

  const ErrorConfiguration({
    this.title,
    this.flushBarDuration = const Duration(milliseconds: 2200),
  });
}

extension ViewModelX<T extends DealershipViewModel> on T {
  DealershipViewModelRef<T> get ref => [this];

  void displayError([
    ErrorConfiguration configuration = const ErrorConfiguration(),
  ]) async {
    if (currentState != ViewState.error) return;
    assert(exception is! EmptyException, 'Please pass appropriate exception');

    final context = AppRouter.navKey.currentContext!;
    final snackbar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      content: Text(
        exception.toString(),
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
