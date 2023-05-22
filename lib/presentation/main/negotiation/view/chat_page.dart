import 'package:car_dealership/presentation/core/presentation_mixins/mixins.dart';
import '../../../core/widgets/widgets.dart';
import '../../../../application/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common.dart';
import '../../checkout/widgets/checkout_widget.dart';
import '../widgets/widgets.dart';

class NegotiationChatPage extends ConsumerStatefulWidget {
  static const route = '/home/listing/chat';

  const NegotiationChatPage({Key? key, this.listingDto, this.ongoingNegotiation}) : super(key: key);
  final CarListingDto? listingDto;
  final bool? ongoingNegotiation;

  @override
  ConsumerState<NegotiationChatPage> createState() => _NegotiationChatPageState();
}

class _NegotiationChatPageState extends ConsumerState<NegotiationChatPage> with MIntl {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      final listingUiState = ref.read(listingUiStateNotifierProvider);

      ref.read(negotiationStateNotifierProvider.notifier).initialiseChat(
            widget.listingDto ?? listingUiState.currentListing,
            ref.read(profileStateNotifierProvider).user!,
            widget.ongoingNegotiation ?? listingUiState.contactSellerUiState.isOngoingNegotiation,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final listing = ref.watch(negotiationStateNotifierProvider.select((value) => value.currentListing));
    final negotiation = ref.watch(negotiationStateNotifierProvider.select((value) => value.currentNegotiation));

    return OverScreenLoader(
      loading: ref.watch(negotiationStateNotifierProvider.select((value) => value.currentState)) == ViewState.loading,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          title: Text('Vehicle Negotiation', style: Theme.of(context).textTheme.titleMedium),
          centerTitle: true,
          actions: [
            if ({Availability.open, Availability.preOrder}.contains(listing.availability))
              TextButton(
                onPressed: () async {
                  final purchase = await showCheckoutDialog(
                    context,
                    config: CheckoutConfigDto(
                      user: ref.read(profileStateNotifierProvider).user!,
                      carListing: listing,
                      price: negotiation.price,
                    ),
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
