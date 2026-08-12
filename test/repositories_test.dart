import 'package:flutter_test/flutter_test.dart';
import 'package:shop/models/order_model.dart';
import 'package:shop/repositories/address_repository.dart';
import 'package:shop/repositories/cart_repository.dart';
import 'package:shop/repositories/notification_repository.dart';
import 'package:shop/repositories/order_repository.dart';
import 'package:shop/repositories/review_repository.dart';
import 'package:shop/repositories/search_repository.dart';
import 'package:shop/screens/product/views/components/inches_size_table.dart';

void main() {
  group('SearchRepository', () {
    final search = SearchRepository.instance;

    test('returns nothing for a blank query', () {
      expect(search.search(""), isEmpty);
      expect(search.search("   "), isEmpty);
    });

    test('matches on title case-insensitively', () {
      final results = search.search("dress");
      expect(results, isNotEmpty);
      expect(
        results.every((p) => p.title.toLowerCase().contains("dress")),
        isTrue,
      );
    });

    test('matches on brand name', () {
      expect(search.search("lipsy"), isNotEmpty);
    });

    test('catalog is de-duplicated', () {
      final keys =
          search.catalog.map((p) => "${p.title}-${p.image}").toList();
      expect(keys.length, keys.toSet().length);
    });

    test('history is de-duplicated and most-recent-first', () {
      search.clearHistory();
      search.addToHistory("shirt");
      search.addToHistory("hat");
      search.addToHistory("shirt");

      expect(search.history, ["shirt", "hat"]);
    });

    test('history is capped', () {
      search.clearHistory();
      for (var i = 0; i < SearchRepository.maxHistoryLength + 5; i++) {
        search.addToHistory("term$i");
      }
      expect(search.history.length, SearchRepository.maxHistoryLength);
    });
  });

  group('OrderRepository', () {
    test('creating an order from the cart adds an active order', () {
      final cart = CartRepository.instance;
      final orders = OrderRepository.instance;

      cart.clear();
      cart.seedDemoItems();
      final activeBefore = orders.activeOrders.length;

      final order = orders.createFromCart(cart.items, cart.total);

      expect(orders.activeOrders.length, activeBefore + 1);
      expect(order.isActive, isTrue);
      expect(order.items.length, cart.items.length);
      expect(orders.findById(order.id), isNotNull);
      cart.clear();
    });

    test('canceling moves an order out of the active list', () {
      final cart = CartRepository.instance;
      final orders = OrderRepository.instance;

      cart.clear();
      cart.seedDemoItems();
      final order = orders.createFromCart(cart.items, cart.total);

      orders.cancelOrder(order.id, reason: "Ordered by mistake");
      final updated = orders.findById(order.id)!;

      expect(updated.status, OrderStatus.canceled);
      expect(updated.cancelReason, "Ordered by mistake");
      expect(orders.activeOrders.any((o) => o.id == order.id), isFalse);
      expect(orders.historyOrders.any((o) => o.id == order.id), isTrue);
      cart.clear();
    });
  });

  group('AddressRepository', () {
    final addresses = AddressRepository.instance;

    test('exactly one address is the default', () {
      expect(addresses.addresses.where((a) => a.isDefault).length, 1);
    });

    test('setDefault moves the flag', () {
      final target =
          addresses.addresses.firstWhere((address) => !address.isDefault);
      addresses.setDefault(target.id);

      expect(addresses.defaultAddress!.id, target.id);
      expect(addresses.addresses.where((a) => a.isDefault).length, 1);
    });

    test('add then delete restores a default', () {
      addresses.add(
        label: "Temp",
        fullName: "Temp User",
        phone: "1234567",
        addressLine: "1 Test Street",
        city: "Testville",
        zipCode: "00000",
        isDefault: true,
      );
      final added = addresses.addresses.last;
      expect(added.isDefault, isTrue);

      addresses.delete(added.id);
      expect(addresses.addresses.any((a) => a.id == added.id), isFalse);
      expect(addresses.defaultAddress, isNotNull);
    });
  });

  group('NotificationRepository', () {
    final notifications = NotificationRepository.instance;

    test('markAllAsRead clears the unread count', () {
      expect(notifications.unreadCount, greaterThan(0));
      notifications.markAllAsRead();
      expect(notifications.unreadCount, 0);
    });

    test('togglePreference flips the flag', () {
      final preference = notifications.preferences.first;
      final original = preference.isEnabled;

      notifications.togglePreference(preference.id, !original);
      expect(notifications.preferences.first.isEnabled, !original);

      notifications.togglePreference(preference.id, original);
    });
  });

  group('ReviewRepository', () {
    test('adding a review updates the summary', () {
      final reviews = ReviewRepository.instance;
      final before = reviews.summary;

      reviews.add(userName: "Tester", rating: 5, review: "Excellent product");
      final after = reviews.summary;

      expect(after.total, before.total + 1);
      expect(after.countFor(5), before.countFor(5) + 1);
      expect(reviews.reviews.first.userName, "Tester");
    });
  });

  group('SizeMeasurement', () {
    test('formats inches unchanged', () {
      expect(const SizeMeasurement(32).format(inCentimeters: false), "32");
      expect(
        const SizeMeasurement(24, 25).format(inCentimeters: false),
        "24–25",
      );
    });

    test('converts inches to centimeters correctly', () {
      // 32 in x 2.54 = 81.28 cm
      expect(
        const SizeMeasurement(32).format(inCentimeters: true),
        "81.3",
      );
      // 10 in x 2.54 = 25.4 cm
      expect(
        const SizeMeasurement(10).format(inCentimeters: true),
        "25.4",
      );
    });

    test('size chart covers every size label', () {
      expect(
        sizeGuideRows.map((row) => row.label),
        containsAll(<String>["XS", "S", "M", "L", "XL"]),
      );
    });
  });
}
