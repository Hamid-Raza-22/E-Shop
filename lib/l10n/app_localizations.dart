import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ur')
  ];

  /// Application name shown in the OS task switcher
  ///
  /// In en, this message translates to:
  /// **'Gogguz'**
  String get appTitle;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApply;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// No description provided for @actionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get actionSeeAll;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get actionSignIn;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get actionSignOut;

  /// No description provided for @actionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get actionYes;

  /// No description provided for @actionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get actionNo;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get labelEmail;

  /// No description provided for @labelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelPassword;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @labelPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get labelPhone;

  /// No description provided for @labelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get labelStatus;

  /// No description provided for @labelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get labelDate;

  /// No description provided for @labelAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get labelAll;

  /// No description provided for @labelLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get labelLoading;

  /// No description provided for @labelPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get labelPrice;

  /// No description provided for @labelQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get labelQuantity;

  /// No description provided for @labelSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get labelSize;

  /// No description provided for @labelTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// No description provided for @labelSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get labelSubtotal;

  /// No description provided for @labelShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get labelShipping;

  /// No description provided for @labelDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get labelDiscount;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid e-mail address'**
  String get validationInvalidEmail;

  /// No description provided for @validationMinLength.
  ///
  /// In en, this message translates to:
  /// **'Must be at least {count} characters'**
  String validationMinLength(int count);

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNoConnection;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that page.'**
  String get errorNotFound;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get navBookmark;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @storefrontOnSale.
  ///
  /// In en, this message translates to:
  /// **'On sale'**
  String get storefrontOnSale;

  /// No description provided for @storefrontKids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get storefrontKids;

  /// No description provided for @storefrontSizeGuide.
  ///
  /// In en, this message translates to:
  /// **'Size guide'**
  String get storefrontSizeGuide;

  /// No description provided for @storefrontSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Find something you love'**
  String get storefrontSearchHint;

  /// No description provided for @storefrontAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get storefrontAddToCart;

  /// No description provided for @storefrontBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get storefrontBuyNow;

  /// No description provided for @storefrontOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get storefrontOutOfStock;

  /// No description provided for @storefrontReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get storefrontReviews;

  /// No description provided for @storefrontWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get storefrontWallet;

  /// No description provided for @storefrontAddresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get storefrontAddresses;

  /// No description provided for @storefrontNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get storefrontNotifications;

  /// No description provided for @storefrontOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get storefrontOrders;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Browse the shop and add the pieces you like — they\'ll show up here.'**
  String get cartEmptyMessage;

  /// No description provided for @cartItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String cartItemsCount(int count);

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutPayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String checkoutPayAmount(String amount);

  /// No description provided for @checkoutSelectCard.
  ///
  /// In en, this message translates to:
  /// **'Select or add a card to continue.'**
  String get checkoutSelectCard;

  /// No description provided for @checkoutEnterCvv.
  ///
  /// In en, this message translates to:
  /// **'Enter the card\'s CVV to continue.'**
  String get checkoutEnterCvv;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get settingsSelectLanguage;

  /// No description provided for @settingsLanguageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String settingsLanguageChanged(String language);

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get adminDashboard;

  /// No description provided for @adminSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner sign in'**
  String get adminSignInTitle;

  /// No description provided for @adminSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your administrator account to manage the shop.'**
  String get adminSignInSubtitle;

  /// No description provided for @adminAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get adminAccessDenied;

  /// No description provided for @adminAccessDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'This account is not registered as a shop administrator.'**
  String get adminAccessDeniedMessage;

  /// No description provided for @adminWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String adminWelcome(String name);

  /// No description provided for @adminNavOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get adminNavOverview;

  /// No description provided for @adminNavProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get adminNavProducts;

  /// No description provided for @adminNavOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get adminNavOrders;

  /// No description provided for @adminNavCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get adminNavCustomers;

  /// No description provided for @adminNavReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get adminNavReviews;

  /// No description provided for @adminNavPromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get adminNavPromotions;

  /// No description provided for @adminNavSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adminNavSettings;

  /// No description provided for @adminKpiRevenueToday.
  ///
  /// In en, this message translates to:
  /// **'Revenue today'**
  String get adminKpiRevenueToday;

  /// No description provided for @adminKpiRevenueTotal.
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get adminKpiRevenueTotal;

  /// No description provided for @adminKpiOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get adminKpiOrders;

  /// No description provided for @adminKpiAverageOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Average order value'**
  String get adminKpiAverageOrderValue;

  /// No description provided for @adminKpiNewCustomers.
  ///
  /// In en, this message translates to:
  /// **'New customers'**
  String get adminKpiNewCustomers;

  /// No description provided for @adminKpiLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get adminKpiLowStock;

  /// No description provided for @adminSalesLastDays.
  ///
  /// In en, this message translates to:
  /// **'Sales — last {count} days'**
  String adminSalesLastDays(int count);

  /// No description provided for @adminTopProducts.
  ///
  /// In en, this message translates to:
  /// **'Top products'**
  String get adminTopProducts;

  /// No description provided for @adminRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get adminRecentOrders;

  /// No description provided for @adminNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get adminNoData;

  /// No description provided for @adminProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get adminProductsTitle;

  /// No description provided for @adminProductAdd.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get adminProductAdd;

  /// No description provided for @adminProductEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get adminProductEdit;

  /// No description provided for @adminProductDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get adminProductDelete;

  /// No description provided for @adminProductDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete “{title}”? This cannot be undone.'**
  String adminProductDeleteConfirm(String title);

  /// No description provided for @adminProductSaved.
  ///
  /// In en, this message translates to:
  /// **'Product saved'**
  String get adminProductSaved;

  /// No description provided for @adminProductDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted'**
  String get adminProductDeleted;

  /// No description provided for @adminProductNone.
  ///
  /// In en, this message translates to:
  /// **'No products yet. Add your first product to get started.'**
  String get adminProductNone;

  /// No description provided for @adminFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminFieldTitle;

  /// No description provided for @adminFieldBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get adminFieldBrand;

  /// No description provided for @adminFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get adminFieldCategory;

  /// No description provided for @adminFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminFieldDescription;

  /// No description provided for @adminFieldImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get adminFieldImageUrl;

  /// No description provided for @adminFieldStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get adminFieldStock;

  /// No description provided for @adminFieldSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get adminFieldSku;

  /// No description provided for @adminFieldDiscountPercent.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get adminFieldDiscountPercent;

  /// No description provided for @adminFieldPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get adminFieldPublished;

  /// No description provided for @adminStatePublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get adminStatePublished;

  /// No description provided for @adminStateDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get adminStateDraft;

  /// No description provided for @adminStockLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String adminStockLeft(int count);

  /// No description provided for @adminOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get adminOrdersTitle;

  /// No description provided for @adminOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order {id}'**
  String adminOrderNumber(String id);

  /// No description provided for @adminOrderUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get adminOrderUpdateStatus;

  /// No description provided for @adminOrderStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Order status updated'**
  String get adminOrderStatusUpdated;

  /// No description provided for @adminOrderNone.
  ///
  /// In en, this message translates to:
  /// **'No orders match this filter.'**
  String get adminOrderNone;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get orderStatusCanceled;

  /// No description provided for @orderStatusReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get orderStatusReturned;

  /// No description provided for @adminCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get adminCustomersTitle;

  /// No description provided for @adminCustomerSince.
  ///
  /// In en, this message translates to:
  /// **'Customer since {date}'**
  String adminCustomerSince(String date);

  /// No description provided for @adminCustomerTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get adminCustomerTotalSpent;

  /// No description provided for @adminCustomerOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders placed'**
  String get adminCustomerOrders;

  /// No description provided for @adminCustomerBlock.
  ///
  /// In en, this message translates to:
  /// **'Block customer'**
  String get adminCustomerBlock;

  /// No description provided for @adminCustomerUnblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock customer'**
  String get adminCustomerUnblock;

  /// No description provided for @adminCustomerBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get adminCustomerBlocked;

  /// No description provided for @adminCustomerNone.
  ///
  /// In en, this message translates to:
  /// **'No customers yet.'**
  String get adminCustomerNone;

  /// No description provided for @adminReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get adminReviewsTitle;

  /// No description provided for @adminReviewsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending approval'**
  String get adminReviewsPending;

  /// No description provided for @adminReviewApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get adminReviewApprove;

  /// No description provided for @adminReviewReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get adminReviewReject;

  /// No description provided for @adminReviewNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing to moderate.'**
  String get adminReviewNone;

  /// No description provided for @adminPromotionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get adminPromotionsTitle;

  /// No description provided for @adminPromoCreate.
  ///
  /// In en, this message translates to:
  /// **'Create promotion'**
  String get adminPromoCreate;

  /// No description provided for @adminPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Promo code'**
  String get adminPromoCode;

  /// No description provided for @adminPromoPercentOff.
  ///
  /// In en, this message translates to:
  /// **'Percent off'**
  String get adminPromoPercentOff;

  /// No description provided for @adminPromoValidFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get adminPromoValidFrom;

  /// No description provided for @adminPromoValidTo.
  ///
  /// In en, this message translates to:
  /// **'Valid to'**
  String get adminPromoValidTo;

  /// No description provided for @adminPromoUsageLimit.
  ///
  /// In en, this message translates to:
  /// **'Usage limit'**
  String get adminPromoUsageLimit;

  /// No description provided for @adminPromoActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminPromoActive;

  /// No description provided for @adminPromoInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get adminPromoInactive;

  /// No description provided for @adminPromoNone.
  ///
  /// In en, this message translates to:
  /// **'No promotions yet.'**
  String get adminPromoNone;

  /// No description provided for @adminSettingsStoreName.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get adminSettingsStoreName;

  /// No description provided for @adminSettingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get adminSettingsCurrency;

  /// No description provided for @adminSettingsSupportEmail.
  ///
  /// In en, this message translates to:
  /// **'Support e-mail'**
  String get adminSettingsSupportEmail;

  /// No description provided for @adminSettingsEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get adminSettingsEnvironment;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
