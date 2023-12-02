import 'dart:io';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signals/signals_flutter.dart';
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
  late NegotiationViewModel _negotiationViewModel;
  late Function() disposeEmitter;

  @override
  void initState() {
    super.initState();

    _negotiationViewModel = locator();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      disposeEmitter =
          _negotiationViewModel.emitter.onSignalUpdate((prev, current) {
        if (current.currentState == ViewState.success) {
          messageController.text = current.currentChat.value
              .fold((left) => '', (right) => right.message);
        }
      });
    });
  }

  @override
  void dispose() {
    disposeEmitter();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onChanged: _negotiationViewModel.messageOnChanged,
                  prefix: () {
                    final imageFile =
                        _negotiationViewModel.state.currentChat.value.fold(
                            (left) => left.value.imageFile,
                            (right) => right.imageFile);

                    if (imageFile == null) return null;

                    return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.file(imageFile));
                  }(),
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () async {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);

                            if (image == null) return;
                            _negotiationViewModel
                                .fileOnChanged(File(image.path));
                          },
                          icon: const Icon(Icons.ios_share_rounded)),
                      IconButton(
                          onPressed: () async {
                            final image = await ImagePicker()
                                .pickImage(source: ImageSource.camera);

                            if (image == null) return;
                            _negotiationViewModel
                                .fileOnChanged(File(image.path));
                          },
                          icon: const Icon(Icons.camera_alt)),
                    ],
                  ),
                ),
              ),
              Constants.horizontalGutter,
              _negotiationViewModel.emitter.watch(context).isSendingMessage
                  ? const CircularProgressIndicator()
                  : IconButton.filled(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _negotiationViewModel.sendChat();
                      },
                      color: Theme.of(context).colorScheme.secondary,
                      icon: Icon(Icons.send,
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                    )
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
