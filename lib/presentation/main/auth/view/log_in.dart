import 'package:car_dealership/presentation/core/widgets/over_screen_loader.dart';
import 'package:car_dealership/presentation/core/widgets/text_fields.dart';

import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/widgets/text_field.dart';
import 'sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/or_divider.dart';
import '../widget/social_buttons.dart';
import 'package:flutter/material.dart';

class Login extends ConsumerWidget {
  static const route = '/auth/sign-in';

  const Login({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(signInStateNotifierProvider.select((value) => value.currentState), (previous, next) {
      if (next == ViewState.success) {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      }
    });
    return OverScreenLoader(
      loading: ref.watch(signInStateNotifierProvider.select((value) => value.currentState)) == ViewState.loading,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
          child: Form(
            autovalidateMode: ref.watch(signInStateNotifierProvider.select((value) => value.showFormErrors))
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: FocusTraversalGroup(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Log In', style: Theme.of(context).textTheme.titleMedium),
                    RichText(
                      text: TextSpan(style: Theme.of(context).textTheme.labelSmall, children: [
                        const TextSpan(text: 'New to Cars101?'),
                        TextSpan(
                          text: ' Create an account.',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).pushReplacementNamed(SignUp.route),
                        ),
                      ]),
                    ),
                    Constants.verticalGutter,
                    SocialButton(
                      social: Social.google,
                      onTap: ref.read(signInStateNotifierProvider.notifier).continueWithGoogleOnTap,
                    ),
                    Constants.verticalGutter,
                    SocialButton(
                      social: Social.facebook,
                      onTap: ref.read(signInStateNotifierProvider.notifier).continueWithFacebookOnTap,
                    ),
                    const OrDivider(),
                    DealershipTextField(
                      label: 'Email Address or Phone Number',
                      onChanged: ref.read(signInStateNotifierProvider.notifier).emailOrPhoneOnChanged,
                      validator: (_) => ref
                          .read(signInStateNotifierProvider)
                          .signInForm
                          .emailOrPhone
                          .failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).nextFocus,
                      downArrowOnPressed: FocusScope.of(context).nextFocus,
                    ),
                    Constants.verticalGutter,
                    PasswordTextField(
                      label: 'Password',
                      onChanged: ref.read(signInStateNotifierProvider.notifier).passwordOnChanged,
                      validator: (_) => ref
                          .read(signInStateNotifierProvider)
                          .signInForm
                          .password
                          .failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).unfocus,
                      upArrowOnPressed: FocusScope.of(context).previousFocus,
                    ),
                    Constants.verticalGutter,
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        ref.read(signInStateNotifierProvider.notifier).loginOnTap();
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
