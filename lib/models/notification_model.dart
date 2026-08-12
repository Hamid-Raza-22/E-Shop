enum AppNotificationType { order, offer, general }

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.type = AppNotificationType.general,
    this.isRead = false,
  });

  final String id;
  final String title, description;
  final DateTime date;
  final AppNotificationType type;
  final bool isRead;

  String get svgSrc {
    switch (type) {
      case AppNotificationType.order:
        return "assets/icons/Order.svg";
      case AppNotificationType.offer:
        return "assets/icons/Sale.svg";
      case AppNotificationType.general:
        return "assets/icons/Notification.svg";
    }
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      description: description,
      date: date,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// A single toggleable notification preference row.
class NotificationPreference {
  NotificationPreference({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isEnabled = true,
  });

  final String id;
  final String title, subtitle;
  bool isEnabled;
}
