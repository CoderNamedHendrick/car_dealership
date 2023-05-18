import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/common.dart';

class UserNameAndAvatar extends StatelessWidget {
  const UserNameAndAvatar({Key? key, required this.userName}) : super(key: key);
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(minRadius: 40, maxRadius: 40, child: FaIcon(FontAwesomeIcons.user)),
        Constants.verticalGutter,
        Text(userName, textAlign: TextAlign.center),
      ],
    );
  }
}
