import 'package:car_dealership/presentation/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SentencesTextField extends StatelessWidget {
  const SentencesTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.maxLength,
    this.hintText,
    this.prefix,
    this.suffix,
    this.upArrowOnPressed,
    this.downArrowOnPressed,
    this.onDonePressed,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final int? maxLength;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
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
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      label: label,
      onChanged: onChanged,
      maxLines: null,
      maxLength: maxLength,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      prefix: prefix,
      suffix: suffix,
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.maxLength,
    this.hintText,
    this.upArrowOnPressed,
    this.downArrowOnPressed,
    this.onDonePressed,
  }) : super(key: key);
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final int? maxLength;
  final String? hintText;
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
      keyboardType: TextInputType.name,
      label: label,
      onChanged: onChanged,
      maxLines: 1,
      maxLength: maxLength,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
    );
  }
}

class NumberTextField extends StatelessWidget {
  const NumberTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.maxLength,
    this.hintText,
    this.upArrowOnPressed,
    this.downArrowOnPressed,
    this.onDonePressed,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final int? maxLength;
  final String? hintText;
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      label: label,
      onChanged: onChanged,
      maxLength: maxLength,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      hintText: hintText,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.upArrowOnPressed,
    this.downArrowOnPressed,
    this.onDonePressed,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;
  final VoidCallback? upArrowOnPressed;
  final VoidCallback? downArrowOnPressed;
  final VoidCallback? onDonePressed;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return DealershipTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textCapitalization: TextCapitalization.none,
      label: widget.label,
      upArrowOnPressed: widget.upArrowOnPressed,
      downArrowOnPressed: widget.downArrowOnPressed,
      onDonePressed: widget.onDonePressed,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      validator: widget.validator,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      obscureText: obscureText,
      suffix: IconButton(
        onPressed: () => setState(() {
          obscureText = !obscureText;
        }),
        icon: obscureText ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.upArrowOnPressed,
    this.downArrowOnPressed,
    this.onDonePressed,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
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
      keyboardType: TextInputType.emailAddress,
      label: label,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      hintText: 'johndoe@domain.com',
    );
  }
}
