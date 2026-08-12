import 'package:flutter/material.dart';

import '../../../components/empty_state_view.dart';
import '../../../route/route_constants.dart';

/// Dedicated empty-notification screen (kept as its own route by design).
class NoNotificationScreen extends StatelessWidget {
  const NoNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification")),
      body: SafeArea(
        child: EmptyStateView(
          title: "No notification yet!",
          description:
              "You have no notifications right now. Turn on alerts so you never miss an order update or a sale.",
          actionLabel: "Enable notifications",
          onAction: () =>
              Navigator.pushNamed(context, enableNotificationScreenRoute),
        ),
      ),
    );
  }
}
