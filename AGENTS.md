# Project notes

Flutter e-commerce app (`shop`) with a customer storefront and an owner
dashboard, backed by Firebase.

## Commands

```powershell
flutter pub get
flutter analyze --no-pub      # must be clean
flutter test --no-pub         # must be green
flutter gen-l10n              # regenerate localizations after editing ARB files
flutter run -d chrome         # dashboard is easiest to review on web
```

## Architecture

| Layer | Location | Notes |
| --- | --- | --- |
| Config | `lib/config/app_env.dart` | Typed `.env` access + `FirebaseOptions`. Never hard-code keys. |
| State | `lib/controllers/` | GetX. Storefront controllers use `update()` + `GetBuilder`; admin controllers use `Rx` + `Obx`. |
| DI | `lib/bindings/` | `InitialBindings` (app-wide), `AdminBindings` (dashboard route). |
| Data | `lib/services/` | Firestore access only. Every service takes `FirebaseFirestore`/`FirebaseAuth` via constructor for testability. |
| Models | `lib/models/` | `fromMap`/`fromDoc`/`toMap`/`copyWith`. |
| UI | `lib/screens/`, `lib/components/` | Dashboard lives in `lib/screens/admin/`. |
| l10n | `lib/l10n/*.arb` | en, de, ur, ar, es, fr. |

Controllers expose `static X get to => Get.find<X>();` — do not reintroduce
singletons. `GetxController.update()` is the rebuild trigger, so a controller
must never define its own method named `update` (hence `updateAddress`,
`updateProfile`).

## Environment

- Copy `.env.example` to `.env` and fill it in (`flutterfire configure` prints
  the Firebase values). `.env` is git-ignored and bundled as a Flutter asset.
- `.env` is **not** a secret store: everything in it ships inside the app
  binary. Only public client identifiers belong there; Firestore rules are what
  actually protect data.
- `USE_FIREBASE_EMULATOR=true` points Auth/Firestore at the local emulators.

## Firebase

- Security rules: `firestore.rules`; composite indexes: `firestore.indexes.json`.
  Deploy with `firebase deploy --only firestore:rules,firestore:indexes`.
- Dashboard access = a document at `admins/{uid}`. `ADMIN_ALLOWED_EMAILS` in
  `.env` is only an offline fallback for the UI, never an authorisation check.
- Collections: `products`, `orders`, `customers`, `reviews`, `promotions`,
  `admins`.

## Localization

- `lib/l10n/app_en.arb` is the template; every other ARB must carry the same
  keys. Run `flutter gen-l10n` after editing.
- Strings come from `AppLocalizations.of(context)`; locale changes go through
  `LocalizationController.setLanguage(code)` (persists via `shared_preferences`
  and calls `Get.updateLocale`). Arabic/Urdu flip to RTL automatically.
- Dates/money use `lib/utils/formatters.dart` (intl, locale-aware). Anything
  calling them outside `main()` must first run `initializeDateFormatting()`.

## Tests

- `test/helpers/controller_harness.dart` registers the GetX controllers and
  loads a fake `.env`; call it from `setUpAll`.
- Widget tests must supply `AppLocalizations.localizationsDelegates`
  (see `_wrap` in `test/screens_smoke_test.dart`).
- Firestore services are not unit-tested yet — they need a fake Firestore.
