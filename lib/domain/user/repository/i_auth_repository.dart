import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/infrastructure.dart';
import 'package:either_dart/either.dart';
import '../../core/core.dart';
import '../user_domain.dart';

abstract interface class AuthRepositoryInterface {
  const AuthRepositoryInterface();

  Future<Either<DealershipException, UserDto>> fetchUser();

  Future<Either<DealershipException, UserDto>> signUpWithEmailPhoneAndPassword(SignUpDto dto);

  Future<Either<DealershipException, UserDto>> signInWithEmailPhoneAndPassword(SignInDto dto);

  Future<Either<DealershipException, UserDto>> signingWithGoogle();

  Future<Either<DealershipException, UserDto>> signingWithFacebook();

  Future<Either<DealershipException, String>> logout();
}

// serves as a service locator for the auth repository
final authRepositoryProvider = Provider.autoDispose<AuthRepositoryInterface>((ref) {
  return AuthRepositoryImpl(ref);
});
