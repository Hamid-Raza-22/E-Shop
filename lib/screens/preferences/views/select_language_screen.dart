import 'package:flutter/material.dart';

import '../../../components/check_mark.dart';
import '../../../constants.dart';
import '../../../repositories/settings_repository.dart';

/// Language preference selection.
///
/// This stores the user's choice only — the app UI is not actually translated,
/// because real localization needs `flutter_localizations` + `intl` (with ARB
/// files), which are NOT dependencies of this project. Once added, read
/// [SettingsRepository.languageCode] to drive `MaterialApp.locale`.
class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsRepository.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Language")),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: settings,
          builder: (context, _) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "Choose your preferred language",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const Divider(height: 1),
                ...SettingsRepository.supportedLanguages.map(
                  (language) => Column(
                    children: [
                      ListTile(
                        onTap: () => settings.setLanguage(language.code),
                        leading: Text(
                          language.flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(language.name),
                        subtitle: Text(language.nativeName),
                        trailing: settings.languageCode == language.code
                            ? const CheckMark()
                            : null,
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "Your selection is saved for this session. Full app translation is not enabled in this build.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
