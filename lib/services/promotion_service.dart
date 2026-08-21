import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/promotion_model.dart';
import 'firestore_paths.dart';

/// Firestore CRUD for discount coupons.
///
/// Codes are stored upper-cased by [PromotionModel] so a single equality query
/// can serve case-insensitive lookups.
class PromotionService {
  PromotionService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.promotions);

  /// Live list for the dashboard, soonest expiry first.
  Stream<List<PromotionModel>> watchAll() {
    return _collection
        .orderBy("validTo", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(PromotionModel.fromDoc).toList());
  }

  /// Coupons flagged active and still inside their validity window.
  ///
  /// The date window and the usage limit are checked in Dart because Firestore
  /// cannot combine two range filters with a field-to-field comparison.
  Future<List<PromotionModel>> fetchActive() async {
    final snapshot = await _collection.where("isActive", isEqualTo: true).get();
    return snapshot.docs
        .map(PromotionModel.fromDoc)
        .where((promotion) => promotion.isCurrentlyValid)
        .toList();
  }

  Future<PromotionModel?> findByCode(String code) async {
    final snapshot = await _collection
        .where("code", isEqualTo: code.toUpperCase())
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return PromotionModel.fromDoc(snapshot.docs.first);
  }

  /// Returns the new document id.
  Future<String> create(PromotionModel promotion) async {
    final now = Timestamp.fromDate(DateTime.now());
    final reference = await _collection.add({
      ...promotion.toMap(),
      "createdAt": now,
      "updatedAt": now,
    });
    return reference.id;
  }

  /// Saves the editable fields. `usedCount` is deliberately left out so an edit
  /// cannot roll back redemptions counted by [incrementUsage].
  Future<void> update(PromotionModel promotion) async {
    final id = promotion.id;
    if (id == null) {
      throw ArgumentError("Cannot update a promotion without an id.");
    }
    final payload = {...promotion.toMap()}..remove("usedCount");
    await _collection.doc(id).update({
      ...payload,
      "updatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> setActive(String id, {required bool isActive}) {
    return _collection.doc(id).update({
      "isActive": isActive,
      "updatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Counts a redemption atomically so two concurrent checkouts cannot both
  /// slip past the usage limit.
  Future<void> incrementUsage(String id) {
    return _collection.doc(id).update({
      "usedCount": FieldValue.increment(1),
      "updatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> delete(String id) => _collection.doc(id).delete();
}
