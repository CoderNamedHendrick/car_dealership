import '../dtos/sign_in_dto.dart';
import '../value_objects.dart';
import 'package:car_dealership/utility/option.dart';
import 'package:equatable/equatable.dart';
import '../../core/value_failure.dart';

class SignInWithEmailPhone extends Equatable {
  final EmailOrPhone emailOrPhone;
  final Password password;

  const SignInWithEmailPhone({required this.emailOrPhone, required this.password});

  factory SignInWithEmailPhone.empty() => SignInWithEmailPhone(emailOrPhone: EmailOrPhone(''), password: Password(''));

  SignInWithEmailPhone copyWith({EmailOrPhone? emailOrPhone, Password? password}) {
    return SignInWithEmailPhone(
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      password: password ?? this.password,
    );
  }

  SignInDto toDto() {
    return SignInDto(emailOrPhone: emailOrPhone.getOrCrash(), password: password.getOrCrash());
  }

  Option<ValueFailure<dynamic>> get failureOption => emailOrPhone.failureOrNone.fold(
        () => password.failureOrNone.fold(() => const None(), (value) => Some(value)),
        (value) => Some(value),
      );

  @override
  List<Object?> get props => [emailOrPhone, password];
}
