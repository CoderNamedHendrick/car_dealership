import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/main/auth/view/log_in.dart';
import 'package:car_dealership/presentation/main/auth/view/sign_up.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  static const route = '/auth';

  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cars 101',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Constants.verticalGutter),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(Login.route),
                child: const Text('Log in'),
              ),
              const SizedBox(height: Constants.verticalGutter),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(SignUp.route),
                child: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
