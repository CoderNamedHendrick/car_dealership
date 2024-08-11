import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/application.dart';

class EmptyMessages extends StatelessWidget {
  const EmptyMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) => Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.labelMedium,
            children: [
              TextSpan(text: '💬\n', style: Theme.of(context).textTheme.displayLarge),
              const TextSpan(text: 'No chats available\n'),
              WidgetSpan(
                child: TextButton(
                  onPressed: ref.read(messagesHomeStateNotifierProvider.notifier).fetchChats,
                  child: const Text('Refresh Chats'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
