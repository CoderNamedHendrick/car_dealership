import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/main/auth/view/log_in.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/widgets/widgets.dart';
import '../widget/or_divider.dart';
import '../widget/social_buttons.dart';

class SignUp extends StatefulWidget {
  static const route = '/auth/sign-up';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late SignUpViewModel _viewModel;
  late Function() disposeEmitter;

  @override
  void initState() {
    super.initState();

    _viewModel = locator();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      disposeEmitter = _viewModel.emitter.onSignalUpdate((prev, current) {
        if (current.currentState == ViewState.success) {
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
        }
      });
    });
  }

  @override
  void dispose() {
    disposeEmitter();
    super.dispose();
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
                    Text('Create Account',
                        style: Theme.of(context).textTheme.titleMedium),
                    RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.labelSmall,
                          children: [
                            const TextSpan(text: 'Have an account?'),
                            TextSpan(
                              text: ' Log In.',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context)
                                    .pushReplacementNamed(Login.route),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: NameTextField(
                            label: 'First Name',
                            onChanged: _viewModel.firstNameOnChanged,
                            validator: (_) => _viewModel
                                .state.signUpForm.firstName.failureOrNone
                                .fold(() => null, (value) => value.message),
                            onEditingComplete: FocusScope.of(context).nextFocus,
                            downArrowOnPressed:
                                FocusScope.of(context).nextFocus,
                          ),
                        ),
                        Constants.horizontalGutter,
                        Flexible(
                          child: NameTextField(
                            label: 'Last Name',
                            onChanged: _viewModel.lastNameOnChanged,
                            validator: (_) => _viewModel
                                .state.signUpForm.lastName.failureOrNone
                                .fold(() => null, (value) => value.message),
                            onEditingComplete: FocusScope.of(context).nextFocus,
                            downArrowOnPressed:
                                FocusScope.of(context).nextFocus,
                            upArrowOnPressed:
                                FocusScope.of(context).previousFocus,
                          ),
                        ),
                      ],
                    ),
                    Constants.verticalGutter,
                    EmailTextField(
                      label: 'Email Address',
                      onChanged: _viewModel.emailOnChanged,
                      validator: (_) => _viewModel
                          .state.signUpForm.emailAddress.failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).nextFocus,
                      downArrowOnPressed: FocusScope.of(context).nextFocus,
                      upArrowOnPressed: FocusScope.of(context).previousFocus,
                    ),
                    Constants.verticalGutter,
                    NumberTextField(
                      label: 'Phone Number',
                      onChanged: _viewModel.phoneNumberOnChanged,
                      validator: (_) => _viewModel
                          .state.signUpForm.phone.failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).nextFocus,
                      downArrowOnPressed: FocusScope.of(context).nextFocus,
                      upArrowOnPressed: FocusScope.of(context).previousFocus,
                    ),
                    Constants.verticalGutter,
                    PasswordTextField(
                      label: 'Password',
                      onChanged: _viewModel.passwordOnChanged,
                      validator: (_) => _viewModel
                          .state.signUpForm.password.failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).unfocus,
                      upArrowOnPressed: FocusScope.of(context).previousFocus,
                    ),
                    Constants.verticalGutter,
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _viewModel.createAccountOnTap();
                      },
                      child: const Text('Create Account'),
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
