import 'package:flutter/foundation.dart';

import '../models/notification_model.dart';

/// In-memory notification inbox + preference toggles.
///
/// [isPermissionGranted] only tracks the in-app opt-in state. Requesting the
/// real OS-level notification permission requires a plugin
/// (e.g. `permission_handler` or `firebase_messaging`) which is NOT currently a
/// dependency of this project, so no OS call is faked here.
class NotificationRepository extends ChangeNotifier {
  NotificationRepository._() {
    _seedDemoNotifications();
  }

  static final NotificationRepository instance = NotificationRepository._();

  final List<NotificationModel> _notifications = [];
  bool _isPermissionGranted = false;

  final List<NotificationPreference> _preferences = [
    NotificationPreference(
      id: "order_updates",
      title: "Order updates",
      subtitle: "Get notified when your order status changes.",
    ),
    NotificationPreference(
      id: "offers",
      title: "Discounts & offers",
      subtitle: "Flash sales, coupons and seasonal campaigns.",
    ),
    NotificationPreference(
      id: "new_arrivals",
      title: "New arrivals",
      subtitle: "Be first to know when new products land.",
      isEnabled: false,
    ),
    NotificationPreference(
      id: "price_drop",
      title: "Price drop alerts",
      subtitle: "Alerts for items saved in your wishlist.",
      isEnabled: false,
    ),
    NotificationPreference(
      id: "newsletter",
      title: "Email newsletter",
      subtitle: "Weekly style picks straight to your inbox.",
      isEnabled: false,
    ),
  ];

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  List<NotificationPreference> get preferences =>
      List.unmodifiable(_preferences);

  bool get isEmpty => _notifications.isEmpty;

  bool get isPermissionGranted => _isPermissionGranted;

  int get unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  void markAsRead(String id) {
    final index =
        _notifications.indexWhere((notification) => notification.id == id);
    if (index == -1 || _notifications[index].isRead) return;
    _notifications[index] = _notifications[index].copyWith(isRead: true);
    notifyListeners();
  }

  void markAllAsRead() {
    if (unreadCount == 0) return;
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void remove(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }

  void clearAll() {
    if (_notifications.isEmpty) return;
    _notifications.clear();
    notifyListeners();
  }

  void togglePreference(String id, bool isEnabled) {
    final preference =
        _preferences.where((preference) => preference.id == id).firstOrNull;
    if (preference == null) return;
    preference.isEnabled = isEnabled;
    notifyListeners();
  }

  /// In-app opt-in only — see class docs regarding OS permissions.
  void setPermissionGranted(bool value) {
    if (_isPermissionGranted == value) return;
    _isPermissionGranted = value;
    notifyListeners();
  }

  void _seedDemoNotifications() {
    final now = DateTime.now();
    _notifications.addAll([
      NotificationModel(
        id: "n1",
        title: "Your order is on the way",
        description:
            "Order #FDS639421 has been shipped and arrives in 2-3 days.",
        date: now.subtract(const Duration(minutes: 24)),
        type: AppNotificationType.order,
      ),
      NotificationModel(
        id: "n2",
        title: "Flash sale starts now",
        description: "Up to 40% off on selected best sellers for 24 hours.",
        date: now.subtract(const Duration(hours: 5)),
        type: AppNotificationType.offer,
      ),
      NotificationModel(
        id: "n3",
        title: "Order delivered",
        description: "Order #FDS639422 was delivered. Leave a review?",
        date: now.subtract(const Duration(days: 1, hours: 3)),
        type: AppNotificationType.order,
        isRead: true,
      ),
      NotificationModel(
        id: "n4",
        title: "Welcome to GOGGUZ",
        description: "Complete your profile to get personalised picks.",
        date: now.subtract(const Duration(days: 4)),
        isRead: true,
      ),
    ]);
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
