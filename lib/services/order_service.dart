import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';
import 'firestore_paths.dart';

/// Firestore reads/writes for orders.
///
/// Ordering is always by `placedOn` so the dashboard lists and the customer's
/// own history agree on "newest first".
class OrderService {
  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.orders);

  /// Live list of every order, newest first.
  Stream<List<OrderModel>> watchAll() {
    return _collection
        .orderBy("placedOn", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(OrderModel.fromDoc).toList());
  }

  /// Live list filtered to a single lifecycle state.
  Stream<List<OrderModel>> watchByStatus(OrderStatus status) {
    return _collection
        .where("status", isEqualTo: status.name)
        .orderBy("placedOn", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(OrderModel.fromDoc).toList());
  }

  /// Short feed for the dashboard home screen.
  Stream<List<OrderModel>> watchRecent({int limit = 10}) {
    return _collection
        .orderBy("placedOn", descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(OrderModel.fromDoc).toList());
  }

  Future<List<OrderModel>> fetchAll() async {
    final snapshot =
        await _collection.orderBy("placedOn", descending: true).get();
    return snapshot.docs.map(OrderModel.fromDoc).toList();
  }

  /// Orders placed inside the inclusive/exclusive range `[from, to)`.
  Future<List<OrderModel>> fetchBetween(DateTime from, DateTime to) async {
    final snapshot = await _collection
        .where("placedOn", isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where("placedOn", isLessThan: Timestamp.fromDate(to))
        .orderBy("placedOn", descending: true)
        .get();
    return snapshot.docs.map(OrderModel.fromDoc).toList();
  }

  Future<OrderModel?> findById(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.exists ? OrderModel.fromDoc(doc) : null;
  }

  /// Returns the new document id.
  Future<String> create(OrderModel order) async {
    final now = DateTime.now();
    final reference = await _collection.add({
      ...order.toMap(),
      "updatedAt": Timestamp.fromDate(now),
    });
    return reference.id;
  }

  /// Advances an order. [cancelReason] is only written when supplied so a
  /// previously recorded reason is never silently erased.
  Future<void> updateStatus(
    String id,
    OrderStatus status, {
    String? cancelReason,
  }) {
    return _collection.doc(id).update({
      "status": status.name,
      if (cancelReason != null) "cancelReason": cancelReason,
      "updatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  /// The signed-in customer's own order history, newest first.
  Stream<List<OrderModel>> watchForCustomer(String customerId) {
    return _collection
        .where("customerId", isEqualTo: customerId)
        .orderBy("placedOn", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(OrderModel.fromDoc).toList());
  }
}
