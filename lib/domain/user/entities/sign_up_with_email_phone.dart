import 'package:car_dealership/domain/core/value_failure.dart';
import 'package:car_dealership/domain/user/dtos/sign_up_dto.dart';
import 'package:car_dealership/utility/option.dart';
import '../value_objects.dart';
import 'package:equatable/equatable.dart';

class SignUpWithEmailNPhone extends Equatable {
  final FirstName firstName;
  final LastName lastName;
  final Email emailAddress;
  final Phone phone;
  final Password password;

  factory SignUpWithEmailNPhone.empty() => SignUpWithEmailNPhone(
        firstName: FirstName(''),
        lastName: LastName(''),
        emailAddress: Email(''),
        password: Password(''),
        phone: Phone(''),
      );

  const SignUpWithEmailNPhone({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.emailAddress,
    required this.password,
  });

  SignUpWithEmailNPhone copyWith({
    FirstName? firstName,
    LastName? lastName,
    Email? emailAddress,
    Password? password,
    Phone? phone,
  }) {
    return SignUpWithEmailNPhone(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
    );
  }

  SignUpDto toDto() {
    return SignUpDto(
      name: '${firstName.getOrCrash()} ${lastName.getOrCrash()}',
      email: emailAddress.getOrCrash(),
      password: password.getOrCrash(),
      phone: phone.getOrCrash(),
    );
  }

  Option<ValueFailure<dynamic>> get failureOption => firstName.failureOrNone.fold(
        () => lastName.failureOrNone.fold(
          () => emailAddress.failureOrNone.fold(
            () => password.failureOrNone.fold(
              () => phone.failureOrNone.fold(
                () => const None(),
                (value) => Some(value),
              ),
              (value) => Some(value),
            ),
            (value) => Some(value),
          ),
          (value) => Some(value),
        ),
        (value) => Some(value),
      );

  @override
  List<Object?> get props => [firstName, lastName, emailAddress, password, phone];

  @override
  bool? get stringify => true;
}
