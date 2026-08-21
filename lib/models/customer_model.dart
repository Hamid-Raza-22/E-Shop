import 'package:cloud_firestore/cloud_firestore.dart';

/// A storefront customer as the dashboard sees them.
///
/// [ordersCount] and [totalSpent] are denormalised counters maintained by
/// `CustomerService.upsertFromOrder` with `FieldValue.increment`, so the
/// customers list never has to aggregate the whole orders collection.
class CustomerModel {
  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.createdAt,
    this.ordersCount = 0,
    this.totalSpent = 0,
    this.isBlocked = false,
  });

  final String id;
  final String name, email;
  final String? phone, photoUrl;
  final DateTime? createdAt;
  final int ordersCount;
  final double totalSpent;
  final bool isBlocked;

  /// Average value of the orders this customer has placed so far.
  double get averageOrderValue =>
      ordersCount == 0 ? 0 : totalSpent / ordersCount;

  CustomerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool clearPhone = false,
    String? photoUrl,
    bool clearPhotoUrl = false,
    DateTime? createdAt,
    int? ordersCount,
    double? totalSpent,
    bool? isBlocked,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: clearPhone ? null : phone ?? this.phone,
      photoUrl: clearPhotoUrl ? null : photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      ordersCount: ordersCount ?? this.ordersCount,
      totalSpent: totalSpent ?? this.totalSpent,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return CustomerModel(
      id: id,
      name: (map["name"] as String?) ?? "",
      email: (map["email"] as String?) ?? "",
      phone: map["phone"] as String?,
      photoUrl: map["photoUrl"] as String?,
      createdAt: _toDate(map["createdAt"]),
      ordersCount: _toInt(map["ordersCount"]) ?? 0,
      totalSpent: _toDouble(map["totalSpent"]) ?? 0,
      isBlocked: map["isBlocked"] as bool? ?? false,
    );
  }

  factory CustomerModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      CustomerModel.fromMap(doc.data() ?? const {}, id: doc.id);

  /// Firestore payload. The document id is never duplicated inside the document.
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "photoUrl": photoUrl,
      "createdAt": createdAt == null ? null : Timestamp.fromDate(createdAt!),
      "ordersCount": ordersCount,
      "totalSpent": totalSpent,
      "isBlocked": isBlocked,
    };
  }

  static double? _toDouble(Object? value) => switch (value) {
        num v => v.toDouble(),
        String v => double.tryParse(v),
        _ => null,
      };

  static int? _toInt(Object? value) => switch (value) {
        num v => v.toInt(),
        String v => int.tryParse(v),
        _ => null,
      };

  static DateTime? _toDate(Object? value) => switch (value) {
        Timestamp v => v.toDate(),
        DateTime v => v,
        String v => DateTime.tryParse(v),
        _ => null,
      };
}
