import 'package:cloud_firestore/cloud_firestore.dart';

/// A percentage discount coupon managed from the dashboard.
///
/// [code] is always stored upper-cased so lookups can stay a single equality
/// query — Firestore has no case-insensitive matching.
class PromotionModel {
  PromotionModel({
    this.id,
    required String code,
    required this.title,
    required this.percentOff,
    required this.validFrom,
    required this.validTo,
    this.usageLimit,
    this.usedCount = 0,
    this.isActive = true,
  }) : code = code.toUpperCase();

  /// Firestore document id. Null before the promotion is created.
  final String? id;
  final String code, title;
  final int percentOff;
  final DateTime validFrom, validTo;

  /// Null means unlimited redemptions.
  final int? usageLimit;
  final int usedCount;
  final bool isActive;

  /// True when the coupon may be redeemed right now.
  bool get isCurrentlyValid {
    if (!isActive) return false;
    final now = DateTime.now();
    if (now.isBefore(validFrom) || now.isAfter(validTo)) return false;
    return usageLimit == null || usedCount < usageLimit!;
  }

  /// True once every allowed redemption has been used up.
  bool get isExhausted => usageLimit != null && usedCount >= usageLimit!;

  /// Discounted value of [amount] using this promotion's percentage.
  double discountFor(double amount) => amount * percentOff / 100;

  PromotionModel copyWith({
    String? id,
    String? code,
    String? title,
    int? percentOff,
    DateTime? validFrom,
    DateTime? validTo,
    int? usageLimit,
    bool clearUsageLimit = false,
    int? usedCount,
    bool? isActive,
  }) {
    return PromotionModel(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      percentOff: percentOff ?? this.percentOff,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      usageLimit: clearUsageLimit ? null : usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      isActive: isActive ?? this.isActive,
    );
  }

  factory PromotionModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final now = DateTime.now();
    return PromotionModel(
      id: id ?? map["id"] as String?,
      code: (map["code"] as String?) ?? "",
      title: (map["title"] as String?) ?? "",
      percentOff: _toInt(map["percentOff"]) ?? 0,
      validFrom: _toDate(map["validFrom"]) ?? now,
      validTo: _toDate(map["validTo"]) ?? now,
      usageLimit: _toInt(map["usageLimit"]),
      usedCount: _toInt(map["usedCount"]) ?? 0,
      isActive: map["isActive"] as bool? ?? true,
    );
  }

  factory PromotionModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      PromotionModel.fromMap(doc.data() ?? const {}, id: doc.id);

  /// Firestore payload. The document id is never duplicated inside the document.
  Map<String, dynamic> toMap() {
    return {
      "code": code,
      "title": title,
      "percentOff": percentOff,
      "validFrom": Timestamp.fromDate(validFrom),
      "validTo": Timestamp.fromDate(validTo),
      "usageLimit": usageLimit,
      "usedCount": usedCount,
      "isActive": isActive,
    };
  }

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
