import 'package:either_dart/either.dart';
import '../../core/core.dart';
import '../user_domain.dart';

abstract interface class AuthRepositoryInterface {
  Future<Either<DealershipException, UserDto>> fetchUser();

  Future<Either<DealershipException, UserDto>> signUpWithEmailPhoneAndPassword(
      SignUpDto dto);

  Future<Either<DealershipException, UserDto>> signInWithEmailPhoneAndPassword(
      SignInDto dto);

  Future<Either<DealershipException, UserDto>> signingWithGoogle();

  Future<Either<DealershipException, UserDto>> signingWithFacebook();

  Future<Either<DealershipException, String>> logout();
}
