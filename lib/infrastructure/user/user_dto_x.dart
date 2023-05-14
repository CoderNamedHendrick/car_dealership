import 'package:car_dealership/domain/user/dtos/sign_up_dto.dart';
import 'package:car_dealership/domain/user/dtos/user.dart';

extension UserDtoX on SignUpDto {
  UserDto get user {
    return UserDto(id: 'id-$name', name: name, email: email, phone: phone);
  }
}
