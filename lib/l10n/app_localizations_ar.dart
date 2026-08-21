// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Gogguz';

  @override
  String get actionSave => 'حفظ';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionDelete => 'حذف';

  @override
  String get actionEdit => 'تعديل';

  @override
  String get actionAdd => 'إضافة';

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get actionClose => 'إغلاق';

  @override
  String get actionConfirm => 'تأكيد';

  @override
  String get actionApply => 'تطبيق';

  @override
  String get actionReset => 'إعادة تعيين';

  @override
  String get actionRefresh => 'تحديث';

  @override
  String get actionSeeAll => 'عرض الكل';

  @override
  String get actionSearch => 'بحث';

  @override
  String get actionSignIn => 'تسجيل الدخول';

  @override
  String get actionSignOut => 'تسجيل الخروج';

  @override
  String get actionYes => 'نعم';

  @override
  String get actionNo => 'لا';

  @override
  String get labelEmail => 'البريد الإلكتروني';

  @override
  String get labelPassword => 'كلمة المرور';

  @override
  String get labelName => 'الاسم';

  @override
  String get labelPhone => 'الهاتف';

  @override
  String get labelStatus => 'الحالة';

  @override
  String get labelDate => 'التاريخ';

  @override
  String get labelAll => 'الكل';

  @override
  String get labelLoading => 'جارٍ التحميل…';

  @override
  String get labelPrice => 'السعر';

  @override
  String get labelQuantity => 'الكمية';

  @override
  String get labelSize => 'المقاس';

  @override
  String get labelTotal => 'الإجمالي';

  @override
  String get labelSubtotal => 'المجموع الفرعي';

  @override
  String get labelShipping => 'الشحن';

  @override
  String get labelDiscount => 'الخصم';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationInvalidEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String validationMinLength(int count) {
    return 'يجب أن يتكون من $count أحرف على الأقل';
  }

  @override
  String get errorGeneric => 'حدث خطأ ما. يُرجى المحاولة مرة أخرى.';

  @override
  String get errorNoConnection => 'لا يوجد اتصال بالإنترنت.';

  @override
  String get errorNotFound => 'لم نتمكن من العثور على هذه الصفحة.';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navDiscover => 'استكشاف';

  @override
  String get navBookmark => 'المحفوظات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get navCart => 'السلة';

  @override
  String get storefrontOnSale => 'عروض التخفيضات';

  @override
  String get storefrontKids => 'الأطفال';

  @override
  String get storefrontSizeGuide => 'دليل المقاسات';

  @override
  String get storefrontSearchHint => 'ابحث عن شيء يعجبك';

  @override
  String get storefrontAddToCart => 'أضف إلى السلة';

  @override
  String get storefrontBuyNow => 'اشتر الآن';

  @override
  String get storefrontOutOfStock => 'غير متوفر';

  @override
  String get storefrontReviews => 'التقييمات';

  @override
  String get storefrontWallet => 'المحفظة';

  @override
  String get storefrontAddresses => 'العناوين';

  @override
  String get storefrontNotifications => 'الإشعارات';

  @override
  String get storefrontOrders => 'الطلبات';

  @override
  String get cartTitle => 'السلة';

  @override
  String get cartEmptyTitle => 'سلتك فارغة';

  @override
  String get cartEmptyMessage =>
      'تصفّح المتجر وأضف القطع التي تحبها — ستظهر هنا.';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا توجد عناصر',
    );
    return '$_temp0';
  }

  @override
  String get checkoutTitle => 'إتمام الشراء';

  @override
  String get checkoutPlaceOrder => 'تأكيد الطلب';

  @override
  String checkoutPayAmount(String amount) {
    return 'ادفع $amount';
  }

  @override
  String get checkoutSelectCard => 'اختر بطاقة أو أضف واحدة للمتابعة.';

  @override
  String get checkoutEnterCvv => 'أدخل رمز CVV الخاص بالبطاقة للمتابعة.';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsSelectLanguage => 'اختر اللغة';

  @override
  String settingsLanguageChanged(String language) {
    return 'تم تغيير اللغة إلى $language';
  }

  @override
  String get settingsCurrency => 'العملة';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsSupport => 'الدعم';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageGerman => 'الألمانية';

  @override
  String get languageUrdu => 'الأردية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSpanish => 'الإسبانية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get adminDashboard => 'لوحة التحكم';

  @override
  String get adminSignInTitle => 'تسجيل دخول المالك';

  @override
  String get adminSignInSubtitle => 'سجّل الدخول بحساب المسؤول لإدارة المتجر.';

  @override
  String get adminAccessDenied => 'تم رفض الوصول';

  @override
  String get adminAccessDeniedMessage => 'هذا الحساب غير مسجّل كمسؤول للمتجر.';

  @override
  String adminWelcome(String name) {
    return 'مرحبًا بعودتك، $name';
  }

  @override
  String get adminNavOverview => 'نظرة عامة';

  @override
  String get adminNavProducts => 'المنتجات';

  @override
  String get adminNavOrders => 'الطلبات';

  @override
  String get adminNavCustomers => 'العملاء';

  @override
  String get adminNavReviews => 'التقييمات';

  @override
  String get adminNavPromotions => 'العروض الترويجية';

  @override
  String get adminNavSettings => 'الإعدادات';

  @override
  String get adminKpiRevenueToday => 'إيرادات اليوم';

  @override
  String get adminKpiRevenueTotal => 'إجمالي الإيرادات';

  @override
  String get adminKpiOrders => 'الطلبات';

  @override
  String get adminKpiAverageOrderValue => 'متوسط قيمة الطلب';

  @override
  String get adminKpiNewCustomers => 'عملاء جدد';

  @override
  String get adminKpiLowStock => 'مخزون منخفض';

  @override
  String adminSalesLastDays(int count) {
    return 'المبيعات — آخر $count يوم';
  }

  @override
  String get adminTopProducts => 'أفضل المنتجات';

  @override
  String get adminRecentOrders => 'الطلبات الأخيرة';

  @override
  String get adminNoData => 'لا توجد بيانات بعد';

  @override
  String get adminProductsTitle => 'المنتجات';

  @override
  String get adminProductAdd => 'إضافة منتج';

  @override
  String get adminProductEdit => 'تعديل المنتج';

  @override
  String get adminProductDelete => 'حذف المنتج';

  @override
  String adminProductDeleteConfirm(String title) {
    return 'هل تريد حذف “$title”؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get adminProductSaved => 'تم حفظ المنتج';

  @override
  String get adminProductDeleted => 'تم حذف المنتج';

  @override
  String get adminProductNone => 'لا توجد منتجات بعد. أضف منتجك الأول للبدء.';

  @override
  String get adminFieldTitle => 'العنوان';

  @override
  String get adminFieldBrand => 'الماركة';

  @override
  String get adminFieldCategory => 'الفئة';

  @override
  String get adminFieldDescription => 'الوصف';

  @override
  String get adminFieldImageUrl => 'رابط الصورة';

  @override
  String get adminFieldStock => 'المخزون';

  @override
  String get adminFieldSku => 'رمز المنتج (SKU)';

  @override
  String get adminFieldDiscountPercent => 'نسبة الخصم %';

  @override
  String get adminFieldPublished => 'منشور';

  @override
  String get adminStatePublished => 'منشور';

  @override
  String get adminStateDraft => 'مسودة';

  @override
  String adminStockLeft(int count) {
    return 'بقي $count';
  }

  @override
  String get adminOrdersTitle => 'الطلبات';

  @override
  String adminOrderNumber(String id) {
    return 'الطلب $id';
  }

  @override
  String get adminOrderUpdateStatus => 'تحديث الحالة';

  @override
  String get adminOrderStatusUpdated => 'تم تحديث حالة الطلب';

  @override
  String get adminOrderNone => 'لا توجد طلبات مطابقة لهذا الفلتر.';

  @override
  String get orderStatusPending => 'قيد الانتظار';

  @override
  String get orderStatusProcessing => 'قيد المعالجة';

  @override
  String get orderStatusShipped => 'تم الشحن';

  @override
  String get orderStatusDelivered => 'تم التوصيل';

  @override
  String get orderStatusCanceled => 'ملغى';

  @override
  String get orderStatusReturned => 'مُرتجع';

  @override
  String get adminCustomersTitle => 'العملاء';

  @override
  String adminCustomerSince(String date) {
    return 'عميل منذ $date';
  }

  @override
  String get adminCustomerTotalSpent => 'إجمالي المبلغ المنفق';

  @override
  String get adminCustomerOrders => 'الطلبات المقدَّمة';

  @override
  String get adminCustomerBlock => 'حظر العميل';

  @override
  String get adminCustomerUnblock => 'إلغاء حظر العميل';

  @override
  String get adminCustomerBlocked => 'محظور';

  @override
  String get adminCustomerNone => 'لا يوجد عملاء بعد.';

  @override
  String get adminReviewsTitle => 'التقييمات';

  @override
  String get adminReviewsPending => 'بانتظار الموافقة';

  @override
  String get adminReviewApprove => 'موافقة';

  @override
  String get adminReviewReject => 'رفض';

  @override
  String get adminReviewNone => 'لا يوجد ما يحتاج إلى مراجعة.';

  @override
  String get adminPromotionsTitle => 'العروض الترويجية';

  @override
  String get adminPromoCreate => 'إنشاء عرض ترويجي';

  @override
  String get adminPromoCode => 'رمز الخصم';

  @override
  String get adminPromoPercentOff => 'نسبة الخصم';

  @override
  String get adminPromoValidFrom => 'صالح من';

  @override
  String get adminPromoValidTo => 'صالح حتى';

  @override
  String get adminPromoUsageLimit => 'حد الاستخدام';

  @override
  String get adminPromoActive => 'نشط';

  @override
  String get adminPromoInactive => 'غير نشط';

  @override
  String get adminPromoNone => 'لا توجد عروض ترويجية بعد.';

  @override
  String get adminSettingsStoreName => 'اسم المتجر';

  @override
  String get adminSettingsCurrency => 'العملة';

  @override
  String get adminSettingsSupportEmail => 'بريد الدعم الإلكتروني';

  @override
  String get adminSettingsEnvironment => 'البيئة';
}
