import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_paths.dart';

/// A review as stored in Firestore, i.e. with the moderation fields the
/// storefront's `ReviewModel` does not carry.
///
/// Kept local to this service instead of widening `ReviewModel`, because the
/// storefront widgets are built against that shape and must not learn about
/// moderation state.
class ModeratedReview {
  ModeratedReview({
    this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.review,
    this.createdAt,
    this.isApproved = false,
  });

  /// Firestore document id. Null before the review is created.
  final String? id;
  final String productId, userName, review;
  final double rating;
  final DateTime? createdAt;
  final bool isApproved;

  ModeratedReview copyWith({
    String? id,
    String? productId,
    String? userName,
    double? rating,
    String? review,
    DateTime? createdAt,
    bool? isApproved,
  }) {
    return ModeratedReview(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
      isApproved: isApproved ?? this.isApproved,
    );
  }

  factory ModeratedReview.fromMap(Map<String, dynamic> map, {String? id}) {
    return ModeratedReview(
      id: id ?? map["id"] as String?,
      productId: (map["productId"] as String?) ?? "",
      userName: (map["userName"] as String?) ?? "",
      rating: _toDouble(map["rating"]) ?? 0,
      review: (map["review"] as String?) ?? "",
      createdAt: _toDate(map["createdAt"]),
      isApproved: map["isApproved"] as bool? ?? false,
    );
  }

  factory ModeratedReview.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ModeratedReview.fromMap(doc.data() ?? const {}, id: doc.id);

  /// Firestore payload. The document id is never duplicated inside the document.
  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "userName": userName,
      "rating": rating,
      "review": review,
      "createdAt": createdAt == null ? null : Timestamp.fromDate(createdAt!),
      "isApproved": isApproved,
    };
  }

  static double? _toDouble(Object? value) => switch (value) {
        num v => v.toDouble(),
        String v => double.tryParse(v),
        _ => null,
      };

  static DateTime? _toDate(Object? value) => switch (value) {
        Timestamp v => v.toDate(),
        DateTime v => v,
        String v => DateTime.tryParse(v),
        _ => null,
      };
}

/// Firestore reads/writes for review moderation.
///
/// Reviews arrive unapproved and only become visible on the product page once
/// an admin approves them, which keeps spam off the storefront.
class ReviewService {
  ReviewService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.reviews);

  /// Moderation queue: everything still awaiting a decision, oldest first so
  /// the longest waiting review is handled next.
  Stream<List<ModeratedReview>> watchPending() {
    return _collection
        .where("isApproved", isEqualTo: false)
        .orderBy("createdAt")
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ModeratedReview.fromDoc).toList());
  }

  /// What the storefront shows on a product page.
  Stream<List<ModeratedReview>> watchApprovedForProduct(String productId) {
    return _collection
        .where("productId", isEqualTo: productId)
        .where("isApproved", isEqualTo: true)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ModeratedReview.fromDoc).toList());
  }

  /// Live list of every review, newest first.
  Stream<List<ModeratedReview>> watchAll() {
    return _collection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ModeratedReview.fromDoc).toList());
  }

  Future<void> setApproved(String id, {required bool isApproved}) {
    return _collection.doc(id).update({
      "isApproved": isApproved,
      "moderatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> delete(String id) => _collection.doc(id).delete();

  /// Returns the new document id.
  Future<String> create(ModeratedReview review) async {
    final reference = await _collection.add({
      ...review.toMap(),
      "createdAt": Timestamp.fromDate(review.createdAt ?? DateTime.now()),
    });
    return reference.id;
  }
}
