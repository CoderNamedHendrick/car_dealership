import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/application.dart';
import '../../main/auth/view/auth_page.dart';

Future<void> showNotSignedInAlert(BuildContext context) async {
  return await showDialog(context: context, builder: (_) => const _NotSignedInAlert());
}

class _NotSignedInAlert extends ConsumerWidget {
  const _NotSignedInAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return AlertDialog(
      title: const Text('User unavailable'),
      content: const Text('No signed in user detected, please sign in'),
      actions: [
        TextButton(
          onPressed: () async {
            final refresh = await Navigator.of(context, rootNavigator: true).pushNamed(Auth.route);

            if (refresh as bool? ?? false) {
              ref.read(profileStateNotifierProvider.notifier).fetchUser();
            }

            // ignore: use_build_context_synchronously
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
          child: const Text('Log in'),
        ),
      ],
    );
  }
}
