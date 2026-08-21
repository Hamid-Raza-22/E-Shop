import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/admin/admin_auth_controller.dart';
import '../../../controllers/admin/admin_orders_controller.dart';
import '../../../controllers/admin/admin_products_controller.dart';
import '../../../controllers/admin/admin_reviews_controller.dart';
import '../../../l10n/app_localizations.dart';
import 'admin_customers_screen.dart';
import 'admin_login_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_overview_screen.dart';
import 'admin_products_screen.dart';
import 'admin_promotions_screen.dart';
import 'admin_reviews_screen.dart';
import 'admin_settings_screen.dart';
import 'components/admin_scaffold.dart';

/// Entry point of the owner dashboard.
///
/// Acts as the auth gate (sign-in → admin check → dashboard) and hosts every
/// section in an [IndexedStack] so switching sections keeps scroll position and
/// avoids re-subscribing Firestore listeners.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final auth = AdminAuthController.to;

      if (!auth.isSignedIn) return const AdminLoginScreen();
      if (!auth.isAdmin) return const _AccessDeniedView();

      return _DashboardShell(
        index: _index,
        onIndexChanged: (index) => setState(() => _index = index),
      );
    });
  }
}

class _DashboardShell extends StatelessWidget {
  const _DashboardShell({required this.index, required this.onIndexChanged});

  final int index;
  final ValueChanged<int> onIndexChanged;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    final sections = <(String, IconData, IconData, Widget)>[
      (
        translations.adminNavOverview,
        Icons.dashboard_outlined,
        Icons.dashboard,
        const AdminOverviewScreen(),
      ),
      (
        translations.adminNavProducts,
        Icons.inventory_2_outlined,
        Icons.inventory_2,
        const AdminProductsScreen(),
      ),
      (
        translations.adminNavOrders,
        Icons.receipt_long_outlined,
        Icons.receipt_long,
        const AdminOrdersScreen(),
      ),
      (
        translations.adminNavCustomers,
        Icons.people_outline,
        Icons.people,
        const AdminCustomersScreen(),
      ),
      (
        translations.adminNavReviews,
        Icons.star_outline,
        Icons.star,
        const AdminReviewsScreen(),
      ),
      (
        translations.adminNavPromotions,
        Icons.local_offer_outlined,
        Icons.local_offer,
        const AdminPromotionsScreen(),
      ),
      (
        translations.adminNavSettings,
        Icons.settings_outlined,
        Icons.settings,
        const AdminSettingsScreen(),
      ),
    ];

    // Badges read live counts so the owner sees work waiting for them.
    return Obx(() {
      final badges = <int, int>{
        1: AdminProductsController.to.lowStockCount,
        2: AdminOrdersController.to.openCount,
        4: AdminReviewsController.to.pendingCount,
      };

      return AdminScaffold(
        title: sections[index].$1,
        selectedIndex: index,
        onDestinationSelected: onIndexChanged,
        destinations: [
          for (var i = 0; i < sections.length; i++)
            AdminDestination(
              label: sections[i].$1,
              icon: sections[i].$2,
              selectedIcon: sections[i].$3,
              badgeCount: badges[i] ?? 0,
            ),
        ],
        child: IndexedStack(
          index: index,
          children: [for (final section in sections) section.$4],
        ),
      );
    });
  }
}

class _AccessDeniedView extends StatelessWidget {
  const _AccessDeniedView();

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48, color: errorColor),
                const SizedBox(height: defaultPadding),
                Text(
                  translations.adminAccessDenied,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: defaultPadding / 2),
                Text(
                  translations.adminAccessDeniedMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: defaultPadding * 1.5),
                OutlinedButton.icon(
                  onPressed: AdminAuthController.to.signOut,
                  icon: const Icon(Icons.logout),
                  label: Text(translations.actionSignOut),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
