import 'package:cloud_firestore/cloud_firestore.dart';

/// Single place where every Firestore collection name lives, so a rename never
/// has to be hunted down across services.
class FirestorePaths {
  const FirestorePaths._();

  static const String products = "products";
  static const String orders = "orders";
  static const String customers = "customers";
  static const String reviews = "reviews";
  static const String promotions = "promotions";

  /// `admins/{uid}` — presence of the document grants dashboard access.
  static const String admins = "admins";

  static CollectionReference<Map<String, dynamic>> collection(
    FirebaseFirestore firestore,
    String name,
  ) =>
      firestore.collection(name);
}
