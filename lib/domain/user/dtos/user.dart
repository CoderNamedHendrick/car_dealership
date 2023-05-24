final class UserDto {
  final String id;
  final String name;
  final String email;
  final String phone;

  const UserDto.empty() : this(id: '', name: '', email: '', phone: '');

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
}
