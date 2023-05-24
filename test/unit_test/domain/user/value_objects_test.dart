import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Value Object tests for Auth Feature', () {
    test('First Name Value Object tests', () {
      FirstName firstName = FirstName('');

      expect(firstName.failureOrNone.isSome(), true); // ensure there's a validation error
      expect(firstName.failureOrNone.fold(() => null, (value) => value.message), 'First name cannot be empty');

      firstName = FirstName('Se');

      expect(firstName.failureOrNone.isSome(), true);
      expect(
        firstName.failureOrNone.fold(() => null, (value) => value.message),
        'Please enter ${FirstName.minLength} or more characters',
      );

      firstName = FirstName('John');
      expect(firstName.failureOrNone.isNone(), true); // no validation error
      expect(firstName.getOrCrash(), 'John');
    });

    test('Last Name Value Object tests', () {
      LastName lastName = LastName('');

      expect(lastName.failureOrNone.isSome(), true); // ensure there's a validation error
      expect(lastName.failureOrNone.fold(() => null, (value) => value.message), 'Last name cannot be empty');

      lastName = LastName('Se');

      expect(lastName.failureOrNone.isSome(), true);
      expect(
        lastName.failureOrNone.fold(() => null, (value) => value.message),
        'Please enter ${LastName.minLength} or more characters',
      );

      lastName = LastName('John');
      expect(lastName.failureOrNone.isNone(), true); // no validation error
      expect(lastName.getOrCrash(), 'John');
    });

    test('Email Value Object test', () {
      Email email = Email('');

      expect(email.failureOrNone.isSome(), true);
      expect(email.failureOrNone.fold(() => null, (value) => value.message), 'Email cannot be empty');

      email = Email('jonny');
      expect(email.failureOrNone.isSome(), true);
      expect(email.failureOrNone.fold(() => null, (value) => value.message), 'Please enter a valid email');

      email = Email('johnDoe@gmail.com');
      expect(email.failureOrNone.isNone(), true);
      expect(email.getOrCrash(), 'johnDoe@gmail.com');
    });

    test('Phone Number Value Object test', () {
      Phone phone = Phone('');

      expect(phone.failureOrNone.isSome(), true);
      expect(phone.failureOrNone.fold(() => null, (value) => value.message), 'Phone cannot be empty');

      phone =
          Phone('sleekejenel'); // ensuring it throws a validation error if alphabets are inserted instead of numbers
      expect(phone.failureOrNone.isSome(), true);
      expect(phone.failureOrNone.fold(() => null, (value) => value.message), 'Please enter a valid phone number');

      phone = Phone('0905482042');
      expect(phone.failureOrNone.isNone(), true);
      expect(phone.getOrCrash(), '0905482042');
    });

    test('Password Value Object test', () {
      Password password = Password('');
      expect(password.failureOrNone.isSome(), true);
      expect(password.failureOrNone.fold(() => null, (value) => value.message), 'Password cannot be empty');

      password = Password('sen');
      expect(password.failureOrNone.isSome(), true);
      expect(
        password.failureOrNone.fold(() => null, (value) => value.message),
        'Please enter ${Password.minLength} or more characters with 1 uppercase',
      );

      password = Password('Sen');
      expect(password.failureOrNone.isSome(), true);
      expect(
        password.failureOrNone.fold(() => null, (value) => value.message),
        'Please enter ${Password.minLength} or more characters',
      );

      password = Password('sebastine');
      expect(password.failureOrNone.isSome(), true);
      expect(
        password.failureOrNone.fold(() => null, (value) => value.message),
        'Please enter an uppercase character',
      );

      password = Password('Hendrick');
      expect(password.failureOrNone.isNone(), true);
      expect(password.getOrCrash(), 'Hendrick');
    });
  });
}
