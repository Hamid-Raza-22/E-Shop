import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';
import 'firestore_paths.dart';

/// Firestore CRUD for the product catalog.
///
/// The storefront reads published products; the dashboard reads everything and
/// writes. All Firestore knowledge stays in here so controllers can be unit
/// tested against a fake implementation of this class.
class ProductService {
  ProductService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.products);

  /// Live catalog for the dashboard (drafts included), newest first.
  Stream<List<ProductModel>> watchAll() {
    return _collection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ProductModel.fromDoc).toList());
  }

  /// Live catalog for the storefront: published products only.
  Stream<List<ProductModel>> watchPublished() {
    return _collection
        .where("isPublished", isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(ProductModel.fromDoc).toList());
  }

  Future<List<ProductModel>> fetchAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map(ProductModel.fromDoc).toList();
  }

  Future<ProductModel?> findById(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.exists ? ProductModel.fromDoc(doc) : null;
  }

  /// Returns the new document id.
  Future<String> create(ProductModel product) async {
    final now = DateTime.now();
    final reference = await _collection.add({
      ...product.toMap(),
      "createdAt": Timestamp.fromDate(product.createdAt ?? now),
      "updatedAt": Timestamp.fromDate(now),
    });
    return reference.id;
  }

  Future<void> update(ProductModel product) async {
    final id = product.id;
    if (id == null) {
      throw ArgumentError("Cannot update a product without an id.");
    }
    await _collection.doc(id).update({
      ...product.toMap(),
      "updatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> setPublished(String id, {required bool isPublished}) {
    return _collection.doc(id).update({
      "isPublished": isPublished,
      "updatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Adjusts stock atomically so two concurrent orders cannot oversell.
  Future<void> adjustStock(String id, int delta) {
    return _collection.doc(id).update({
      "stock": FieldValue.increment(delta),
      "updatedAt": Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> delete(String id) => _collection.doc(id).delete();

  /// One-shot import used by the dashboard's "seed demo catalog" action.
  ///
  /// The document id is stable so re-running the seed does not create duplicates
  /// while still updating the current catalog data.
  Future<void> importAll(List<ProductModel> products) async {
    final batch = _firestore.batch();
    final now = Timestamp.fromDate(DateTime.now());
    final seen = <String>{};
    var writeCount = 0;

    for (final product in products) {
      final docId = _stableDocumentId(product);
      if (!seen.add(docId)) continue;
      writeCount++;

      batch.set(
        _collection.doc(docId),
        {
          ...product.copyWith(id: docId).toMap(),
          "createdAt": product.createdAt == null
              ? now
              : Timestamp.fromDate(product.createdAt!),
          "updatedAt": now,
        },
        SetOptions(merge: true),
      );
    }

    if (writeCount > 0) {
      await batch.commit();
    }
  }

  /// Derives a repeatable document id from the product's identity so re-running
  /// the seed updates the same documents instead of duplicating them.
  ///
  /// A hash is used rather than the sanitised text because Firestore rejects ids
  /// matching `__*__`, forbids `/` and caps their length.
  String _stableDocumentId(ProductModel product) {
    final id = product.id;
    if (id != null && id.isNotEmpty) return id;

    // FNV-1a, 64-bit: short, stable across runs and dependency-free.
    var hash = BigInt.parse("14695981039346656037");
    final prime = BigInt.parse("1099511628211");
    final mask = (BigInt.one << 64) - BigInt.one;

    for (final byte
        in "${product.brandName}|${product.title}|${product.image}".codeUnits) {
      hash = ((hash ^ BigInt.from(byte)) * prime) & mask;
    }

    return "seed_${hash.toRadixString(36)}";
  }
}
