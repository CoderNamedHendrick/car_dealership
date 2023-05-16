import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/application.dart';
import '../../main/auth/view/auth_page.dart';

class LoginButton extends ConsumerWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final refresh = await Navigator.of(context, rootNavigator: true).pushNamed(Auth.route);

        if (refresh as bool? ?? false) {
          ref.read(profileStateNotifierProvider.notifier).fetchUser();
        }
      },
      child: const Text('Log in'),
    );
  }
}
