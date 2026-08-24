import 'package:flutter_test/flutter_test.dart';
import 'package:shop/models/order_model.dart';
import 'package:shop/models/payment_card_model.dart';
import 'package:shop/controllers/address_controller.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/controllers/notification_controller.dart';
import 'package:shop/controllers/order_controller.dart';
import 'package:shop/controllers/payment_controller.dart';
import 'package:shop/controllers/review_controller.dart';
import 'package:shop/controllers/product_search_controller.dart';
import 'package:shop/controllers/wallet_controller.dart';
import 'package:shop/screens/product/views/components/inches_size_table.dart';

import 'helpers/controller_harness.dart';

void main() {
  setUpAll(registerStorefrontControllers);
  tearDownAll(disposeStorefrontControllers);

  group('ProductSearchController', () {
    late final ProductSearchController search = ProductSearchController.to;

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
      for (var i = 0; i < ProductSearchController.maxHistoryLength + 5; i++) {
        search.addToHistory("term$i");
      }
      expect(search.history.length, ProductSearchController.maxHistoryLength);
    });
  });

  group('OrderController', () {
    test('creating an order from the cart adds an active order', () async {
      late final CartController cart = CartController.to;
      late final OrderController orders = OrderController.to;

      cart.clear();
      cart.seedDemoItems();
      final activeBefore = orders.activeOrders.length;

      final order = (await orders.createFromCart(cart.items, cart.total))!;

      expect(orders.activeOrders.length, activeBefore + 1);
      expect(order.isActive, isTrue);
      expect(order.status, OrderStatus.pending);
      expect(order.items.length, cart.items.length);
      expect(orders.findById(order.id), isNotNull);
      cart.clear();
    });

    test('order ids are unique across placements', () async {
      late final CartController cart = CartController.to;
      late final OrderController orders = OrderController.to;

      cart.clear();
      cart.seedDemoItems();
      final first = (await orders.createFromCart(cart.items, cart.total))!;
      final second = (await orders.createFromCart(cart.items, cart.total))!;

      expect(first.id, isNot(second.id));
      cart.clear();
    });

    test('canceling moves an order out of the active list', () async {
      late final CartController cart = CartController.to;
      late final OrderController orders = OrderController.to;

      cart.clear();
      cart.seedDemoItems();
      final order = (await orders.createFromCart(cart.items, cart.total))!;

      await orders.cancelOrder(order.id, reason: "Ordered by mistake");
      final updated = orders.findById(order.id)!;

      expect(updated.status, OrderStatus.canceled);
      expect(updated.cancelReason, "Ordered by mistake");
      expect(orders.activeOrders.any((o) => o.id == order.id), isFalse);
      expect(orders.historyOrders.any((o) => o.id == order.id), isTrue);
      cart.clear();
    });
  });

  group('AddressController', () {
    late final AddressController addresses = AddressController.to;

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

  group('NotificationController', () {
    late final NotificationController notifications = NotificationController.to;

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

  group('ReviewController', () {
    test('adding a review updates the summary', () {
      late final ReviewController reviews = ReviewController.to;
      final before = reviews.summary;

      reviews.add(userName: "Tester", rating: 5, review: "Excellent product");
      final after = reviews.summary;

      expect(after.total, before.total + 1);
      expect(after.countFor(5), before.countFor(5) + 1);
      expect(reviews.reviews.first.userName, "Tester");
    });
  });

  group('PaymentController', () {
    late final PaymentController payment = PaymentController.to;

    test('a card selection needs a valid CVV before checkout', () {
      payment.selectCard(payment.cards.first.id);
      expect(payment.canCheckout, isFalse);

      payment.setCvv("12");
      expect(payment.canCheckout, isFalse);

      payment.setCvv("123");
      expect(payment.canCheckout, isTrue);
    });

    test('switching payment option drops the CVV', () {
      payment.selectCard(payment.cards.first.id);
      payment.setCvv("123");

      payment.selectOption(PaymentOption.cashOnDelivery);
      expect(payment.cvv, isEmpty);
      // Non-card options don't need a CVV.
      expect(payment.canCheckout, isTrue);
    });

    test('adding a card stores only the last four digits', () {
      payment.addCard(
        holderName: "Test User",
        cardNumber: "4111 1111 1111 9876",
        expiryDate: "01/30",
      );
      final added = payment.cards.last;

      expect(added.last4Digits, "9876");
      expect(payment.selectedCardId, added.id);

      payment.removeCard(added.id);
      expect(payment.cards.any((card) => card.id == added.id), isFalse);
    });
  });

  group('WalletController', () {
    late final WalletController wallet = WalletController.to;

    test('spending more than the balance is rejected', () {
      final before = wallet.balance;
      expect(wallet.spend(before + 1), isFalse);
      expect(wallet.balance, before);
    });

    test('spend and top up adjust the balance and history', () {
      final before = wallet.balance;
      final transactions = wallet.transactions.length;

      expect(wallet.spend(10), isTrue);
      expect(wallet.balance, closeTo(before - 10, 0.001));

      wallet.topUp(10);
      expect(wallet.balance, closeTo(before, 0.001));
      expect(wallet.transactions.length, transactions + 2);
    });

    test('non-positive amounts are ignored', () {
      final before = wallet.balance;
      expect(wallet.spend(0), isFalse);
      wallet.topUp(-5);
      expect(wallet.balance, before);
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
