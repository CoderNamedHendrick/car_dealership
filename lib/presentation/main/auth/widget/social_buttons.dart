import 'package:car_dealership/presentation/core/common.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Social { facebook, google }

class SocialButton extends StatelessWidget {
  const SocialButton({
    Key? key,
    required this.social,
    this.onTap,
  }) : super(key: key);
  final Social social;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.primaryContainer),
            borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: Constants.horizontalGutter),
        alignment: Alignment.center,
        child: switch (social) {
          Social.facebook => const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.facebook, color: Colors.blueAccent),
                SizedBox(width: Constants.horizontalGutter),
                Text('Continue with facebook'),
              ],
            ),
          Social.google => const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.google),
                SizedBox(width: Constants.horizontalGutter),
                Text('Continue with Google'),
              ],
            ),
        },
      ),
    );
  }
}
