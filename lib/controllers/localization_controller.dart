import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_env.dart';

/// A language the app ships translations for.
class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.englishName,
    required this.nativeName,
    required this.flag,
    this.isRtl = false,
  });

  final String code, englishName, nativeName, flag;
  final bool isRtl;

  Locale get locale => Locale(code);
}

/// Owns the active locale for the whole app (storefront + dashboard).
///
/// Persists the choice with `shared_preferences` so the app reopens in the
/// language the user picked, and drives [Get.updateLocale] so every `Obx`/
/// `GetBuilder` and `AppLocalizations.of(context)` lookup refreshes at once.
class LocalizationController extends GetxController {
  LocalizationController({SharedPreferences? preferences})
      : _preferences = preferences;

  static const String _storageKey = "app.locale";

  /// Every language with a matching `lib/l10n/app_<code>.arb` file.
  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(
        code: "en", englishName: "English", nativeName: "English", flag: "🇬🇧"),
    AppLanguage(
        code: "de", englishName: "German", nativeName: "Deutsch", flag: "🇩🇪"),
    AppLanguage(
      code: "ur",
      englishName: "Urdu",
      nativeName: "اردو",
      flag: "🇵🇰",
      isRtl: true,
    ),
    AppLanguage(
      code: "ar",
      englishName: "Arabic",
      nativeName: "العربية",
      flag: "🇸🇦",
      isRtl: true,
    ),
    AppLanguage(
        code: "es", englishName: "Spanish", nativeName: "Español", flag: "🇪🇸"),
    AppLanguage(
        code: "fr", englishName: "French", nativeName: "Français", flag: "🇫🇷"),
  ];

  static List<Locale> get supportedLocales =>
      supportedLanguages.map((language) => language.locale).toList();

  static AppLanguage languageOf(String code) => supportedLanguages.firstWhere(
        (language) => language.code == code,
        orElse: () => supportedLanguages.first,
      );

  static LocalizationController get to => Get.find<LocalizationController>();

  SharedPreferences? _preferences;

  late final Rx<AppLanguage> _language =
      languageOf(AppEnv.defaultLocale).obs;

  AppLanguage get language => _language.value;

  Locale get locale => _language.value.locale;

  bool get isRtl => _language.value.isRtl;

  Locale get fallbackLocale => Locale(AppEnv.fallbackLocale);

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  Future<void> _restore() async {
    _preferences ??= await SharedPreferences.getInstance();
    final saved = _preferences!.getString(_storageKey);
    if (saved == null || saved == _language.value.code) return;
    _apply(languageOf(saved));
  }

  /// Switches the app language and persists it.
  Future<void> setLanguage(String code) async {
    final next = languageOf(code);
    if (next.code == _language.value.code) return;

    _apply(next);

    _preferences ??= await SharedPreferences.getInstance();
    await _preferences!.setString(_storageKey, next.code);
  }

  void _apply(AppLanguage language) {
    _language.value = language;
    Get.updateLocale(language.locale);
    // Rx drives `Obx` in MyApp; `update()` drives the `GetBuilder`s used by the
    // language pickers, so both styles stay in sync.
    update();
  }
}
