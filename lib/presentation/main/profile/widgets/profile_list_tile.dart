import 'package:flutter/material.dart';
import '../../../core/common.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({Key? key, required this.title, this.leading, this.onTap}) : super(key: key);
  final Widget? leading;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      tileColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Constants.borderRadius))),
      onTap: onTap,
    );
  }
}
