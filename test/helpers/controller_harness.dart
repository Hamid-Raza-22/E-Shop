import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shop/config/app_env.dart';
import 'package:shop/controllers/address_controller.dart';
import 'package:shop/controllers/bookmark_controller.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/controllers/notification_controller.dart';
import 'package:shop/controllers/order_controller.dart';
import 'package:shop/controllers/payment_controller.dart';
import 'package:shop/controllers/product_search_controller.dart';
import 'package:shop/controllers/review_controller.dart';
import 'package:shop/controllers/user_controller.dart';
import 'package:shop/controllers/wallet_controller.dart';

/// Registers the storefront controllers the widgets resolve through `Get.find`.
///
/// Mirrors `InitialBindings` but leaves out the Firestore services, so tests
/// never touch the network. Call [disposeStorefrontControllers] afterwards to
/// get a clean slate between test files.
Future<void> registerStorefrontControllers() async {
  // Screens format dates/money through `intl`, which needs its locale symbols
  // loaded exactly like `main()` does.
  await initializeDateFormatting();

  AppEnv.loadForTest(const {
    "APP_NAME": "Gogguz Test",
    "DEFAULT_LOCALE": "en",
    "CURRENCY_CODE": "USD",
  });

  Get.testMode = true;
  Get.put(CartController());
  Get.put(OrderController());
  Get.put(AddressController());
  Get.put(PaymentController());
  Get.put(WalletController());
  Get.put(BookmarkController());
  Get.put(UserController());
  Get.put(NotificationController());
  Get.put(ReviewController());
  Get.put(ProductSearchController());
}

void disposeStorefrontControllers() => Get.reset();
