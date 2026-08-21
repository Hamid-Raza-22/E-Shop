import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/check_mark.dart';
import '../../../constants.dart';
import '../../../controllers/localization_controller.dart';

/// Language preference selection.
///
/// Picking a language calls [LocalizationController.setLanguage], which swaps
/// the app locale through `Get.updateLocale` and persists the choice, so every
/// `AppLocalizations.of(context)` lookup refreshes immediately.
class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Language")),
      body: SafeArea(
        child: GetBuilder<LocalizationController>(
          builder: (controller) {
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
                ...LocalizationController.supportedLanguages.map(
                  (language) => Column(
                    children: [
                      ListTile(
                        onTap: () => controller.setLanguage(language.code),
                        leading: Text(
                          language.flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(language.englishName),
                        subtitle: Text(language.nativeName),
                        trailing: controller.language.code == language.code
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
                    "Your selection is saved on this device and applied across the app.",
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
