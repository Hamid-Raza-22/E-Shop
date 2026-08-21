// Smoke tests for the shop app.
//
// Replaces the default Flutter counter-app template test, which asserted on
// widgets ('0', '1', Icons.add) that never existed in this project and so
// always failed.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:shop/controllers/localization_controller.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;

import 'helpers/controller_harness.dart';

void main() {
  setUp(registerStorefrontControllers);
  tearDown(disposeStorefrontControllers);

  testWidgets('App shell builds with localizations and GetX wired up',
      (WidgetTester tester) async {
    Get.put(LocalizationController());

    // `MyApp` itself boots Firebase in main(), which a widget test cannot do,
    // so the same GetMaterialApp configuration is exercised here instead.
    await tester.pumpWidget(
      GetMaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: LocalizationController.supportedLocales,
        locale: const Locale("en"),
        onGenerateRoute: router.generateRoute,
        initialRoute: onbordingScreenRoute,
      ),
    );
    await tester.pump();

    expect(find.byType(GetMaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('German locale resolves German strings',
      (WidgetTester tester) async {
    late AppLocalizations translations;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: LocalizationController.supportedLocales,
        locale: const Locale("de"),
        home: Builder(
          builder: (context) {
            translations = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    expect(translations.localeName, "de");
    expect(translations.adminNavProducts, isNot("Products"));
    expect(translations.cartItemsCount(3), contains("3"));
  });

  test('every shipped locale has a translation file', () {
    for (final language in LocalizationController.supportedLanguages) {
      expect(
        AppLocalizations.supportedLocales
            .map((locale) => locale.languageCode)
            .contains(language.code),
        isTrue,
        reason: 'missing ARB for "${language.code}"',
      );
    }
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

    test('the dashboard route carries its own bindings', () {
      final route = router.generateRoute(
        const RouteSettings(name: adminDashboardScreenRoute),
      );
      expect(route, isA<GetPageRoute<dynamic>>());
    });

    test('falls back to a route for an unknown name', () {
      final route =
          router.generateRoute(const RouteSettings(name: 'does_not_exist'));
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });
  });
}
