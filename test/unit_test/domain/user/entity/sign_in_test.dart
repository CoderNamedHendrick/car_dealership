import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sign in domain entity test suite', () {
    late SignInWithEmailPhone signInForm;

    setUpAll(() => signInForm = SignInWithEmailPhone.empty());

    test('Initialising and assigning values to the domain', () {
      expect(signInForm.failureOption.isSome(), true);

      signInForm = signInForm.copyWith(
        emailOrPhone: EmailOrPhone('johndoe@gmail.com'),
        password: Password('JohnDoe'),
      );
    });

    test('Checking the values in the entity', () {
      expect(signInForm.failureOption.isNone(), true);

      expect(signInForm.emailOrPhone.getOrCrash(), 'johndoe@gmail.com');
      expect(signInForm.password.getOrCrash(), 'JohnDoe');
    });
  });
}
