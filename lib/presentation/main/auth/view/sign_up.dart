import 'package:car_dealership/presentation/main/auth/view/log_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/widgets/widgets.dart';
import '../widget/or_divider.dart';
import '../widget/social_buttons.dart';

class SignUp extends ConsumerWidget {
  static const route = '/auth/sign-up';

  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(signUpStateNotifierProvider.select((value) => value.currentState), (previous, next) {
      if (next == ViewState.success) {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      }
    });
    return OverScreenLoader(
      loading: ref.watch(signUpStateNotifierProvider.select((value) => value.currentState)) == ViewState.loading,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
          child: Form(
            autovalidateMode: ref.watch(signUpStateNotifierProvider.select((value) => value.showFormErrors))
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: FocusTraversalGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Create Account', style: Theme.of(context).textTheme.titleMedium),
                  RichText(
                    text: TextSpan(style: Theme.of(context).textTheme.labelSmall, children: [
                      const TextSpan(text: 'Have an account?'),
                      TextSpan(
                        text: ' Log In.',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).pushReplacementNamed(Login.route),
                      ),
                    ]),
                  ),
                  Constants.verticalGutter,
                  SocialButton(
                    social: Social.google,
                    onTap: ref.read(signUpStateNotifierProvider.notifier).continueWithGoogleOnTap,
                  ),
                  Constants.verticalGutter,
                  SocialButton(
                    social: Social.facebook,
                    onTap: ref.read(signUpStateNotifierProvider.notifier).continueWithFacebookOnTap,
                  ),
                  const OrDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: DealershipTextField(
                          label: 'First Name',
                          onChanged: ref.read(signUpStateNotifierProvider.notifier).firstNameOnChanged,
                          validator: (_) => ref
                              .read(signUpStateNotifierProvider)
                              .signUpForm
                              .firstName
                              .failureOrNone
                              .fold(() => null, (value) => value.message),
                          onEditingComplete: FocusScope.of(context).nextFocus,
                        ),
                      ),
                      Constants.horizontalGutter,
                      Flexible(
                        child: DealershipTextField(
                          label: 'Last Name',
                          onChanged: ref.read(signUpStateNotifierProvider.notifier).lastNameOnChanged,
                          validator: (_) => ref
                              .read(signUpStateNotifierProvider)
                              .signUpForm
                              .lastName
                              .failureOrNone
                              .fold(() => null, (value) => value.message),
                          onEditingComplete: FocusScope.of(context).nextFocus,
                        ),
                      ),
                    ],
                  ),
                  Constants.verticalGutter,
                  DealershipTextField(
                    label: 'Email Address',
                    onChanged: ref.read(signUpStateNotifierProvider.notifier).emailOnChanged,
                    validator: (_) => ref
                        .read(signUpStateNotifierProvider)
                        .signUpForm
                        .emailAddress
                        .failureOrNone
                        .fold(() => null, (value) => value.message),
                    onEditingComplete: FocusScope.of(context).nextFocus,
                  ),
                  Constants.verticalGutter,
                  DealershipTextField(
                    label: 'Phone Number',
                    onChanged: ref.read(signUpStateNotifierProvider.notifier).phoneNumberOnChanged,
                    validator: (_) => ref
                        .read(signUpStateNotifierProvider)
                        .signUpForm
                        .phone
                        .failureOrNone
                        .fold(() => null, (value) => value.message),
                    onEditingComplete: FocusScope.of(context).nextFocus,
                  ),
                  Constants.verticalGutter,
                  DealershipTextField(
                    label: 'Password',
                    onChanged: ref.read(signUpStateNotifierProvider.notifier).passwordOnChanged,
                    validator: (_) => ref
                        .read(signUpStateNotifierProvider)
                        .signUpForm
                        .password
                        .failureOrNone
                        .fold(() => null, (value) => value.message),
                    onEditingComplete: FocusScope.of(context).unfocus,
                  ),
                  Constants.verticalGutter,
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      ref.read(signUpStateNotifierProvider.notifier).createAccountOnTap();
                    },
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
