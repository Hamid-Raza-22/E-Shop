import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/bindings/admin_bindings.dart';
import 'package:shop/models/order_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/controllers/order_controller.dart';
import 'package:shop/controllers/user_controller.dart';

import 'screen_export.dart';

/// Resolves an order id from route arguments.
///
/// Falls back to the most recent (optionally active) order so order routes can
/// be opened without arguments, e.g. from a deep link or a demo menu.
String _resolveOrderId(Object? arguments, {bool activeOnly = false}) {
  if (arguments is String && arguments.isNotEmpty) return arguments;

  final repository = OrderController.to;
  final candidates =
      activeOnly ? repository.activeOrders : repository.orders;
  return candidates.isEmpty ? "" : candidates.first.id;
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
    case notificationPermissionScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationPermissionScreen(),
      );
    case preferredLanuageScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferredLanguageScreen(),
      );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case profileSetupScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileSetupScreen(),
      );
    case passwordRecoveryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PasswordRecoveryScreen(),
      );
    case verificationMethodScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const VerificationMethodScreen(),
      );
    case otpScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          // Optional destination (email/phone) the code was sent to.
          final destination = settings.arguments as String? ??
              UserController.to.user.email;
          return OtpScreen(
            destination: destination,
            onVerified: () =>
                Navigator.pushNamed(context, doneResetPasswordScreenRoute),
          );
        },
      );
    case newPasswordScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          final email = settings.arguments as String? ?? "";
          return SetNewPasswordScreen(email: email);
        },
      );
    case doneResetPasswordScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const DoneResetPasswordScreen(),
      );
    case termsOfServicesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const TermsOfServicesScreen(),
      );
    case noInternetScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NoInternetScreen(),
      );
    case serverErrorScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ServerErrorScreen(),
      );
    case signUpVerificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>
            SignUpVerificationScreen(email: settings.arguments as String?),
      );
    case setupFingerprintScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>
            const BiometricSetupScreen(type: BiometricType.fingerprint),
      );
    case setupFaceIdScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>
            const BiometricSetupScreen(type: BiometricType.faceId),
      );
    case currentPasswordScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const CurrentPasswordScreen(),
      );
    case productDetailsScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          // A real catalog product decides its own availability; the legacy bool
          // argument still drives the demo product.
          final arguments = settings.arguments;
          if (arguments is ProductModel) {
            return ProductDetailsScreen(product: arguments);
          }
          return ProductDetailsScreen(
            isProductAvailable: arguments as bool? ?? true,
          );
        },
      );
    case productReviewsScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>
            ProductReviewsScreen(productId: settings.arguments as String?),
      );
    case addReviewsScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>
            AddReviewScreen(productId: settings.arguments as String?),
      );
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    case brandScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          final brandName = settings.arguments as String?;
          return brandName == null
              ? const BrandScreen()
              : BrandScreen(brandName: brandName);
        },
      );
    case discoverWithImageScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const DiscoverWithImageScreen(),
      );
    case subDiscoverScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          final title = settings.arguments as String?;
          return title == null
              ? const SubDiscoverScreen()
              : SubDiscoverScreen(title: title);
        },
      );
    case discoverScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const DiscoverScreen(),
      );
    case onSaleScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnSaleScreen(),
      );
    case kidsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const KidsScreen(),
      );
    case searchScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    case searchHistoryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SearchHistoryScreen(),
      );
    case bookmarkScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const BookmarkScreen(),
      );
    case entryPointScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );
    case getHelpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const GetHelpScreen(),
      );
    case chatScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      );
    case userInfoScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    case editUserInfoScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EditUserInfoScreen(),
      );
    case notificationsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      );
    case noNotificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NoNotificationScreen(),
      );
    case enableNotificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EnableNotificationScreen(),
      );
    case notificationOptionsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationOptionsScreen(),
      );
    case selectLanguageScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SelectLanguageScreen(),
      );
    case noAddressScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NoAddressScreen(),
      );
    case addressesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const AddressesScreen(),
      );
    case addNewAddressesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const AddNewAddressScreen(),
      );
    case ordersScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OrdersScreen(),
      );
    // The order screens below need an order id; they fall back to the first
    // matching order so the routes stay usable without arguments.
    case orderProcessingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => OrderProcessingScreen(
          orderId: _resolveOrderId(settings.arguments, activeOnly: true),
        ),
      );
    case orderDetailsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderId: _resolveOrderId(settings.arguments),
        ),
      );
    case cancleOrderScreenRoute:
      return MaterialPageRoute(
        builder: (context) => CancelOrderScreen(
          orderId: _resolveOrderId(settings.arguments, activeOnly: true),
        ),
      );
    case deliveredOrdersScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>
            const FilteredOrdersScreen(status: OrderStatus.delivered),
      );
    case cancledOrdersScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>
            const FilteredOrdersScreen(status: OrderStatus.canceled),
      );
    case preferencesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      );
    case emptyPaymentScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EmptyPaymentScreen(),
      );
    case emptyCartScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EmptyCartScreen(),
      );
    case emptyWalletScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EmptyWalletScreen(),
      );
    case walletScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const WalletScreen(),
      );
    case cartScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const CartScreen(),
      );
    case paymentMethodScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PaymentMethodScreen(),
      );
    case addNewCardScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const AddNewCardScreen(),
      );
    case thanksForOrderScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          // Order id is passed so the screen can show it in the confirmation.
          final orderId = settings.arguments as String?;
          return ThanksForOrderScreen(orderId: orderId);
        },
      );
    case sizeGuideScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SizeGuideScreen(),
      );
    case adminDashboardScreenRoute:
      // The dashboard registers its own controllers and gates itself behind an
      // admin sign-in, so no guard is needed on the route itself.
      return GetPageRoute(
        settings: settings,
        binding: AdminBindings(),
        page: () => const AdminDashboardScreen(),
      );
    default:
      // Unknown route: show a real "not found" screen instead of silently
      // dropping the user back on onboarding.
      return MaterialPageRoute(
        builder: (context) => RouteNotFoundScreen(routeName: settings.name),
      );
  }
}
