import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class PurchaseSuccessPage extends StatelessWidget {
  const PurchaseSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.horizontalMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Vehicle Purchased Successfully',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.surface),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Constants.verticalGutter.height!),
                child: CarLoader(
                    customColor:
                        Theme.of(context).colorScheme.primaryContainer),
              ),
              const Rating(),
              MaterialButton(
                onPressed: Navigator.of(context).pop,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int rating = 0;
  late ListingViewModel _listingViewModel;

  @override
  void initState() {
    super.initState();

    _listingViewModel = locator();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      _listingViewModel.purchaseRatingUiStateEmitter
          .onSignalUpdate((previous, next) {
        if (next.currentState == ViewState.success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Car rated successfully'),
            backgroundColor: Colors.green,
            duration: Constants.snackBarDur,
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratePurchaseUiState =
        _listingViewModel.purchaseRatingUiStateEmitter.watch(context);

    return IgnorePointer(
      ignoring: ratePurchaseUiState.currentState == ViewState.loading,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RepaintBoundary(
            child: Wrap(
              children: List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () => setState(() => rating = index + 1),
                  child: Icon(
                    Icons.star,
                    color: (index + 1) <= rating
                        ? Colors.yellowAccent.shade400
                        : null,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _listingViewModel.ratePurchase(rating),
            child: ratePurchaseUiState.currentState == ViewState.loading
                ? const CupertinoActivityIndicator()
                : const Text('Rate'),
          ),
        ],
      ),
    );
  }
}
