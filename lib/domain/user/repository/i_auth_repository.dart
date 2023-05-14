import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/user/repository/auth_repository_impl.dart';
import '../dtos/sign_in_dto.dart';
import '../dtos/sign_up_dto.dart';
import 'package:either_dart/either.dart';
import '../dtos/user.dart';
import '../../core/dealership_exception.dart';

abstract interface class AuthRepositoryInterface {
  const AuthRepositoryInterface();

  Future<Either<DealershipException, UserDto>> signUpWithEmailPhoneAndPassword(SignUpDto dto);

  Future<Either<DealershipException, UserDto>> signInWithEmailPhoneAndPassword(SignInDto dto);

  Future<Either<DealershipException, UserDto>> signingWithGoogle();

  Future<Either<DealershipException, UserDto>> signingWithFacebook();
}

// serves as a service locator for the auth repository
final authRepositoryProvider = Provider.autoDispose<AuthRepositoryInterface>((ref) {
  return AuthRepositoryImpl(ref);
});
