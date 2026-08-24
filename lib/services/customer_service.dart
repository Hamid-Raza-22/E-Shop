import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/customer_model.dart';
import 'firestore_paths.dart';

/// Firestore reads/writes for the customer directory.
///
/// The customer document is created lazily on first checkout — the storefront
/// never has to register anybody up front.
class CustomerService {
  CustomerService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.customers);

  /// Live directory, newest first.
  Stream<List<CustomerModel>> watchAll() {
    return _collection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(CustomerModel.fromDoc).toList());
  }

  Future<List<CustomerModel>> fetchAll() async {
    final snapshot =
        await _collection.orderBy("createdAt", descending: true).get();
    return snapshot.docs.map(CustomerModel.fromDoc).toList();
  }

  Future<CustomerModel?> findById(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.exists ? CustomerModel.fromDoc(doc) : null;
  }

  /// Creates or updates the customer's own profile.
  ///
  /// The shop-owned counters are never touched here, which is exactly what the
  /// security rules allow a signed-in customer to write.
  Future<void> saveProfile({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? photoUrl,
  }) async {
    final document = _collection.doc(id);
    final existing = await document.get();
    final now = Timestamp.fromDate(DateTime.now());

    await document.set(
      {
        "name": name,
        "email": email,
        if (phone != null) "phone": phone,
        if (photoUrl != null) "photoUrl": photoUrl,
        if (!existing.exists) "createdAt": now,
        "updatedAt": now,
      },
      SetOptions(merge: true),
    );
  }

  /// Live profile of a single customer, so the storefront reflects changes made
  /// in the dashboard (a block, a corrected name, …) without a restart.
  Stream<CustomerModel?> watchById(String id) {
    return _collection
        .doc(id)
        .snapshots()
        .map((doc) => doc.exists ? CustomerModel.fromDoc(doc) : null);
  }

  /// Creates or refreshes the customer document as a side effect of checkout.
  ///
  /// The counters use [FieldValue.increment] inside a merging `set` so the write
  /// is a single atomic round trip that works whether or not the document
  /// already exists, and concurrent orders can never lose an increment.
  Future<void> upsertFromOrder({
    required String customerId,
    required String name,
    required String email,
    required double orderTotal,
  }) async {
    final document = _collection.doc(customerId);

    // Firestore cannot express "write this field only if absent", so existence
    // is checked first to keep `createdAt` pinned to the first ever order.
    final existing = await document.get();
    final now = Timestamp.fromDate(DateTime.now());

    await document.set(
      {
        "name": name,
        "email": email,
        if (!existing.exists) "createdAt": now,
        "ordersCount": FieldValue.increment(1),
        "totalSpent": FieldValue.increment(orderTotal),
        "updatedAt": now,
      },
      SetOptions(merge: true),
    );
  }

  /// Undoes [upsertFromOrder] when an order is canceled or returned, so a
  /// refunded order stops counting towards lifetime spend and order count.
  Future<void> reverseOrder({
    required String customerId,
    required double orderTotal,
  }) {
    return _collection.doc(customerId).set(
      {
        "ordersCount": FieldValue.increment(-1),
        "totalSpent": FieldValue.increment(-orderTotal),
        "updatedAt": Timestamp.fromDate(DateTime.now()),
      },
      SetOptions(merge: true),
    );
  }

  /// Blocking a customer keeps their history but stops further checkouts.
  Future<void> setBlocked(String id, {required bool isBlocked}) {
    return _collection.doc(id).update({
      "isBlocked": isBlocked,
      "updatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> delete(String id) => _collection.doc(id).delete();
}
