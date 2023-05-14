import 'package:car_dealership/domain/core/dealership_exception.dart';
import 'package:car_dealership/domain/user/dtos/sign_in_dto.dart';
import 'package:car_dealership/domain/user/dtos/sign_up_dto.dart';
import 'package:car_dealership/domain/user/dtos/user.dart';
import 'package:car_dealership/domain/user/repository/i_auth_repository.dart';
import 'package:car_dealership/infrastructure/core/commons.dart';
import 'package:car_dealership/infrastructure/user/user_dto_x.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AuthRepositoryImpl implements AuthRepositoryInterface {
  const AuthRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<Either<DealershipException, UserDto>> signInWithEmailPhoneAndPassword(SignInDto dto) async {
    await pseudoFetchDelay();
    final signInUserInfo = ref.read(_userSigningProvider);

    switch (signInUserInfo) {
      case final user?:
        if (dto.emailOrPhone != user.email || dto.emailOrPhone != user.phone) {
          return const Left(MessageException('User does not exist, please sign up'));
        }
        return Right(user.user);
      case _:
        return const Left(MessageException('User does not exist, please sign up'));
    }
  }

  @override
  Future<Either<DealershipException, UserDto>> signUpWithEmailPhoneAndPassword(SignUpDto dto) async {
    await pseudoFetchDelay();
    ref.read(_userSigningProvider.notifier).update((state) => dto);

    return Right(dto.user);
  }

  @override
  Future<Either<DealershipException, UserDto>> signingWithFacebook() async {
    await pseudoFetchDelay();
    const result = SignUpDto(
        name: 'Facebook User', phone: '23490796590', email: 'johndoe@gmail.com', password: 'adknteoelehteore');

    ref.read(_userSigningProvider.notifier).update((state) => result);

    return Right(result.user);
  }

  @override
  Future<Either<DealershipException, UserDto>> signingWithGoogle() async {
    await pseudoFetchDelay();
    const result =
        SignUpDto(name: 'Google User', phone: '23490796590', email: 'johnnydoe@gmail.com', password: 'dleiowlwienel');

    ref.read(_userSigningProvider.notifier).update((state) => result);

    return Right(result.user);
  }
}

// serves as our user db
final _userSigningProvider = StateProvider<SignUpDto?>((ref) {
  return null;
});
