// coverage:ignore-file
import '../../core/commons.dart';
import '../../core/repositories.dart';
import '../user_dto_x.dart';
import 'package:either_dart/either.dart';
import '../../../domain/domain.dart';

final class AuthRepositoryImpl implements AuthRepositoryInterface {
  const AuthRepositoryImpl();

  @override
  Future<Either<DealershipException, UserDto>> signInWithEmailPhoneAndPassword(
      SignInDto dto) async {
    await pseudoFetchDelay();
    final signInProfiles = usersSigningProfilesSignal.peek();

    for (var signInProfile in signInProfiles) {
      if ({signInProfile.email, signInProfile.phone}
              .contains(dto.emailOrPhone) &&
          dto.password == signInProfile.password) {
        userSigningSignal.value = signInProfile;
        return Right(signInProfile.user);
      }
    }

    return const Left(
        MessageException('Incorrect Email Address/Phone Number or Password.'));
  }

  @override
  Future<Either<DealershipException, UserDto>> signUpWithEmailPhoneAndPassword(
      SignUpDto dto) async {
    await pseudoFetchDelay();
    userSigningSignal.value = dto;
    usersSigningProfilesSignal.value =
        usersSigningProfilesSignal.peek().toList()..add(dto);

    return Right(dto.user);
  }

  @override
  Future<Either<DealershipException, UserDto>> signingWithFacebook() async {
    await pseudoFetchDelay();
    const result = SignUpDto(
        name: 'Facebook User',
        phone: '23490796590',
        email: 'johndoe@gmail.com',
        password: 'adknteoelehteore');

    userSigningSignal.value = result;
    return Right(result.user);
  }

  @override
  Future<Either<DealershipException, UserDto>> signingWithGoogle() async {
    await pseudoFetchDelay();
    const result = SignUpDto(
        name: 'Google User',
        phone: '23490796590',
        email: 'johnnydoe@gmail.com',
        password: 'dleiowlwienel');

    userSigningSignal.value = result;
    return Right(result.user);
  }

  @override
  Future<Either<DealershipException, UserDto>> fetchUser() async {
    await pseudoFetchDelay();

    return switch (userSigningSignal.peek()) {
      final user? => Right(user.user),
      _ => const Left(AuthRequiredException()),
    };
  }

  @override
  Future<Either<DealershipException, String>> logout() async {
    await pseudoFetchDelay();

    switch (userSigningSignal.peek()) {
      case final _?:
        userSigningSignal.value = null;
        return const Right('success');
      case _:
        return const Left(AuthRequiredException());
    }
  }
}
