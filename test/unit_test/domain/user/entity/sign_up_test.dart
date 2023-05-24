import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sign up domain entity test suite', () {
    late SignUpWithEmailNPhone signUpForm;

    setUpAll(() => signUpForm = SignUpWithEmailNPhone.empty());

    test('Initialising and assigning of values', () {
      expect(signUpForm.failureOption.isSome(), true);

      signUpForm = signUpForm.copyWith(
        firstName: FirstName('John'),
        lastName: LastName('Doe'),
        emailAddress: Email('johndoe@gmail.com'),
        password: Password('JohnDoe'),
        phone: Phone('0906789832'),
      );
    });

    test('Checking the values contained in the entity', () {
      expect(signUpForm.failureOption.isNone(), true);

      expect(signUpForm.firstName.getOrCrash(), 'John');
      expect(signUpForm.lastName.getOrCrash(), 'Doe');
      expect(signUpForm.emailAddress.getOrCrash(), 'johndoe@gmail.com');
      expect(signUpForm.password.getOrCrash(), 'JohnDoe');
      expect(signUpForm.phone.getOrCrash(), '0906789832');
    });
  });
}
