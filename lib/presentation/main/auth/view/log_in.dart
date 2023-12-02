import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/widgets/over_screen_loader.dart';
import 'package:car_dealership/presentation/core/widgets/text_fields.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:signals/signals_flutter.dart';

import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/widgets/text_field.dart';
import 'sign_up.dart';
import 'package:flutter/gestures.dart';
import '../widget/or_divider.dart';
import '../widget/social_buttons.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const route = '/auth/sign-in';

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SignInViewModel _viewModel;
  late Function() disposeEmitter;

  @override
  void initState() {
    super.initState();

    _viewModel = locator();

    disposeEmitter = _viewModel.emitter.onSignalUpdate((prev, current) {
      if (current.currentState == ViewState.success) {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverScreenLoader(
      loading:
          _viewModel.emitter.watch(context).currentState == ViewState.loading,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.horizontalMargin),
          child: Form(
            autovalidateMode: _viewModel.emitter.watch(context).showFormErrors
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: FocusTraversalGroup(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Log In',
                        style: Theme.of(context).textTheme.titleMedium),
                    RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.labelSmall,
                          children: [
                            const TextSpan(text: 'New to Cars101?'),
                            TextSpan(
                              text: ' Create an account.',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context)
                                    .pushReplacementNamed(SignUp.route),
                            ),
                          ]),
                    ),
                    Constants.verticalGutter,
                    SocialButton(
                      social: Social.google,
                      onTap: _viewModel.continueWithGoogleOnTap,
                    ),
                    Constants.verticalGutter,
                    SocialButton(
                      social: Social.facebook,
                      onTap: _viewModel.continueWithFacebookOnTap,
                    ),
                    const OrDivider(),
                    DealershipTextField(
                      label: 'Email Address or Phone Number',
                      onChanged: _viewModel.emailOrPhoneOnChanged,
                      validator: (_) => _viewModel
                          .state.signInForm.emailOrPhone.failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).nextFocus,
                      downArrowOnPressed: FocusScope.of(context).nextFocus,
                    ),
                    Constants.verticalGutter,
                    PasswordTextField(
                      label: 'Password',
                      onChanged: _viewModel.passwordOnChanged,
                      validator: (_) => _viewModel
                          .state.signInForm.password.failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).unfocus,
                      upArrowOnPressed: FocusScope.of(context).previousFocus,
                    ),
                    Constants.verticalGutter,
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        _viewModel.loginOnTap();
                      },
                      child: const Text('Log In'),
                    ),
                    Constants.keyboardVerticalGutter,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
