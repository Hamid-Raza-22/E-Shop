import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/check_mark.dart';
import '../../../constants.dart';
import '../../../controllers/localization_controller.dart';
import '../../../route/route_constants.dart';

/// Onboarding language picker shown before the login screen.
class PreferredLanguageScreen extends StatelessWidget {
  const PreferredLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: GetBuilder<LocalizationController>(
                builder: (controller) {
                  return ListView(
                    children: LocalizationController.supportedLanguages
                        .map(
                          (language) => Column(
                            children: [
                              ListTile(
                                onTap: () =>
                                    controller.setLanguage(language.code),
                                leading: Text(
                                  language.flag,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                title: Text(language.englishName),
                                subtitle: Text(language.nativeName),
                                trailing:
                                    controller.language.code == language.code
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
