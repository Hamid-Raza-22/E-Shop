// Smoke tests for the shop app.
//
// Replaces the default Flutter counter-app template test, which asserted on
// widgets ('0', '1', Icons.add) that never existed in this project and so
// always failed.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shop/main.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;

void main() {
  testWidgets('App builds and shows the onboarding screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('generateRoute', () {
    test('returns a route for every active named route', () {
      const routes = [
        onbordingScreenRoute,
        logInScreenRoute,
        signUpScreenRoute,
        passwordRecoveryScreenRoute,
        productDetailsScreenRoute,
        productReviewsScreenRoute,
        homeScreenRoute,
        discoverScreenRoute,
        onSaleScreenRoute,
        kidsScreenRoute,
        searchScreenRoute,
        bookmarkScreenRoute,
        entryPointScreenRoute,
        profileScreenRoute,
        userInfoScreenRoute,
        notificationsScreenRoute,
        noNotificationScreenRoute,
        enableNotificationScreenRoute,
        notificationOptionsScreenRoute,
        addressesScreenRoute,
        ordersScreenRoute,
        preferencesScreenRoute,
        emptyWalletScreenRoute,
        walletScreenRoute,
        cartScreenRoute,
      ];

      for (final name in routes) {
        final route = router.generateRoute(RouteSettings(name: name));
        expect(route, isA<MaterialPageRoute<dynamic>>(),
            reason: 'route "$name" should resolve');
      }
    });

    test('falls back to a route for an unknown name', () {
      final route =
          router.generateRoute(const RouteSettings(name: 'does_not_exist'));
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });
  });
}
