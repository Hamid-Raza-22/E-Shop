import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../repositories/notification_repository.dart';
import '../../../route/route_constants.dart';

/// Onboarding step asking to opt into notifications.
///
/// In-app opt-in only — the OS-level prompt needs `permission_handler`, which is
/// NOT a dependency of this project (see [NotificationRepository]).
class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  void _next(BuildContext context) =>
      Navigator.pushNamed(context, preferredLanuageScreenRoute);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => _next(context),
            child: const Text("Skip"),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/Illustration/TurnOnNotification_lightTheme.png"
                    : "assets/Illustration/TurnOnNotification_darkTheme.png",
                width: MediaQuery.of(context).size.width * 0.65,
              ),
              const Spacer(),
              Text(
                "Stay in the loop",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: defaultPadding),
              Text(
                "Allow notifications so we can keep you posted about your orders, price drops and flash sales.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: () {
                  NotificationRepository.instance.setPermissionGranted(true);
                  _next(context);
                },
                child: const Text("Allow notifications"),
              ),
              const SizedBox(height: defaultPadding / 2),
              OutlinedButton(
                onPressed: () => _next(context),
                child: const Text("Not now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
