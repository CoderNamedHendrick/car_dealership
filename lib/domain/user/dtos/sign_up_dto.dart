import 'package:equatable/equatable.dart';

final class SignUpDto extends Equatable {
  final String name;
  final String phone;
  final String email;
  final String password;

  const SignUpDto({required this.name, required this.phone, required this.email, required this.password});

  @override
  List<Object?> get props => [name, phone, email, password];
}
