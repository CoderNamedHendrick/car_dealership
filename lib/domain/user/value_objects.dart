import 'dart:io';

import '../domain.dart';
import 'package:either_dart/either.dart';
import 'validators.dart';

class FirstName extends ValueObject<String> {
  static int minLength = 3;

  @override
  final Either<ValueFailure<String>, String> value;

  factory FirstName(String input) => FirstName._(firstNameValidator(input));

  const FirstName._(this.value);
}

class LastName extends ValueObject<String> {
  static int minLength = 3;

  @override
  final Either<ValueFailure<String>, String> value;

  factory LastName(String input) => LastName._(lastNameValidator(input));

  const LastName._(this.value);
}

class Email extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Email(String input) => Email._(emailValidator(input));

  const Email._(this.value);
}

class Phone extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Phone(String input) => Phone._(phoneNumberValidator(input));

  const Phone._(this.value);
}

class Password extends ValueObject<String> {
  static int minLength = 6;

  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) => Password._(passwordValidator(input));

  const Password._(this.value);
}

class EmailOrPhone extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailOrPhone(String input) => EmailOrPhone._(emailOrPhoneValidator(input));

  const EmailOrPhone._(this.value);
}

class ChatMessage extends ValueObject<Message> {
  @override
  final Either<ValueFailure<Message>, Message> value;

  factory ChatMessage(String textInput, [File? imageFile]) =>
      ChatMessage._(chatMessageValidator(Message(message: textInput, imageFile: imageFile)));

  const ChatMessage._(this.value);
}

final class Message {
  final String message;
  final File? imageFile;

  const Message({required this.message, this.imageFile});

  ChatDto toDto() => ChatDto(isUser: true, message: message, imageFile: imageFile);
}
