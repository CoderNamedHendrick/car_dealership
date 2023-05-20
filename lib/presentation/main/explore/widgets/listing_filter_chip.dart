import 'package:flutter/material.dart';
import '../../../core/common.dart';

class ListingFilterChip extends StatelessWidget {
  const ListingFilterChip({
    Key? key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.trailing,
    this.leading,
  }) : super(key: key);
  final String label;
  final bool selected;
  final Function(bool)? onSelected;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 2),
          selected ? trailing ?? const Icon(Icons.close) : const Icon(Icons.arrow_drop_down),
        ],
      ),
      labelPadding: EdgeInsets.zero,
      avatar: leading,
      selected: selected,
      showCheckmark: false,
      onSelected: (value) {
        onSelected?.call(selected);
      },
      visualDensity: const VisualDensity(vertical: -2, horizontal: -2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Constants.smallBorderRadius)),
      ),
    );
  }
}
