import '../../core/commons.dart';
import '../../core/repositories.dart';
import '../user_dto_x.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/domain.dart';

final class AuthRepositoryImpl implements AuthRepositoryInterface {
  const AuthRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<Either<DealershipException, UserDto>> signInWithEmailPhoneAndPassword(SignInDto dto) async {
    await pseudoFetchDelay();
    final signInUserInfo = ref.read(userSigningProvider);

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
    ref.read(userSigningProvider.notifier).update((state) => dto);

    return Right(dto.user);
  }

  @override
  Future<Either<DealershipException, UserDto>> signingWithFacebook() async {
    await pseudoFetchDelay();
    const result = SignUpDto(
        name: 'Facebook User', phone: '23490796590', email: 'johndoe@gmail.com', password: 'adknteoelehteore');

    ref.read(userSigningProvider.notifier).update((state) => result);

    return Right(result.user);
  }

  @override
  Future<Either<DealershipException, UserDto>> signingWithGoogle() async {
    await pseudoFetchDelay();
    const result =
        SignUpDto(name: 'Google User', phone: '23490796590', email: 'johnnydoe@gmail.com', password: 'dleiowlwienel');

    ref.read(userSigningProvider.notifier).update((state) => result);

    return Right(result.user);
  }

  @override
  Future<Either<DealershipException, UserDto>> fetchUser() async {
    await pseudoFetchDelay();

    return switch (ref.read(userSigningProvider)) {
      final user? => Right(user.user),
      _ => const Left(AuthRequiredException()),
    };
  }
}
