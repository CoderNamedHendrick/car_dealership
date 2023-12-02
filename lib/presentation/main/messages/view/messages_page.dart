import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/main/messages/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/widgets/widgets.dart';
import '../../negotiation/view/chat_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late MessagesViewModel _messagesViewModel;

  @override
  void initState() {
    super.initState();

    _messagesViewModel = locator();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      Future.wait([
        _messagesViewModel.fetchAllListing(),
        _messagesViewModel.fetchChats()
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

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    final messagesViewModel = locator<MessagesViewModel>();
    final messagesUiState = messagesViewModel.emitter.watch(context);

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

    if (messagesUiState.currentState == ViewState.success) {
      return const MessagesList();
    }

    return const SizedBox.shrink();
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final messagesViewModel = locator<MessagesViewModel>();
    final conversations = messagesViewModel.emitter.watch(context).chats;

    if (conversations.isEmpty) {
      return const EmptyMessages();
    }
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        messagesViewModel.fetchChats();
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
