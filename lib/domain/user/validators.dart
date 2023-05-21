import 'package:either_dart/either.dart';
import '../core/value_failure.dart';
import 'value_objects.dart';

Either<ValueFailure<String>, String> firstNameValidator(String value) {
  String failure = '';

  if (value.length < FirstName.minLength) {
    failure = 'Please enter ${FirstName.minLength} or more characters';
  }

  if (value.isEmpty) {
    failure = 'First name cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}

Either<ValueFailure<String>, String> lastNameValidator(String value) {
  String failure = '';

  if (value.length < LastName.minLength) {
    failure = 'Please enter ${LastName.minLength} or more characters';
  }
  if (value.isEmpty) {
    failure = 'Last name cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}

Either<ValueFailure<String>, String> emailValidator(String value) {
  const emailRegex = '[a-zA-Z0-9+._%-+]{1,256}'
      '\\@'
      '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}'
      '('
      '\\.'
      '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}'
      ')+';
  final regExp = RegExp(emailRegex);
  String failure = '';

  if (!regExp.hasMatch(value)) {
    failure = 'Please enter a valid email';
  }
  if (value.isEmpty) {
    failure = 'Email cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}

Either<ValueFailure<String>, String> phoneNumberValidator(String value) {
  String failure = '';
  final isValidNumber = RegExp('[0-9]{8,14}').hasMatch(value);

  if (!isValidNumber) {
    failure = 'Please enter a valid phone number';
  }

  if (value.isEmpty) {
    failure = 'Phone cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}

Either<ValueFailure<String>, String> passwordValidator(String value) {
  String failure = '';
  final isOneCapitalInPass = RegExp('[A-Z]{1,}').hasMatch(value);

  if (value.length < Password.minLength) {
    failure = 'Please enter ${Password.minLength} or more characters';
  }

  if (!isOneCapitalInPass) {
    failure = 'Please enter an uppercase character';
  }

  if (value.length < Password.minLength && !isOneCapitalInPass) {
    failure = 'Please enter ${Password.minLength} or more characters with 1 uppercase';
  }

  if (value.isEmpty) {
    failure = 'Password cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}

Either<ValueFailure<String>, String> emailOrPhoneValidator(String value) {
  String failure = '';

  if (value.isEmpty) {
    failure = 'Field cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}

Either<ValueFailure<Message>, Message> chatMessageValidator(Message value) {
  String failure = '';

  if (value.message.isEmpty && value.imageFile == null) {
    failure = 'Can\'t send empty message';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}
