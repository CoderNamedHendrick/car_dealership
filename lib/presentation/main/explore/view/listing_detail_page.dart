import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/not_signed_in_alert.dart';
import 'package:car_dealership/presentation/core/widgets/over_screen_loader.dart';
import 'package:car_dealership/presentation/main/negotiation/view/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/presentation_mixins/mixins.dart';
import '../../checkout/widgets/checkout_widget.dart';
import '../widgets/widget.dart';

class ListingDetailPage extends ConsumerStatefulWidget {
  static const route = '/home/car-listing/detail';

  const ListingDetailPage({Key? key, required CarListingDto listingDto})
      : _model = listingDto,
        super(key: key);
  final CarListingDto _model;

  @override
  ConsumerState<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends ConsumerState<ListingDetailPage> with MIntl {
  late final PageController _photosController;
  late int page;

  @override
  void initState() {
    super.initState();
    page = 0;
    _photosController = PageController(viewportFraction: 0.92);

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.read(listingUiStateNotifierProvider.notifier).initialiseListing(widget._model);
      page = ref.read(listingUiStateNotifierProvider.select((value) => value.currentListing)).photos.length ~/ 2;
      _photosController.jumpToPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(profileStateNotifierProvider.select((value) => value.user))?.isAdmin ?? false;
    final model = ref.watch(listingUiStateNotifierProvider.select((value) => value.currentListing));

    ref.listen(profileStateNotifierProvider.select((value) => value.user), (previous, next) {
      if (previous != next) {
        Future.wait([
          ref.read(listingUiStateNotifierProvider.notifier).getListingReviews(),
          ref.read(listingUiStateNotifierProvider.notifier).getIsSavedListing(),
          ref.read(listingUiStateNotifierProvider.notifier).checkIfNegotiationAvailable(),
        ]);
      }
    });
    return OverScreenLoader(
      loading: ref.watch(profileStateNotifierProvider.select((value) => value.currentState)) == ViewState.loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: Text(
            '${model.make} ${model.model}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: false,
          actions: [
            if ({Availability.open, Availability.preOrder}.contains(model.availability) && !isAdmin)
              TextButton(
                onPressed: () async {
                  if (ref.read(profileStateNotifierProvider).user == null) {
                    await showNotSignedInAlert(context);
                    return;
                  }

                  final purchase = await showCheckoutDialog(
                    context,
                    config: CheckoutConfigDto(user: ref.read(profileStateNotifierProvider).user!, carListing: model),
                  );

                  if (purchase) {
                    if (!mounted) return;
                    await Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (_) => const PurchaseSuccessPage()));

                    if (!mounted) return;
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    ref.read(profileStateNotifierProvider.notifier).fetchUser();
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
                          (index) => ListingPhoto(selected: page == index, photoUrl: model.photos[index]),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0.92, -1),
                        child: _AvailabilityPill(availability: model.availability),
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
                  padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
                  child: Column(
                    children: [
                      if (!isAdmin)
                        UserListingOptions(
                          contactOnTap: () async {
                            if (ref.read(profileStateNotifierProvider).user == null) {
                              await showNotSignedInAlert(context);
                              return;
                            }

                            await Navigator.of(context).pushNamed(NegotiationChatPage.route);
                            ref.read(listingUiStateNotifierProvider.notifier).initialiseListing(widget._model);
                          },
                        ),
                      _Info('Manufacturer', model.make),
                      _Info('Model', model.model),
                      _Info('Year', model.year.toString()),
                      _Info('Price', currencyFormat.format(model.price)),
                      _Info('Location', model.location),
                      _Info('Mileage', '${mileageFormat.format(model.mileage)}KM'),
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
  const _Info(
    this.title,
    this.info, {
    Key? key,
  }) : super(key: key);
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
