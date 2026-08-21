import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/notification_controller.dart';
import '../../../route/route_constants.dart';

/// Notification opt-in screen.
///
/// This toggles the in-app preference only. Requesting the real OS-level push
/// permission requires a plugin that is NOT currently in `pubspec.yaml`
/// (e.g. `permission_handler` for the system prompt, or `firebase_messaging`
/// for push tokens). No platform API is faked here — wiring one in only needs
/// the request call added inside [_enableNotifications].
class EnableNotificationScreen extends StatelessWidget {
  const EnableNotificationScreen({super.key});

  void _enableNotifications(BuildContext context) {
    NotificationController.to.setPermissionGranted(true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notifications enabled")),
    );
    Navigator.pushNamed(context, notificationsScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    final repository = NotificationController.to;

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: SafeArea(
        child: GetBuilder<NotificationController>(
          builder: (controller) {
            final isGranted = repository.isPermissionGranted;

            return Column(
              children: [
                const Spacer(),
                Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? "assets/Illustration/TurnOnNotification_lightTheme.png"
                      : "assets/Illustration/TurnOnNotification_darkTheme.png",
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isGranted
                            ? "Push Notifications are turned on"
                            : "Push Notifications are currently turned off",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: defaultPadding),
                      Text(
                        isGranted
                            ? "You will receive updates about your orders, sales and events. You can fine-tune this in notification settings."
                            : "Enabling push notifications allows us to send you info about our new products, sales, events and more!",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        if (isGranted)
                          OutlinedButton(
                            onPressed: () =>
                                repository.setPermissionGranted(false),
                            child: const Text("Turn off notifications"),
                          )
                        else
                          ElevatedButton(
                            onPressed: () => _enableNotifications(context),
                            child: const Text("Enable Notification"),
                          ),
                        const SizedBox(height: defaultPadding / 2),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, notificationOptionsScreenRoute),
                          child: const Text("Notification settings"),
                        ),
                      ],
                    ),
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
