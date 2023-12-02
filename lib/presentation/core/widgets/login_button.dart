import 'package:car_dealership/main.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../../application/application.dart';
import '../../main/auth/view/auth_page.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final profileVM = locator<ProfileViewModel>();
    return Watch(
      (context) {
        return IgnorePointer(
          ignoring: profileVM.profileState.currentState == ViewState.loading,
          child: ElevatedButton(
            onPressed: () async {
              final refresh = await Navigator.of(context, rootNavigator: true)
                  .pushNamed(Auth.route);

              if (refresh as bool? ?? false) {
                profileVM.fetchUser();
              }
            },
            child: const Text('Log in'),
          ),
        );
      },
    );
  }
}
