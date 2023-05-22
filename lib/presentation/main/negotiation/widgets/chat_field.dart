import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/widgets/widgets.dart';

class ChatField extends ConsumerStatefulWidget {
  const ChatField({super.key});

  @override
  ConsumerState<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends ConsumerState<ChatField> {
  final TextEditingController messageController = TextEditingController();

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: SentencesTextField(
                  controller: messageController,
                  onChanged: ref.read(negotiationStateNotifierProvider.notifier).messageOnChanged,
                  prefix: () {
                    final imageFile = ref
                        .read(negotiationStateNotifierProvider.select((value) => value.currentChat))
                        .value
                        .fold((left) => left.value.imageFile, (right) => right.imageFile);

                    if (imageFile == null) return null;

                    return Padding(padding: const EdgeInsets.all(4.0), child: Image.file(imageFile));
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        ref.read(negotiationStateNotifierProvider.notifier).sendChat();
                      },
                      color: Theme.of(context).colorScheme.secondary,
                      icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primaryContainer),
                    )
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
