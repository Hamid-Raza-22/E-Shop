class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.imageSrc,
  });

  final String name, email, phone, imageSrc;

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? imageSrc,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageSrc: imageSrc ?? this.imageSrc,
    );
  }
}
