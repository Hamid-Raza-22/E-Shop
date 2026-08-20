// Renders every converted screen to prove it builds without throwing and that
// the BuyFullKit placeholder is gone.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop/components/buy_full_ui_kit.dart';
import 'package:shop/repositories/cart_repository.dart';
import 'package:shop/screens/address/views/addresses_screen.dart';
import 'package:shop/screens/checkout/views/cart_screen.dart';
import 'package:shop/screens/kids/views/kids_screen.dart';
import 'package:shop/screens/notification/view/enable_notification_screen.dart';
import 'package:shop/screens/notification/view/no_notification_screen.dart';
import 'package:shop/screens/notification/view/notification_ontions_screen.dart';
import 'package:shop/screens/notification/view/notificatios_screen.dart';
import 'package:shop/screens/on_sale/views/on_sale_screen.dart';
import 'package:shop/screens/order/views/orders_screen.dart';
import 'package:shop/screens/product/views/product_info_screen.dart';
import 'package:shop/screens/product/views/shipping_info_screen.dart';
import 'package:shop/screens/product/views/size_guide_screen.dart';
import 'package:shop/screens/reviews/view/product_reviews_screen.dart';
import 'package:shop/screens/search/views/search_screen.dart';
import 'package:shop/screens/user_info/views/edit_user_info_screen.dart';
import 'package:shop/screens/user_info/views/user_info_screen.dart';

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  final screens = <String, Widget Function()>{
    "CartScreen (empty)": () => const CartScreen(),
    "SearchScreen": () => const SearchScreen(),
    "OrdersScreen": () => const OrdersScreen(),
    "AddressesScreen": () => const AddressesScreen(),
    "UserInfoScreen": () => const UserInfoScreen(),
    "EditUserInfoScreen": () => const EditUserInfoScreen(),
    "NotificationsScreen": () => const NotificationsScreen(),
    "NoNotificationScreen": () => const NoNotificationScreen(),
    "NotificationOptionsScreen": () => const NotificationOptionsScreen(),
    "EnableNotificationScreen": () => const EnableNotificationScreen(),
    "ProductReviewsScreen": () => const ProductReviewsScreen(),
    "KidsScreen": () => const KidsScreen(),
    "OnSaleScreen": () => const OnSaleScreen(),
    "SizeGuideScreen": () => const SizeGuideScreen(),
  };

  // These are bottom-sheet bodies, not routes: in the app they get their
  // Material ancestor from showModalBottomSheet, so the harness supplies one.
  final sheets = <String, Widget Function()>{
    "ProductInfoScreen": () => const ProductInfoScreen(),
    "ShippingInfoScreen": () => const ShippingInfoScreen(),
  };

  <String, Widget Function()>{
    ...screens,
    ...sheets.map((name, builder) =>
        MapEntry(name, () => Scaffold(body: builder()))),
  }.forEach((name, builder) {
    testWidgets("$name builds without BuyFullKit", (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(home: builder()));
      await tester.pump();

      expect(find.byType(BuyFullKit), findsNothing, reason: "$name still uses BuyFullKit");
      expect(tester.takeException(), isNull, reason: "$name threw while building");
    });
  });

  testWidgets("Cart shows items and updates the total", (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final cart = CartRepository.instance;
    cart.clear();
    cart.seedDemoItems();
    final subtotalBefore = cart.subtotal;

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pump();

    expect(find.text("Review your order"), findsOneWidget);
    expect(find.text("Order Summary"), findsOneWidget);

    // Increment the first line item through the repository and rebuild.
    cart.increment(cart.items.first);
    await tester.pump();

    expect(cart.subtotal, greaterThan(subtotalBefore));
    expect(tester.takeException(), isNull);
    cart.clear();
  });

  testWidgets("Empty cart shows the empty state", (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    // CartScreen seeds demo items on init, so clear after the first frame.
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pump();

    CartRepository.instance.clear();
    await tester.pump();

    expect(find.text("Your cart is empty"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets("Size guide converts inches to centimeters", (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: SizeGuideScreen()));
    await tester.pump();

    // Inches by default: bust 32 for XS.
    expect(find.text("32"), findsWidgets);

    await tester.tap(find.text("Centimeters"));
    await tester.pump();

    // 32 in -> 81.3 cm
    expect(find.text("81.3"), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
