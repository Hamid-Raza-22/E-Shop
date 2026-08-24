import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../models/customer_model.dart';
import '../services/customer_service.dart';
import '../utils/service_locator.dart';
import 'order_controller.dart';
import 'user_controller.dart';

/// Customer authentication.
///
/// Signing in is what turns the storefront from demo data into the shopper's own
/// data: it binds the order history to their Firestore documents and keeps their
/// `customers/{uid}` profile up to date. Without Firebase (tests, or a build
/// without configuration) every method fails politely instead of throwing.
class AuthController extends GetxController {
  AuthController({FirebaseAuth? auth, CustomerService? customerService})
      : _injectedAuth = auth,
        _injectedCustomers = customerService;

  static AuthController get to => Get.find<AuthController>();

  final FirebaseAuth? _injectedAuth;
  final CustomerService? _injectedCustomers;

  FirebaseAuth? get _auth {
    if (_injectedAuth != null) return _injectedAuth;
    return Firebase.apps.isEmpty ? null : FirebaseAuth.instance;
  }

  CustomerService? get _customers =>
      _injectedCustomers ?? serviceOrNull<CustomerService>();

  final Rxn<User> _user = Rxn<User>();
  final Rxn<CustomerModel> _profile = Rxn<CustomerModel>();
  final RxBool _isBusy = false.obs;
  final RxnString _error = RxnString();

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<CustomerModel?>? _profileSubscription;

  User? get user => _user.value;

  /// Firestore profile of the signed-in customer, when it exists.
  CustomerModel? get profile => _profile.value;

  bool get isSignedIn => _user.value != null;

  bool get isBusy => _isBusy.value;

  String? get error => _error.value;

  /// False when the build has no Firebase, so screens can stay usable.
  bool get isAvailable => _auth != null;

  @override
  void onInit() {
    super.onInit();
    final auth = _auth;
    if (auth == null) return;
    _authSubscription = auth.authStateChanges().listen(_onAuthStateChanged);
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    super.onClose();
  }

  Future<bool> signIn({required String email, required String password}) {
    return _run(() async {
      final auth = _auth!;
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    });
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
  }) {
    return _run(() async {
      final auth = _auth!;
      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final displayName = (name ?? "").trim();
      if (displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
        // The stream carries the pre-update user, so the local copy is refreshed.
        await credential.user?.reload();
        _user.value = auth.currentUser;
      }
      await _syncProfile(auth.currentUser);
    });
  }

  Future<bool> sendPasswordReset(String email) {
    return _run(() => _auth!.sendPasswordResetEmail(email: email.trim()));
  }

  Future<void> signOut() async {
    await _auth?.signOut();
  }

  void clearError() => _error.value = null;

  Future<bool> _run(Future<void> Function() action) async {
    if (_auth == null) {
      _error.value = "Sign-in is unavailable: Firebase is not configured.";
      return false;
    }

    _isBusy.value = true;
    _error.value = null;
    try {
      await action();
      return true;
    } on FirebaseAuthException catch (exception) {
      _error.value = _messageFor(exception);
      return false;
    } catch (exception) {
      _error.value = exception.toString();
      return false;
    } finally {
      _isBusy.value = false;
    }
  }

  void _onAuthStateChanged(User? user) {
    _user.value = user;
    _profileSubscription?.cancel();
    _profileSubscription = null;

    // Orders follow the signed-in customer; signing out falls back to demo data.
    OrderController.to.bindCustomer(user?.uid);

    if (user == null) {
      _profile.value = null;
      UserController.to.signOut();
      return;
    }

    UserController.to.updateProfile(
      name: user.displayName ?? UserController.to.user.name,
      email: user.email ?? "",
      imageSrc: user.photoURL,
    );

    final customers = _customers;
    if (customers == null) return;

    _profileSubscription = customers.watchById(user.uid).listen((profile) {
      _profile.value = profile;
      if (profile == null) return;
      // The dashboard is the source of truth for the customer's details.
      UserController.to.updateProfile(
        name: profile.name.isEmpty ? null : profile.name,
        email: profile.email.isEmpty ? null : profile.email,
        phone: profile.phone,
        imageSrc: profile.photoUrl,
      );
    });

    _syncProfile(user);
  }

  /// Makes sure a `customers/{uid}` document exists for this account.
  Future<void> _syncProfile(User? user) async {
    if (user == null) return;
    try {
      await _customers?.saveProfile(
        id: user.uid,
        name: user.displayName ?? "",
        email: user.email ?? "",
        photoUrl: user.photoURL,
      );
    } catch (_) {
      // A profile write failure must not block signing in.
    }
  }

  String _messageFor(FirebaseAuthException exception) =>
      switch (exception.code) {
        "invalid-email" => "That email address is not valid.",
        "user-disabled" => "This account has been disabled.",
        "user-not-found" ||
        "wrong-password" ||
        "invalid-credential" =>
          "Email or password is incorrect.",
        "email-already-in-use" => "An account already uses that email address.",
        "weak-password" => "Please choose a stronger password.",
        "too-many-requests" => "Too many attempts. Please try again later.",
        "network-request-failed" => "No connection. Check your network.",
        _ => exception.message ?? "Something went wrong. Please try again.",
      };
}
