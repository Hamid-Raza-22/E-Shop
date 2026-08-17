import 'package:flutter/foundation.dart';

class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  final String code, name, nativeName, flag;
}

/// App-level preferences that are shared between screens.
///
/// Values live in memory only; persisting them would need `shared_preferences`
/// (or similar), which is NOT a dependency of this project.
class SettingsRepository extends ChangeNotifier {
  SettingsRepository._();

  static final SettingsRepository instance = SettingsRepository._();

  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(
        code: "en", name: "English", nativeName: "English", flag: "🇬🇧"),
    AppLanguage(code: "ur", name: "Urdu", nativeName: "اردو", flag: "🇵🇰"),
    AppLanguage(code: "ar", name: "Arabic", nativeName: "العربية", flag: "🇸🇦"),
    AppLanguage(code: "es", name: "Spanish", nativeName: "Español", flag: "🇪🇸"),
    AppLanguage(code: "fr", name: "French", nativeName: "Français", flag: "🇫🇷"),
  ];

  String _languageCode = "en";

  String get languageCode => _languageCode;

  AppLanguage get language => supportedLanguages
      .firstWhere((language) => language.code == _languageCode);

  void setLanguage(String code) {
    if (_languageCode == code) return;
    _languageCode = code;
    notifyListeners();
  }
}
