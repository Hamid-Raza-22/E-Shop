import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../services/admin_auth_service.dart';

/// Sign-in state for the owner dashboard.
///
/// Kept separate from the storefront's [UserController] because the shop's
/// customer session and the administrator session are different identities.
class AdminAuthController extends GetxController {
  AdminAuthController({AdminAuthService? service})
      : _service = service ?? Get.find<AdminAuthService>();

  final AdminAuthService _service;

  static AdminAuthController get to => Get.find<AdminAuthController>();

  final Rxn<User> _user = Rxn<User>();
  final RxBool _isAdmin = false.obs;
  final RxBool _isBusy = false.obs;
  final RxnString _error = RxnString();

  User? get user => _user.value;

  bool get isSignedIn => _user.value != null;

  bool get isAdmin => _isAdmin.value;

  bool get isBusy => _isBusy.value;

  String? get error => _error.value;

  /// Display name for the dashboard header.
  String get displayName {
    final current = _user.value;
    if (current == null) return "";
    final name = current.displayName;
    if (name != null && name.isNotEmpty) return name;
    return current.email?.split("@").first ?? "";
  }

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_service.authStateChanges());
    // Re-check the admin claim whenever the signed-in account changes.
    _user.listen(_refreshAdminFlag);
    _refreshAdminFlag(_service.currentUser);
  }

  Future<void> _refreshAdminFlag(User? user) async {
    if (user == null) {
      _isAdmin.value = false;
      return;
    }
    _isAdmin.value = await _service.isAdmin(user);
  }

  /// Returns true when the credentials are valid AND the account is an admin.
  Future<bool> signIn({required String email, required String password}) async {
    _isBusy.value = true;
    _error.value = null;

    try {
      final credential = await _service.signIn(email: email, password: password);
      final user = credential.user;
      if (user == null) {
        _error.value = "Sign in failed. Please try again.";
        return false;
      }

      final isAdmin = await _service.isAdmin(user);
      _isAdmin.value = isAdmin;
      if (!isAdmin) {
        // Never leave a non-admin signed in inside the dashboard session.
        await _service.signOut();
        _error.value = "This account is not registered as a shop administrator.";
        return false;
      }
      return true;
    } on FirebaseAuthException catch (exception) {
      _error.value = _messageFor(exception);
      return false;
    } finally {
      _isBusy.value = false;
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    _isAdmin.value = false;
  }

  Future<bool> sendPasswordReset(String email) async {
    _error.value = null;
    try {
      await _service.sendPasswordReset(email);
      return true;
    } on FirebaseAuthException catch (exception) {
      _error.value = _messageFor(exception);
      return false;
    }
  }

  void clearError() => _error.value = null;

  /// Firebase error codes are not user-facing, so they are mapped here.
  String _messageFor(FirebaseAuthException exception) =>
      switch (exception.code) {
        "invalid-email" => "That e-mail address is not valid.",
        "user-disabled" => "This account has been disabled.",
        "user-not-found" ||
        "wrong-password" ||
        "invalid-credential" =>
          "Wrong e-mail or password.",
        "too-many-requests" => "Too many attempts. Try again in a minute.",
        "network-request-failed" => "No internet connection.",
        _ => exception.message ?? "Sign in failed. Please try again.",
      };
}
