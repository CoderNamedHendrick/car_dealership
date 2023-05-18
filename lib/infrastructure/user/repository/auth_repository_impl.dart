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
    final signInProfiles = ref.read(usersSigningProfilesProvider);

    for (var signInProfile in signInProfiles) {
      if ({signInProfile.email, signInProfile.phone}.contains(dto.emailOrPhone) &&
          dto.password == signInProfile.password) {
        ref.read(userSigningProvider.notifier).update((state) => signInProfile);
        return Right(signInProfile.user);
      }
    }

    return const Left(MessageException('Incorrect Email Address/Phone Number or Password.'));
  }

  @override
  Future<Either<DealershipException, UserDto>> signUpWithEmailPhoneAndPassword(SignUpDto dto) async {
    await pseudoFetchDelay();
    ref.read(userSigningProvider.notifier).update((state) => dto);
    ref.read(usersSigningProfilesProvider.notifier).update((state) => state..add(dto));
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

  @override
  Future<Either<DealershipException, String>> logout() async {
    await pseudoFetchDelay();

    switch (ref.read(userSigningProvider)) {
      case final _?:
        ref.read(userSigningProvider.notifier).update((state) => null);
        return const Right('success');
      case _:
        return const Left(AuthRequiredException());
    }
  }
}
