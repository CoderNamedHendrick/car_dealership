import 'package:car_dealership/presentation/main/messages/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/widgets/widgets.dart';
import '../../negotiation/view/chat_page.dart';

class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      Future.wait([
        ref.read(messagesHomeStateNotifierProvider.notifier).fetchAllListing(),
        ref.read(messagesHomeStateNotifierProvider.notifier).fetchChats()
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Chats'),
        centerTitle: false,
      ),
      body: const Chats(),
    );
  }
}

class Chats extends ConsumerWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesUiState = ref.watch(messagesHomeStateNotifierProvider);

    if (messagesUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (messagesUiState.currentState == ViewState.error) {
      return switch (messagesUiState.error) {
        AuthRequiredException() => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  const AuthRequiredException().toString(),
                ),
                Constants.verticalGutter,
                const LoginButton(),
              ],
            ),
          ),
        _ => const SizedBox.shrink(),
      };
    }

    if (messagesUiState.currentState == ViewState.success) return const MessagesList();

    return const SizedBox.shrink();
  }
}

class MessagesList extends ConsumerWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final conversations = ref.watch(messagesHomeStateNotifierProvider).chats;
    if (conversations.isEmpty) {
      return const EmptyMessages();
    }
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        ref.read(messagesHomeStateNotifierProvider.notifier).fetchChats();
      },
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) => OngoingNegotiationsListTile(
          tileOnTap: (dto) {
            Navigator.of(context).pushNamed(
              NegotiationChatPage.route,
              arguments: {'listing': dto, 'isOngoingNegotiation': true},
            );
          },
          model: conversations[index],
        ),
      ),
    );
  }
}
