// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gogguz';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionClose => 'Close';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionApply => 'Apply';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get actionSeeAll => 'See all';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionSignIn => 'Sign in';

  @override
  String get actionSignOut => 'Sign out';

  @override
  String get actionYes => 'Yes';

  @override
  String get actionNo => 'No';

  @override
  String get labelEmail => 'E-mail';

  @override
  String get labelPassword => 'Password';

  @override
  String get labelName => 'Name';

  @override
  String get labelPhone => 'Phone';

  @override
  String get labelStatus => 'Status';

  @override
  String get labelDate => 'Date';

  @override
  String get labelAll => 'All';

  @override
  String get labelLoading => 'Loading…';

  @override
  String get labelPrice => 'Price';

  @override
  String get labelQuantity => 'Quantity';

  @override
  String get labelSize => 'Size';

  @override
  String get labelTotal => 'Total';

  @override
  String get labelSubtotal => 'Subtotal';

  @override
  String get labelShipping => 'Shipping';

  @override
  String get labelDiscount => 'Discount';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationInvalidEmail => 'Enter a valid e-mail address';

  @override
  String validationMinLength(int count) {
    return 'Must be at least $count characters';
  }

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNoConnection => 'No internet connection.';

  @override
  String get errorNotFound => 'We couldn\'t find that page.';

  @override
  String get navHome => 'Home';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navBookmark => 'Bookmark';

  @override
  String get navProfile => 'Profile';

  @override
  String get navCart => 'Cart';

  @override
  String get storefrontOnSale => 'On sale';

  @override
  String get storefrontKids => 'Kids';

  @override
  String get storefrontSizeGuide => 'Size guide';

  @override
  String get storefrontSearchHint => 'Find something you love';

  @override
  String get storefrontAddToCart => 'Add to cart';

  @override
  String get storefrontBuyNow => 'Buy now';

  @override
  String get storefrontOutOfStock => 'Out of stock';

  @override
  String get storefrontReviews => 'Reviews';

  @override
  String get storefrontWallet => 'Wallet';

  @override
  String get storefrontAddresses => 'Addresses';

  @override
  String get storefrontNotifications => 'Notifications';

  @override
  String get storefrontOrders => 'Orders';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyMessage =>
      'Browse the shop and add the pieces you like — they\'ll show up here.';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutPlaceOrder => 'Place order';

  @override
  String checkoutPayAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get checkoutSelectCard => 'Select or add a card to continue.';

  @override
  String get checkoutEnterCvv => 'Enter the card\'s CVV to continue.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSelectLanguage => 'Select language';

  @override
  String settingsLanguageChanged(String language) {
    return 'Language changed to $language';
  }

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsAbout => 'About';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageFrench => 'French';

  @override
  String get adminDashboard => 'Dashboard';

  @override
  String get adminSignInTitle => 'Owner sign in';

  @override
  String get adminSignInSubtitle =>
      'Sign in with your administrator account to manage the shop.';

  @override
  String get adminAccessDenied => 'Access denied';

  @override
  String get adminAccessDeniedMessage =>
      'This account is not registered as a shop administrator.';

  @override
  String adminWelcome(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get adminNavOverview => 'Overview';

  @override
  String get adminNavProducts => 'Products';

  @override
  String get adminNavOrders => 'Orders';

  @override
  String get adminNavCustomers => 'Customers';

  @override
  String get adminNavReviews => 'Reviews';

  @override
  String get adminNavPromotions => 'Promotions';

  @override
  String get adminNavSettings => 'Settings';

  @override
  String get adminKpiRevenueToday => 'Revenue today';

  @override
  String get adminKpiRevenueTotal => 'Total revenue';

  @override
  String get adminKpiOrders => 'Orders';

  @override
  String get adminKpiAverageOrderValue => 'Average order value';

  @override
  String get adminKpiNewCustomers => 'New customers';

  @override
  String get adminKpiLowStock => 'Low stock';

  @override
  String adminSalesLastDays(int count) {
    return 'Sales — last $count days';
  }

  @override
  String get adminTopProducts => 'Top products';

  @override
  String get adminRecentOrders => 'Recent orders';

  @override
  String get adminNoData => 'No data yet';

  @override
  String get adminProductsTitle => 'Products';

  @override
  String get adminProductAdd => 'Add product';

  @override
  String get adminProductEdit => 'Edit product';

  @override
  String get adminProductDelete => 'Delete product';

  @override
  String adminProductDeleteConfirm(String title) {
    return 'Delete “$title”? This cannot be undone.';
  }

  @override
  String get adminProductSaved => 'Product saved';

  @override
  String get adminProductDeleted => 'Product deleted';

  @override
  String get adminProductNone =>
      'No products yet. Add your first product to get started.';

  @override
  String get adminFieldTitle => 'Title';

  @override
  String get adminFieldBrand => 'Brand';

  @override
  String get adminFieldCategory => 'Category';

  @override
  String get adminFieldDescription => 'Description';

  @override
  String get adminFieldImageUrl => 'Image URL';

  @override
  String get adminFieldStock => 'Stock';

  @override
  String get adminFieldSku => 'SKU';

  @override
  String get adminFieldDiscountPercent => 'Discount %';

  @override
  String get adminFieldPublished => 'Published';

  @override
  String get adminStatePublished => 'Published';

  @override
  String get adminStateDraft => 'Draft';

  @override
  String adminStockLeft(int count) {
    return '$count left';
  }

  @override
  String get adminOrdersTitle => 'Orders';

  @override
  String adminOrderNumber(String id) {
    return 'Order $id';
  }

  @override
  String get adminOrderUpdateStatus => 'Update status';

  @override
  String get adminOrderStatusUpdated => 'Order status updated';

  @override
  String get adminOrderNone => 'No orders match this filter.';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCanceled => 'Canceled';

  @override
  String get orderStatusReturned => 'Returned';

  @override
  String get adminCustomersTitle => 'Customers';

  @override
  String adminCustomerSince(String date) {
    return 'Customer since $date';
  }

  @override
  String get adminCustomerTotalSpent => 'Total spent';

  @override
  String get adminCustomerOrders => 'Orders placed';

  @override
  String get adminCustomerBlock => 'Block customer';

  @override
  String get adminCustomerUnblock => 'Unblock customer';

  @override
  String get adminCustomerBlocked => 'Blocked';

  @override
  String get adminCustomerNone => 'No customers yet.';

  @override
  String get adminReviewsTitle => 'Reviews';

  @override
  String get adminReviewsPending => 'Pending approval';

  @override
  String get adminReviewApprove => 'Approve';

  @override
  String get adminReviewReject => 'Reject';

  @override
  String get adminReviewNone => 'Nothing to moderate.';

  @override
  String get adminPromotionsTitle => 'Promotions';

  @override
  String get adminPromoCreate => 'Create promotion';

  @override
  String get adminPromoCode => 'Promo code';

  @override
  String get adminPromoPercentOff => 'Percent off';

  @override
  String get adminPromoValidFrom => 'Valid from';

  @override
  String get adminPromoValidTo => 'Valid to';

  @override
  String get adminPromoUsageLimit => 'Usage limit';

  @override
  String get adminPromoActive => 'Active';

  @override
  String get adminPromoInactive => 'Inactive';

  @override
  String get adminPromoNone => 'No promotions yet.';

  @override
  String get adminSettingsStoreName => 'Store name';

  @override
  String get adminSettingsCurrency => 'Currency';

  @override
  String get adminSettingsSupportEmail => 'Support e-mail';

  @override
  String get adminSettingsEnvironment => 'Environment';
}
