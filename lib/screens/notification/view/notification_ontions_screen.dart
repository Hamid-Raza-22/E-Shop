import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/notification_controller.dart';
import '../../../route/route_constants.dart';

/// Notification preference toggles.
class NotificationOptionsScreen extends StatelessWidget {
  const NotificationOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NotificationController.to;

    return Scaffold(
      appBar: AppBar(title: const Text("Notification settings")),
      body: SafeArea(
        child: GetBuilder<NotificationController>(
          builder: (controller) {
            return ListView(
              children: [
                if (!repository.isPermissionGranted)
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultBorderRadious)),
                        border: Border.all(color: warningColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Notifications are turned off for this device.",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                                context, enableNotificationScreenRoute),
                            child: const Text("Turn on"),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "Choose what you want to be notified about",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const Divider(height: 1),
                ...repository.preferences.map(
                  (preference) => Column(
                    children: [
                      ListTile(
                        title: Text(
                          preference.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Padding(
                          padding:
                              const EdgeInsets.only(top: defaultPadding / 2),
                          child: Text(
                            preference.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        trailing: CupertinoSwitch(
                          value: preference.isEnabled,
                          onChanged: (value) => repository.togglePreference(
                              preference.id, value),
                        ),
                        onTap: () => repository.togglePreference(
                            preference.id, !preference.isEnabled),
                      ),
                      const Divider(height: 1),
                    ],
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
