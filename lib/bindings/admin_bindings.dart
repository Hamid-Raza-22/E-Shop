import 'package:get/get.dart';

import '../controllers/admin/admin_auth_controller.dart';
import '../controllers/admin/admin_customers_controller.dart';
import '../controllers/admin/admin_dashboard_controller.dart';
import '../controllers/admin/admin_orders_controller.dart';
import '../controllers/admin/admin_products_controller.dart';
import '../controllers/admin/admin_promotions_controller.dart';
import '../controllers/admin/admin_reviews_controller.dart';

/// Controllers that only exist while the owner is inside the dashboard.
///
/// They are `lazyPut` so opening the dashboard does not immediately attach a
/// Firestore listener for every section — each controller binds its stream the
/// first time its screen is shown. `fenix` lets a section be revisited after
/// GetX disposed it.
class AdminBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminAuthController>(() => AdminAuthController(), fenix: true);
    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(),
      fenix: true,
    );
    Get.lazyPut<AdminProductsController>(
      () => AdminProductsController(),
      fenix: true,
    );
    Get.lazyPut<AdminOrdersController>(
      () => AdminOrdersController(),
      fenix: true,
    );
    Get.lazyPut<AdminCustomersController>(
      () => AdminCustomersController(),
      fenix: true,
    );
    Get.lazyPut<AdminReviewsController>(
      () => AdminReviewsController(),
      fenix: true,
    );
    Get.lazyPut<AdminPromotionsController>(
      () => AdminPromotionsController(),
      fenix: true,
    );
  }
}
