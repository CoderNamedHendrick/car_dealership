import 'package:equatable/equatable.dart';

final class SellerDto extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;

  const SellerDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  const SellerDto.empty() : this(id: '', name: '', email: '', phone: '');

  factory SellerDto.fromJson(Map<String, dynamic> json) => SellerDto(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
      };

  @override
  List<Object?> get props => [id, name, email, phone];
}
