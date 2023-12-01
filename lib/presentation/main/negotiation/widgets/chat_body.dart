import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/application.dart';
import '../../../../domain/domain.dart';
import '../../../core/common.dart';

class ChatBody extends ConsumerStatefulWidget {
  const ChatBody({super.key});

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
  const ChatBubble({super.key, required ChatDto chat})
      : _model = chat;
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
