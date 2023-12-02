import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/presentation_mixins/mixins.dart';
import 'package:signals/signals_flutter.dart';
import '../../../../domain/domain.dart';
import '../../../core/widgets/widgets.dart';
import '../../../../application/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common.dart';
import '../../checkout/widgets/checkout_widget.dart';
import '../widgets/widgets.dart';

class NegotiationChatPage extends ConsumerStatefulWidget {
  static const route = '/home/listing/chat';

  const NegotiationChatPage(
      {super.key, this.listingDto, this.ongoingNegotiation});

  final CarListingDto? listingDto;
  final bool? ongoingNegotiation;

  @override
  ConsumerState<NegotiationChatPage> createState() =>
      _NegotiationChatPageState();
}

class _NegotiationChatPageState extends ConsumerState<NegotiationChatPage>
    with MIntl {
  late NegotiationViewModel _negotiationViewModel;
  late ProfileViewModel _profileViewModel;

  @override
  void initState() {
    super.initState();

    _negotiationViewModel = locator<NegotiationViewModel>();
    _profileViewModel = locator<ProfileViewModel>();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      final listingUiState = ref.read(listingUiStateNotifierProvider);

      _negotiationViewModel.initialiseChat(
        widget.listingDto ?? listingUiState.currentListing,
        _profileViewModel.profileState.user!,
        widget.ongoingNegotiation ??
            listingUiState.contactSellerUiState.isOngoingNegotiation,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverScreenLoader(
      loading: _negotiationViewModel.emitter.watch(context).currentState ==
          ViewState.loading,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          title: Text('Vehicle Negotiation',
              style: Theme.of(context).textTheme.titleMedium),
          centerTitle: true,
          actions: [
            if ({Availability.open, Availability.preOrder}.contains(
                _negotiationViewModel.emitter
                    .watch(context)
                    .currentListing
                    .availability))
              TextButton(
                onPressed: () async {
                  final purchase = await showCheckoutDialog(
                    context,
                    config: CheckoutConfigDto(
                      user: _profileViewModel.profileState.user!,
                      carListing: _negotiationViewModel.emitter
                          .watch(context)
                          .currentListing,
                      price: _negotiationViewModel.emitter
                          .watch(context)
                          .currentNegotiation
                          .price,
                    ),
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
        body: const Column(
          children: [
            ChangeNegotiationPriceTile(),
            Expanded(child: ChatBody()),
            ChatField(),
            KeyboardOverlayDistance(),
          ],
        ),
      ),
    );
  }
}
