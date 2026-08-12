import 'package:flutter/material.dart';

import '../../../components/empty_state_view.dart';
import '../../../repositories/notification_repository.dart';
import '../../../route/route_constants.dart';
import 'components/notification_list_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NotificationRepository.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        actions: [
          ListenableBuilder(
            listenable: repository,
            builder: (context, _) {
              if (repository.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: repository.markAllAsRead,
                child: const Text("Mark all read"),
              );
            },
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, notificationOptionsScreenRoute),
            tooltip: "Notification settings",
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: repository,
          builder: (context, _) {
            final notifications = repository.notifications;

            if (notifications.isEmpty) {
              return EmptyStateView(
                title: "No notification yet!",
                description:
                    "We will notify you here about your orders, offers and account activity.",
                actionLabel: "Notification settings",
                onAction: () => Navigator.pushNamed(
                    context, notificationOptionsScreenRoute),
              );
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationListTile(
                  notification: notification,
                  press: () => repository.markAsRead(notification.id),
                  onDismissed: () => repository.remove(notification.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
