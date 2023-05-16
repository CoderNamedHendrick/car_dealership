import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DealershipTextField extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      readOnly: readOnly,
      obscureText: obscureText,
      enabled: enabled,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.surfaceTint,
          ),
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        filled: true,
        labelText: label,
        hintText: hintText,
        labelStyle: labelStyle ?? Theme.of(context).textTheme.labelMedium,
        contentPadding: _contentPadding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: const OutlineInputBorder(),
        prefixIcon: prefix,
        fillColor: readOnly ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1) : null,
        prefixIconConstraints: const BoxConstraints(maxWidth: 53),
        suffixIcon: suffix,
        hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
        counterText: maxLength?.toString(),
        counterStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.surfaceTint,
            ),
      ),
    );
  }
}
