class AddressModel {
  AddressModel({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.zipCode,
    this.isDefault = false,
  });

  final String id;
  final String label, fullName, phone, addressLine, city, zipCode;
  final bool isDefault;

  String get formattedAddress => "$addressLine, $city $zipCode";

  AddressModel copyWith({
    String? label,
    String? fullName,
    String? phone,
    String? addressLine,
    String? city,
    String? zipCode,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
