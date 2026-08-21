import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Thrown when `.env` is missing a value the app cannot start without.
class MissingEnvValueException implements Exception {
  const MissingEnvValueException(this.key);

  final String key;

  @override
  String toString() =>
      "MissingEnvValueException: `$key` is not set in .env — copy .env.example "
      "and fill it in.";
}

/// Typed access to `.env`.
///
/// Everything shipped in `.env` ends up inside the app bundle, so it may only
/// hold *public* client identifiers (Firebase API keys are public by design and
/// are guarded by Firestore/Storage rules). Server-side secrets — service
/// accounts, payment secret keys — must never be added here.
class AppEnv {
  const AppEnv._();

  static bool _loaded = false;

  static Future<void> load({String fileName = ".env"}) async {
    if (_loaded) return;
    await dotenv.load(fileName: fileName);
    _loaded = true;
  }

  /// Visible for tests: inject values without touching the asset bundle.
  @visibleForTesting
  static void loadForTest(Map<String, String> values) {
    dotenv.loadFromString(mergeWith: values, isOptional: true);
    _loaded = true;
  }

  /// Reading before [load] must not explode: unit tests and background
  /// isolates touch formatting helpers without ever booting the app.
  static String? _read(String key) =>
      dotenv.isInitialized ? dotenv.maybeGet(key) : null;

  static String _required(String key) {
    final value = _read(key);
    if (value == null || value.isEmpty) throw MissingEnvValueException(key);
    return value;
  }

  static String _optional(String key, String fallback) {
    final value = _read(key);
    return value == null || value.isEmpty ? fallback : value;
  }

  static bool _flag(String key, {bool fallback = false}) =>
      _optional(key, fallback.toString()).toLowerCase() == "true";

  static int _int(String key, int fallback) =>
      int.tryParse(_optional(key, "$fallback")) ?? fallback;

  // --- App ------------------------------------------------------------------

  static String get appName => _optional("APP_NAME", "Shop");

  static String get appEnvironment => _optional("APP_ENV", "development");

  static bool get isProduction => appEnvironment == "production";

  static String get defaultLocale => _optional("DEFAULT_LOCALE", "en");

  static String get fallbackLocale => _optional("FALLBACK_LOCALE", "en");

  static String get currencyCode => _optional("CURRENCY_CODE", "USD");

  static String get supportEmail => _optional("SUPPORT_EMAIL", "");

  /// Client-side allow-list for the dashboard. The `admins/{uid}` Firestore
  /// document remains the real authority — this only avoids showing the shell
  /// to obviously unauthorised accounts.
  static List<String> get adminAllowedEmails => _optional(
        "ADMIN_ALLOWED_EMAILS",
        "",
      )
          .split(",")
          .map((email) => email.trim().toLowerCase())
          .where((email) => email.isNotEmpty)
          .toList();

  // --- Emulator -------------------------------------------------------------

  static bool get useFirebaseEmulator => _flag("USE_FIREBASE_EMULATOR");

  static String get emulatorHost => _optional("FIREBASE_EMULATOR_HOST", "localhost");

  static int get firestoreEmulatorPort => _int("FIRESTORE_EMULATOR_PORT", 8080);

  static int get authEmulatorPort => _int("AUTH_EMULATOR_PORT", 9099);

  // --- Firebase -------------------------------------------------------------

  static String get firebaseProjectId => _required("FIREBASE_PROJECT_ID");

  static String get _messagingSenderId => _required("FIREBASE_MESSAGING_SENDER_ID");

  static String get _storageBucket => _required("FIREBASE_STORAGE_BUCKET");

  static String? get _authDomain => dotenv.maybeGet("FIREBASE_AUTH_DOMAIN");

  /// Replaces the generated `firebase_options.dart` so that no project
  /// identifier is hard-coded in source control.
  static FirebaseOptions get firebaseOptions {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: _required("FIREBASE_WEB_API_KEY"),
        appId: _required("FIREBASE_WEB_APP_ID"),
        messagingSenderId: _messagingSenderId,
        projectId: firebaseProjectId,
        authDomain: _authDomain,
        storageBucket: _storageBucket,
        measurementId: dotenv.maybeGet("FIREBASE_WEB_MEASUREMENT_ID"),
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: _required("FIREBASE_ANDROID_API_KEY"),
          appId: _required("FIREBASE_ANDROID_APP_ID"),
          messagingSenderId: _messagingSenderId,
          projectId: firebaseProjectId,
          storageBucket: _storageBucket,
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: _required("FIREBASE_IOS_API_KEY"),
          appId: _required("FIREBASE_IOS_APP_ID"),
          messagingSenderId: _messagingSenderId,
          projectId: firebaseProjectId,
          storageBucket: _storageBucket,
          iosBundleId: dotenv.maybeGet("FIREBASE_IOS_BUNDLE_ID"),
        );
      case TargetPlatform.macOS:
        return FirebaseOptions(
          apiKey: _required("FIREBASE_IOS_API_KEY"),
          appId: _required("FIREBASE_IOS_APP_ID"),
          messagingSenderId: _messagingSenderId,
          projectId: firebaseProjectId,
          storageBucket: _storageBucket,
          iosBundleId: dotenv.maybeGet("FIREBASE_IOS_BUNDLE_ID"),
          iosClientId: dotenv.maybeGet("FIREBASE_MACOS_CLIENT_ID"),
        );
      case TargetPlatform.windows:
        return FirebaseOptions(
          apiKey: _required("FIREBASE_WINDOWS_API_KEY"),
          appId: _required("FIREBASE_WINDOWS_APP_ID"),
          messagingSenderId: _messagingSenderId,
          projectId: firebaseProjectId,
          authDomain: _authDomain,
          storageBucket: _storageBucket,
          measurementId: dotenv.maybeGet("FIREBASE_WINDOWS_MEASUREMENT_ID"),
        );
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          "Firebase is not configured for $defaultTargetPlatform.",
        );
    }
  }
}
