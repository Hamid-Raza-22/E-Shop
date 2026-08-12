import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import '../../../../models/notification_model.dart';
import '../../../../utils/formatters.dart';

/// Notification row from the design: coloured icon, title, timestamp and an
/// unread dot.
class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    super.key,
    required this.notification,
    required this.press,
    required this.onDismissed,
  });

  final NotificationModel notification;
  final VoidCallback press;
  final VoidCallback onDismissed;

  Color get _iconColor {
    switch (notification.type) {
      case AppNotificationType.order:
        return primaryColor;
      case AppNotificationType.offer:
        return errorColor;
      case AppNotificationType.general:
        return warningColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        color: errorColor,
        child: SvgPicture.asset(
          "assets/icons/Delete.svg",
          height: 24,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: press,
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _iconColor,
                  child: SvgPicture.asset(
                    notification.svgSrc,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (isUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: errorColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              notification.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: defaultPadding / 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Text(
                    formatTimeAgo(notification.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
