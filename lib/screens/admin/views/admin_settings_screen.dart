import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_env.dart';
import '../../../constants.dart';
import '../../../controllers/admin/admin_auth_controller.dart';
import '../../../controllers/admin/admin_products_controller.dart';
import '../../../controllers/localization_controller.dart';
import '../../../l10n/app_localizations.dart';
import 'components/section_card.dart';

/// Store configuration + dashboard preferences.
///
/// Store identity comes from `.env` and is intentionally read-only here: it is
/// build configuration, not runtime data, so changing it in the UI would give a
/// false sense of persistence.
class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        SectionCard(
          title: translations.settingsTitle,
          child: Column(
            children: [
              _ReadOnlyRow(
                label: translations.adminSettingsStoreName,
                value: AppEnv.appName,
              ),
              _ReadOnlyRow(
                label: translations.adminSettingsCurrency,
                value: AppEnv.currencyCode,
              ),
              _ReadOnlyRow(
                label: translations.adminSettingsSupportEmail,
                value: AppEnv.supportEmail.isEmpty ? "—" : AppEnv.supportEmail,
              ),
              _ReadOnlyRow(
                label: translations.adminSettingsEnvironment,
                value: AppEnv.appEnvironment,
              ),
              _ReadOnlyRow(
                label: "Firebase project",
                value: AppEnv.firebaseProjectId,
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding),
        SectionCard(
          title: translations.settingsLanguage,
          child: GetBuilder<LocalizationController>(
            builder: (controller) => Column(
              children: [
                for (final language
                    in LocalizationController.supportedLanguages)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => controller.setLanguage(language.code),
                    title: Text("${language.flag}  ${language.nativeName}"),
                    subtitle: Text(language.englishName),
                    trailing: controller.language.code == language.code
                        ? const Icon(Icons.check_circle, color: primaryColor)
                        : null,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),
        SectionCard(
          title: translations.adminNavProducts,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Copies the bundled demo catalog into Firestore, plus sample "
                "customers, orders, reviews and coupons. Only runs while the "
                "catalog is still empty.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: defaultPadding / 2),
              OutlinedButton.icon(
                onPressed: () async {
                  final seeded =
                      await AdminProductsController.to.seedDemoCatalog();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        seeded
                            ? translations.adminProductSaved
                            : AdminProductsController.to.error ??
                                "Catalog is not empty — nothing was imported.",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text("Import demo data"),
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding),
        SectionCard(
          title: translations.actionSignOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  AdminAuthController.to.user?.email ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              OutlinedButton.icon(
                onPressed: AdminAuthController.to.signOut,
                icon: const Icon(Icons.logout, color: errorColor),
                label: Text(
                  translations.actionSignOut,
                  style: const TextStyle(color: errorColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.value});

  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
