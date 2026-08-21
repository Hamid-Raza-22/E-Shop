import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../config/app_env.dart';
import 'firestore_paths.dart';

/// Authentication for the dashboard shell.
///
/// Sign-in is plain Firebase Auth; the *authorisation* decision lives in
/// [isAdmin] so the router only has one place to ask "may this account see the
/// dashboard?".
class AdminAuthService {
  AdminAuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();

  /// Whether [user] may open the dashboard.
  ///
  /// The `admins/{uid}` document is the authority: if the read succeeds, its
  /// existence alone decides the answer, and the `.env` allow-list is ignored.
  ///
  /// Fallback: when the read itself fails — offline, or Firestore rules deny the
  /// lookup before the admin claim is provisioned — the local
  /// [AppEnv.adminAllowedEmails] list is consulted so a legitimate admin is not
  /// locked out of the shell. This is a convenience only; every actual read and
  /// write is still gated by Firestore security rules on the server.
  Future<bool> isAdmin(User user) async {
    try {
      final doc = await _firestore
          .collection(FirestorePaths.admins)
          .doc(user.uid)
          .get();
      return doc.exists;
    } on Object {
      final email = user.email?.trim().toLowerCase();
      if (email == null || email.isEmpty) return false;
      return AppEnv.adminAllowedEmails.contains(email);
    }
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());
}
