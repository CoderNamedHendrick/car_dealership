import 'dart:io';

import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/presentation/core/presentation_mixins/mixins.dart';
import 'package:car_dealership/presentation/core/widgets/over_screen_loader.dart';
import 'package:car_dealership/presentation/core/widgets/text_field.dart';
import 'package:car_dealership/presentation/main/negotiation/widgets/change_price_dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../application/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common.dart';
import '../../checkout/widgets/checkout_widget.dart';

class NegotiationChatPage extends ConsumerStatefulWidget {
  static const route = '/home/listing/chat';

  const NegotiationChatPage({Key? key, this.listingDto, this.ongoingNegotiation}) : super(key: key);
  final CarListingDto? listingDto;
  final bool? ongoingNegotiation;

  @override
  ConsumerState<NegotiationChatPage> createState() => _NegotiationChatPageState();
}

class _NegotiationChatPageState extends ConsumerState<NegotiationChatPage> with MIntl {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      final listingUiState = ref.read(listingUiStateNotifierProvider);

      ref.read(negotiationStateNotifierProvider.notifier).initialiseChat(
            widget.listingDto ?? listingUiState.currentListing,
            ref.read(profileStateNotifierProvider).user!,
            widget.ongoingNegotiation ?? listingUiState.contactSellerUiState.isOngoingNegotiation,
          );
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(negotiationStateNotifierProvider, (previous, next) {
      if (next.currentState == ViewState.success) {
        messageController.text = next.currentChat.value.fold((left) => '', (right) => right.message);
      }
    });

    final listing = ref.watch(negotiationStateNotifierProvider.select((value) => value.currentListing));
    final negotiation = ref.watch(negotiationStateNotifierProvider.select((value) => value.currentNegotiation));
    final currentChat = ref.watch(negotiationStateNotifierProvider.select((value) => value.currentChat));
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
        body: Column(
          children: [
            InkResponse(
              onTap: () async {
                final result = await showChangePriceDialog(context, currentPrice: negotiation.price);

                if (result == null) return;
                ref.read(negotiationStateNotifierProvider.notifier).updateNegotiationPrice(result);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: Constants.horizontalMargin, vertical: Constants.verticalGutter.height!),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                    text: 'Current Price: ${currencyFormat.format(negotiation.price)}. Tap to change',
                  ),
                ),
              ),
            ),
            const Expanded(child: ChatBody()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DealershipTextField(
                          controller: messageController,
                          onChanged: ref.read(negotiationStateNotifierProvider.notifier).messageOnChanged,
                          maxLines: null,
                          prefix: () {
                            final imageFile =
                                currentChat.value.fold((left) => left.value.imageFile, (right) => right.imageFile);

                            if (imageFile == null) return null;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Image.file(imageFile),
                            );
                          }(),
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

                                    if (image == null) return;
                                    ref.read(negotiationStateNotifierProvider.notifier).fileOnChanged(File(image.path));
                                  },
                                  icon: const Icon(Icons.ios_share_rounded)),
                              IconButton(
                                  onPressed: () async {
                                    final image = await ImagePicker().pickImage(source: ImageSource.camera);

                                    if (image == null) return;
                                    ref.read(negotiationStateNotifierProvider.notifier).fileOnChanged(File(image.path));
                                  },
                                  icon: const Icon(Icons.camera_alt)),
                            ],
                          ),
                        ),
                      ),
                      Constants.horizontalGutter,
                      ref.watch(negotiationStateNotifierProvider.select((value) => value.isSendingMessage))
                          ? const CircularProgressIndicator()
                          : IconButton.filled(
                              onPressed: ref.read(negotiationStateNotifierProvider.notifier).sendChat,
                              color: Theme.of(context).colorScheme.secondary,
                              icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primaryContainer),
                            )
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatBody extends ConsumerStatefulWidget {
  const ChatBody({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends ConsumerState<ChatBody> {
  final chatsController = ScrollController();

  void _scrollToBottom() {
    chatsController.animateTo(
      chatsController.position.maxScrollExtent,
      duration: Constants.shortAnimationDur,
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(negotiationStateNotifierProvider.select((value) => value.currentNegotiation.chats), (previous, next) {
      if (previous != next) {
        _scrollToBottom();
      }
    });
    final chats = ref.watch(negotiationStateNotifierProvider.select((value) => value.currentNegotiation.chats));

    if (chats.isNotEmpty) {
      return Scrollbar(
        controller: chatsController,
        child: Padding(
          padding: const EdgeInsets.all(Constants.horizontalMargin / 2),
          child: ListView.separated(
            controller: chatsController,
            itemCount: chats.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => ChatBubble(chat: chats[index]),
            separatorBuilder: (context, index) {
              if (index == 0 && chats.length <= 1) return Constants.verticalGutter;

              if (index == 0 && chats.length > 1 && chats[index].isUser && chats[index + 1].isUser) {
                return Constants.verticalGutter - SizedBox(height: Constants.verticalGutter.height! / 1.3);
              }

              if (chats[index - 1].isUser && chats[index].isUser) {
                return Constants.verticalGutter - SizedBox(height: Constants.verticalGutter.height! / 1.3);
              }

              return Constants.verticalGutter;
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({Key? key, required ChatDto chat})
      : _model = chat,
        super(key: key);
  final ChatDto _model;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _model.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
          ),
          padding: const EdgeInsets.all(Constants.horizontalMargin / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_model.imageFile != null) ...[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
                  child: Image.file(
                    _model.imageFile!,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(_model.message, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
