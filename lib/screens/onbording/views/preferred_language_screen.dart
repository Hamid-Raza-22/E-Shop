import 'package:flutter/material.dart';

import '../../../components/check_mark.dart';
import '../../../constants.dart';
import '../../../repositories/settings_repository.dart';
import '../../../route/route_constants.dart';

/// Onboarding language picker shown before the login screen.
class PreferredLanguageScreen extends StatelessWidget {
  const PreferredLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsRepository.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Preferred language")),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your language",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    "You can change this later in Profile › Language.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: settings,
                builder: (context, _) {
                  return ListView(
                    children: SettingsRepository.supportedLanguages
                        .map(
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
                                trailing:
                                    settings.languageCode == language.code
                                        ? const CheckMark()
                                        : null,
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, logInScreenRoute),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
