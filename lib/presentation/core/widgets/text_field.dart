import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DealershipTextField extends StatefulWidget {
  const DealershipTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.label,
    this.labelStyle,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.obscureText = false,
    this.enabled = true,
    this.inputFormatters,
    this.onEditingComplete,
    this.onTap,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    EdgeInsets? contentPadding,
    this.upArrowOnPressed,
    this.downArrowOnPressed,
    this.onDonePressed,
  }) : _contentPadding = contentPadding;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool obscureText;
  final bool enabled;

  final String? label;
  final TextStyle? labelStyle;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;

  final EdgeInsets? _contentPadding;
  final String? hintText;
  final VoidCallback? upArrowOnPressed;
  final VoidCallback? downArrowOnPressed;
  final VoidCallback? onDonePressed;

  @override
  State<DealershipTextField> createState() => _DealershipTextFieldState();
}

class _DealershipTextFieldState extends State<DealershipTextField> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();

    focusNode.addListener(() {
      if (Platform.isIOS && focusNode.hasFocus && !widget.readOnly) {
        _KeyboardOverlay.showOverlay(context,
            upButtonPressed: widget.upArrowOnPressed,
            downButtonPressed: widget.downArrowOnPressed,
            onDonePress: widget.onDonePressed ?? FocusScope.of(context).unfocus);
      } else {
        if (_KeyboardOverlay.isShowing) {
          _KeyboardOverlay.removeOverlay();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: focusNode,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.surfaceTint,
          ),
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      validator: widget.validator,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        filled: true,
        labelText: widget.label,
        hintText: widget.hintText,
        labelStyle: widget.labelStyle ?? Theme.of(context).textTheme.labelMedium,
        contentPadding: widget._contentPadding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: const OutlineInputBorder(),
        prefixIcon: widget.prefix,
        fillColor: widget.readOnly ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1) : null,
        prefixIconConstraints: const BoxConstraints(maxWidth: 53),
        suffixIcon: widget.suffix,
        hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
        counter: const SizedBox.shrink(),
      ),
    );
  }
}

/// Wrapper for done keyboard overlay, used especially on ios to close
/// the keyboard
class _KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static get isShowing => _overlayEntry != null;

  static showOverlay(BuildContext context,
      {VoidCallback? upButtonPressed, VoidCallback? downButtonPressed, VoidCallback? onDonePress}) {
    if (_overlayEntry != null) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: _InputDoneView(
            upButtonPressed: upButtonPressed,
            downButtonPressed: downButtonPressed,
            onDonePress: onDonePress,
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  static removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

class _InputDoneView extends StatelessWidget {
  const _InputDoneView({Key? key, this.downButtonPressed, this.upButtonPressed, this.onDonePress}) : super(key: key);
  final VoidCallback? downButtonPressed;
  final VoidCallback? upButtonPressed;
  final VoidCallback? onDonePress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: CupertinoColors.extraLightBackgroundGray,
      height: 45,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Theme(
                data: ThemeData(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoButton(
                      onPressed: upButtonPressed,
                      child: Transform.rotate(
                        angle: -pi / 2,
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: downButtonPressed,
                      child: Transform.rotate(
                        angle: pi / 2,
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.only(right: 24.0, top: 10.0, bottom: 10.0),
                onPressed: () {
                  if (onDonePress != null) {
                    onDonePress?.call();
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                  Scrollable.ensureVisible(context, alignment: 0, duration: const Duration(seconds: 1));
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
