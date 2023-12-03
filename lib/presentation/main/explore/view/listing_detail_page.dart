import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/not_signed_in_alert.dart';
import 'package:car_dealership/presentation/core/widgets/over_screen_loader.dart';
import 'package:car_dealership/presentation/main/negotiation/view/chat_page.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../../../domain/domain.dart';
import '../../../core/presentation_mixins/mixins.dart';
import '../../checkout/widgets/checkout_widget.dart';
import '../widgets/widget.dart';

class ListingDetailPage extends StatefulWidget {
  static const route = '/home/car-listing/detail';

  const ListingDetailPage({super.key, required CarListingDto listingDto})
      : _model = listingDto;
  final CarListingDto _model;

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> with MIntl {
  late final PageController _photosController;
  late int page;
  late ProfileViewModel _profileViewModel;
  late ListingViewModel _listingViewModel;
  late Function() disposeEmitter;

  @override
  void initState() {
    super.initState();
    _profileViewModel = locator<ProfileViewModel>();
    _listingViewModel = locator();
    page = 0;
    _photosController = PageController(viewportFraction: 0.92);

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      disposeEmitter = _profileViewModel.profileEmitter
          .select((value) => value.user)
          .onSignalUpdate((prev, current) {
        if (prev != current) {
          Future.wait([
            _listingViewModel.getListingReviews(),
            _listingViewModel.getIsSavedListing(),
            _listingViewModel.checkIfNegotiationAvailable(),
          ]);
        }
      });

      _listingViewModel.initialiseListing(widget._model);
      page = _listingViewModel.currentListing.photos.length ~/ 2;
      _photosController.jumpToPage(page);
    });
  }

  @override
  void dispose() {
    disposeEmitter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _profileViewModel.profileEmitter
            .select((value) => value.user)
            .watch(context)
            ?.isAdmin ??
        false;
    final model = _listingViewModel.currentListingEmitter.watch(context);

    return OverScreenLoader(
      loading: _profileViewModel.profileEmitter.watch(context).currentState ==
          ViewState.loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: Text(
            '${model.make} ${model.model}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: false,
          actions: [
            if ({Availability.open, Availability.preOrder}
                    .contains(model.availability) &&
                !isAdmin)
              TextButton(
                onPressed: () async {
                  if (_profileViewModel.profileState.user == null) {
                    await showNotSignedInAlert(context);
                    return;
                  }

                  final purchase = await showCheckoutDialog(
                    context,
                    config: CheckoutConfigDto(
                        user: _profileViewModel.profileState.user!,
                        carListing: model),
                  );

                  if (purchase) {
                    if (!mounted) return;
                    await Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (_) => const PurchaseSuccessPage()));

                    if (!mounted) return;
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    _profileViewModel.fetchUser();
                  }
                },
                child: const Text('Purchase'),
              ),
            Constants.horizontalGutter,
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const SizedBox(height: Constants.verticalMargin),
                SizedBox(
                  height: constraints.maxHeight * 0.5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _photosController,
                        onPageChanged: (value) => setState(() => page = value),
                        children: List.generate(
                          model.photos.length,
                          (index) => ListingPhoto(
                              selected: page == index,
                              photoUrl: model.photos[index]),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0.92, -1),
                        child:
                            _AvailabilityPill(availability: model.availability),
                      ),
                      const Align(
                        alignment: Alignment(0.92, 1),
                        child: ListingReviewWidget(),
                      ),
                    ],
                  ),
                ),
                Constants.verticalGutter,
                ListIndexIndicator(length: model.photos.length, index: page),
                Constants.verticalGutter,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.horizontalMargin),
                  child: Column(
                    children: [
                      if (!isAdmin)
                        UserListingOptions(
                          contactOnTap: () async {
                            if (_profileViewModel.profileState.user == null) {
                              await showNotSignedInAlert(context);
                              return;
                            }

                            await Navigator.of(context)
                                .pushNamed(NegotiationChatPage.route);
                            _listingViewModel.initialiseListing(widget._model);
                          },
                        ),
                      _Info('Manufacturer', model.make),
                      _Info('Model', model.model),
                      _Info('Year', model.year.toString()),
                      _Info('Price', currencyFormat.format(model.price)),
                      _Info('Location', model.location),
                      _Info('Mileage',
                          '${mileageFormat.format(model.mileage)}KM'),
                      _Info('Color', model.color),
                      _Info('Transmission', model.transmission.json),
                      _Info('Fuel Type', model.fuelType.json),
                      _Info('Features', model.features.join(', ')),
                      _Info('Description', model.description),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _AvailabilityPill extends StatelessWidget {
  const _AvailabilityPill({required this.availability});

  final Availability availability;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constants.horizontalGutter16.width!,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        borderRadius: const BorderRadius.all(Radius.circular(2000)),
      ),
      child: Text(
        availability.json,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.title, this.info);

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(title)),
          Constants.horizontalGutter,
          Expanded(flex: 4, child: Text(info)),
        ],
      ),
    );
  }
}
