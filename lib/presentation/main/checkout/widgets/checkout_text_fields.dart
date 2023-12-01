import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/widgets.dart';

class CardNumberTextField extends StatelessWidget {
  const CardNumberTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.maxLength,
    this.upArrowOnPressed,
    this.downArrowOnPressed,
    this.onDonePressed,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final int? maxLength;
  final VoidCallback? upArrowOnPressed;
  final VoidCallback? downArrowOnPressed;
  final VoidCallback? onDonePressed;

  @override
  Widget build(BuildContext context) {
    return DealershipTextField(
      controller: controller,
      focusNode: focusNode,
      upArrowOnPressed: upArrowOnPressed,
      downArrowOnPressed: downArrowOnPressed,
      onDonePressed: onDonePressed,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        const _CardNumberInputFormatter(),
      ],
      label: label,
      onChanged: onChanged,
      maxLength: maxLength,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      hintText: '0000 0000 0000 0000',
      suffix: const Icon(Icons.credit_card),
    );
  }
}

class CardExpiryTextField extends StatelessWidget {
  const CardExpiryTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.maxLength,
    this.upArrowOnPressed,
    this.downArrowOnPressed,
    this.onDonePressed,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final int? maxLength;
  final VoidCallback? upArrowOnPressed;
  final VoidCallback? downArrowOnPressed;
  final VoidCallback? onDonePressed;

  @override
  Widget build(BuildContext context) {
    return DealershipTextField(
      controller: controller,
      focusNode: focusNode,
      upArrowOnPressed: upArrowOnPressed,
      downArrowOnPressed: downArrowOnPressed,
      onDonePressed: onDonePressed,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        const _CardExpirationInputFormatter(),
      ],
      label: label,
      onChanged: onChanged,
      maxLength: maxLength,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      hintText: 'MM/YY',
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  const _CardNumberInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class _CardExpirationInputFormatter extends TextInputFormatter {
  const _CardExpirationInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'/'));
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newValueString.length && !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}
