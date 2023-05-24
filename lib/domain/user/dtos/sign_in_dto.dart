import 'package:equatable/equatable.dart';

final class SignInDto extends Equatable {
  final String emailOrPhone;
  final String password;

  const SignInDto({required this.emailOrPhone, required this.password});

  @override
  List<Object?> get props => [emailOrPhone, password];
}
