import 'package:get/get.dart';

import '../controllers/address_controller.dart';
import '../controllers/bookmark_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/payment_controller.dart';
import '../controllers/product_search_controller.dart';
import '../controllers/review_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/wallet_controller.dart';
import '../services/admin_auth_service.dart';
import '../services/analytics_service.dart';
import '../services/customer_service.dart';
import '../services/order_service.dart';
import '../services/product_service.dart';
import '../services/promotion_service.dart';
import '../services/review_service.dart';

/// Dependency graph for the whole app.
///
/// Storefront controllers are `put` eagerly because they hold session state
/// (cart, bookmarks, …) that must survive route changes. Firestore services are
/// `lazyPut` with `fenix` so they are only built when a screen actually needs
/// them, and are rebuilt if they ever get disposed.
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // --- Firestore services --------------------------------------------------
    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);
    Get.lazyPut<OrderService>(() => OrderService(), fenix: true);
    Get.lazyPut<CustomerService>(() => CustomerService(), fenix: true);
    Get.lazyPut<ReviewService>(() => ReviewService(), fenix: true);
    Get.lazyPut<PromotionService>(() => PromotionService(), fenix: true);
    Get.lazyPut<AdminAuthService>(() => AdminAuthService(), fenix: true);
    Get.lazyPut<AnalyticsService>(
      () => AnalyticsService(
        orderService: Get.find<OrderService>(),
        customerService: Get.find<CustomerService>(),
        productService: Get.find<ProductService>(),
      ),
      fenix: true,
    );

    // --- Session state -------------------------------------------------------
    Get.put(CartController(), permanent: true);
    Get.put(OrderController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    Get.put(PaymentController(), permanent: true);
    Get.put(WalletController(), permanent: true);
    Get.put(BookmarkController(), permanent: true);
    Get.put(UserController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(ReviewController(), permanent: true);
    Get.put(ProductSearchController(), permanent: true);
  }
}
