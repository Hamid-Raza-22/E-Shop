// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'Gogguz';

  @override
  String get actionSave => 'محفوظ کریں';

  @override
  String get actionCancel => 'منسوخ کریں';

  @override
  String get actionDelete => 'حذف کریں';

  @override
  String get actionEdit => 'ترمیم کریں';

  @override
  String get actionAdd => 'شامل کریں';

  @override
  String get actionRetry => 'دوبارہ کوشش کریں';

  @override
  String get actionClose => 'بند کریں';

  @override
  String get actionConfirm => 'تصدیق کریں';

  @override
  String get actionApply => 'لاگو کریں';

  @override
  String get actionReset => 'دوبارہ ترتیب دیں';

  @override
  String get actionRefresh => 'تازہ کریں';

  @override
  String get actionSeeAll => 'سب دیکھیں';

  @override
  String get actionSearch => 'تلاش کریں';

  @override
  String get actionSignIn => 'سائن ان';

  @override
  String get actionSignOut => 'سائن آؤٹ';

  @override
  String get actionYes => 'ہاں';

  @override
  String get actionNo => 'نہیں';

  @override
  String get labelEmail => 'ای میل';

  @override
  String get labelPassword => 'پاس ورڈ';

  @override
  String get labelName => 'نام';

  @override
  String get labelPhone => 'فون';

  @override
  String get labelStatus => 'حالت';

  @override
  String get labelDate => 'تاریخ';

  @override
  String get labelAll => 'تمام';

  @override
  String get labelLoading => 'لوڈ ہو رہا ہے…';

  @override
  String get labelPrice => 'قیمت';

  @override
  String get labelQuantity => 'مقدار';

  @override
  String get labelSize => 'سائز';

  @override
  String get labelTotal => 'کل';

  @override
  String get labelSubtotal => 'ذیلی میزان';

  @override
  String get labelShipping => 'ترسیل';

  @override
  String get labelDiscount => 'رعایت';

  @override
  String get validationRequired => 'یہ خانہ لازمی ہے';

  @override
  String get validationInvalidEmail => 'درست ای میل پتہ درج کریں';

  @override
  String validationMinLength(int count) {
    return 'کم از کم $count حروف ہونے چاہیے';
  }

  @override
  String get errorGeneric => 'کچھ غلط ہو گیا۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get errorNoConnection => 'انٹرنیٹ کنکشن دستیاب نہیں۔';

  @override
  String get errorNotFound => 'ہمیں یہ صفحہ نہیں مل سکا۔';

  @override
  String get navHome => 'ہوم';

  @override
  String get navDiscover => 'دریافت';

  @override
  String get navBookmark => 'پسندیدہ';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get navCart => 'ٹوکری';

  @override
  String get storefrontOnSale => 'سیل پر';

  @override
  String get storefrontKids => 'بچے';

  @override
  String get storefrontSizeGuide => 'سائز گائیڈ';

  @override
  String get storefrontSearchHint => 'اپنی پسند کی چیز تلاش کریں';

  @override
  String get storefrontAddToCart => 'ٹوکری میں شامل کریں';

  @override
  String get storefrontBuyNow => 'ابھی خریدیں';

  @override
  String get storefrontOutOfStock => 'اسٹاک میں نہیں';

  @override
  String get storefrontReviews => 'تبصرے';

  @override
  String get storefrontWallet => 'والٹ';

  @override
  String get storefrontAddresses => 'پتے';

  @override
  String get storefrontNotifications => 'اطلاعات';

  @override
  String get storefrontOrders => 'آرڈرز';

  @override
  String get cartTitle => 'ٹوکری';

  @override
  String get cartEmptyTitle => 'آپ کی ٹوکری خالی ہے';

  @override
  String get cartEmptyMessage =>
      'اسٹور دیکھیں اور اپنی پسند کی اشیاء شامل کریں — وہ یہاں نظر آئیں گی۔';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اشیاء',
      one: '1 شے',
      zero: 'کوئی شے نہیں',
    );
    return '$_temp0';
  }

  @override
  String get checkoutTitle => 'چیک آؤٹ';

  @override
  String get checkoutPlaceOrder => 'آرڈر دیں';

  @override
  String checkoutPayAmount(String amount) {
    return '$amount ادا کریں';
  }

  @override
  String get checkoutSelectCard =>
      'جاری رکھنے کے لیے کارڈ منتخب کریں یا شامل کریں۔';

  @override
  String get checkoutEnterCvv => 'جاری رکھنے کے لیے کارڈ کا CVV درج کریں۔';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsSelectLanguage => 'زبان منتخب کریں';

  @override
  String settingsLanguageChanged(String language) {
    return 'زبان $language میں تبدیل ہو گئی';
  }

  @override
  String get settingsCurrency => 'کرنسی';

  @override
  String get settingsTheme => 'ظاہری شکل';

  @override
  String get settingsSupport => 'معاونت';

  @override
  String get settingsAbout => 'تعارف';

  @override
  String get languageEnglish => 'انگریزی';

  @override
  String get languageGerman => 'جرمن';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get languageArabic => 'عربی';

  @override
  String get languageSpanish => 'ہسپانوی';

  @override
  String get languageFrench => 'فرانسیسی';

  @override
  String get adminDashboard => 'ڈیش بورڈ';

  @override
  String get adminSignInTitle => 'مالک کا سائن ان';

  @override
  String get adminSignInSubtitle =>
      'اسٹور کا انتظام کرنے کے لیے اپنے ایڈمنسٹریٹر اکاؤنٹ سے سائن ان کریں۔';

  @override
  String get adminAccessDenied => 'رسائی مسترد';

  @override
  String get adminAccessDeniedMessage =>
      'یہ اکاؤنٹ اسٹور ایڈمنسٹریٹر کے طور پر رجسٹرڈ نہیں ہے۔';

  @override
  String adminWelcome(String name) {
    return 'خوش آمدید، $name';
  }

  @override
  String get adminNavOverview => 'جائزہ';

  @override
  String get adminNavProducts => 'مصنوعات';

  @override
  String get adminNavOrders => 'آرڈرز';

  @override
  String get adminNavCustomers => 'گاہک';

  @override
  String get adminNavReviews => 'تبصرے';

  @override
  String get adminNavPromotions => 'پروموشنز';

  @override
  String get adminNavSettings => 'ترتیبات';

  @override
  String get adminKpiRevenueToday => 'آج کی آمدنی';

  @override
  String get adminKpiRevenueTotal => 'کل آمدنی';

  @override
  String get adminKpiOrders => 'آرڈرز';

  @override
  String get adminKpiAverageOrderValue => 'اوسط آرڈر مالیت';

  @override
  String get adminKpiNewCustomers => 'نئے گاہک';

  @override
  String get adminKpiLowStock => 'کم اسٹاک';

  @override
  String adminSalesLastDays(int count) {
    return 'فروخت — گزشتہ $count دن';
  }

  @override
  String get adminTopProducts => 'نمایاں مصنوعات';

  @override
  String get adminRecentOrders => 'حالیہ آرڈرز';

  @override
  String get adminNoData => 'ابھی کوئی ڈیٹا نہیں';

  @override
  String get adminProductsTitle => 'مصنوعات';

  @override
  String get adminProductAdd => 'مصنوعہ شامل کریں';

  @override
  String get adminProductEdit => 'مصنوعہ میں ترمیم کریں';

  @override
  String get adminProductDelete => 'مصنوعہ حذف کریں';

  @override
  String adminProductDeleteConfirm(String title) {
    return '“$title” حذف کریں؟ اسے واپس نہیں کیا جا سکتا۔';
  }

  @override
  String get adminProductSaved => 'مصنوعہ محفوظ ہو گیا';

  @override
  String get adminProductDeleted => 'مصنوعہ حذف ہو گیا';

  @override
  String get adminProductNone =>
      'ابھی کوئی مصنوعات نہیں۔ شروع کرنے کے لیے اپنی پہلی مصنوعہ شامل کریں۔';

  @override
  String get adminFieldTitle => 'عنوان';

  @override
  String get adminFieldBrand => 'برانڈ';

  @override
  String get adminFieldCategory => 'زمرہ';

  @override
  String get adminFieldDescription => 'تفصیل';

  @override
  String get adminFieldImageUrl => 'تصویر کا یو آر ایل';

  @override
  String get adminFieldStock => 'اسٹاک';

  @override
  String get adminFieldSku => 'ایس کے یو';

  @override
  String get adminFieldDiscountPercent => 'رعایت %';

  @override
  String get adminFieldPublished => 'شائع شدہ';

  @override
  String get adminStatePublished => 'شائع شدہ';

  @override
  String get adminStateDraft => 'مسودہ';

  @override
  String adminStockLeft(int count) {
    return '$count باقی';
  }

  @override
  String get adminOrdersTitle => 'آرڈرز';

  @override
  String adminOrderNumber(String id) {
    return 'آرڈر $id';
  }

  @override
  String get adminOrderUpdateStatus => 'حالت اپ ڈیٹ کریں';

  @override
  String get adminOrderStatusUpdated => 'آرڈر کی حالت اپ ڈیٹ ہو گئی';

  @override
  String get adminOrderNone => 'اس فلٹر سے کوئی آرڈر مماثل نہیں۔';

  @override
  String get orderStatusPending => 'زیرِ التوا';

  @override
  String get orderStatusProcessing => 'کارروائی جاری';

  @override
  String get orderStatusShipped => 'روانہ کر دیا گیا';

  @override
  String get orderStatusDelivered => 'پہنچا دیا گیا';

  @override
  String get orderStatusCanceled => 'منسوخ';

  @override
  String get orderStatusReturned => 'واپس کیا گیا';

  @override
  String get adminCustomersTitle => 'گاہک';

  @override
  String adminCustomerSince(String date) {
    return '$date سے گاہک';
  }

  @override
  String get adminCustomerTotalSpent => 'کل خرچ';

  @override
  String get adminCustomerOrders => 'دیے گئے آرڈرز';

  @override
  String get adminCustomerBlock => 'گاہک کو بلاک کریں';

  @override
  String get adminCustomerUnblock => 'گاہک کو ان بلاک کریں';

  @override
  String get adminCustomerBlocked => 'بلاک شدہ';

  @override
  String get adminCustomerNone => 'ابھی کوئی گاہک نہیں۔';

  @override
  String get adminReviewsTitle => 'تبصرے';

  @override
  String get adminReviewsPending => 'منظوری کے منتظر';

  @override
  String get adminReviewApprove => 'منظور کریں';

  @override
  String get adminReviewReject => 'مسترد کریں';

  @override
  String get adminReviewNone => 'نگرانی کے لیے کچھ نہیں۔';

  @override
  String get adminPromotionsTitle => 'پروموشنز';

  @override
  String get adminPromoCreate => 'پروموشن بنائیں';

  @override
  String get adminPromoCode => 'پرومو کوڈ';

  @override
  String get adminPromoPercentOff => 'فیصد رعایت';

  @override
  String get adminPromoValidFrom => 'اس تاریخ سے مؤثر';

  @override
  String get adminPromoValidTo => 'اس تاریخ تک مؤثر';

  @override
  String get adminPromoUsageLimit => 'استعمال کی حد';

  @override
  String get adminPromoActive => 'فعال';

  @override
  String get adminPromoInactive => 'غیر فعال';

  @override
  String get adminPromoNone => 'ابھی کوئی پروموشن نہیں۔';

  @override
  String get adminSettingsStoreName => 'اسٹور کا نام';

  @override
  String get adminSettingsCurrency => 'کرنسی';

  @override
  String get adminSettingsSupportEmail => 'معاونت کا ای میل';

  @override
  String get adminSettingsEnvironment => 'ماحول';
}
