// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Gogguz';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionEdit => 'Bearbeiten';

  @override
  String get actionAdd => 'Hinzufügen';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get actionClose => 'Schließen';

  @override
  String get actionConfirm => 'Bestätigen';

  @override
  String get actionApply => 'Anwenden';

  @override
  String get actionReset => 'Zurücksetzen';

  @override
  String get actionRefresh => 'Aktualisieren';

  @override
  String get actionSeeAll => 'Alle ansehen';

  @override
  String get actionSearch => 'Suchen';

  @override
  String get actionSignIn => 'Anmelden';

  @override
  String get actionSignOut => 'Abmelden';

  @override
  String get actionYes => 'Ja';

  @override
  String get actionNo => 'Nein';

  @override
  String get labelEmail => 'E-Mail';

  @override
  String get labelPassword => 'Passwort';

  @override
  String get labelName => 'Name';

  @override
  String get labelPhone => 'Telefon';

  @override
  String get labelStatus => 'Status';

  @override
  String get labelDate => 'Datum';

  @override
  String get labelAll => 'Alle';

  @override
  String get labelLoading => 'Wird geladen …';

  @override
  String get labelPrice => 'Preis';

  @override
  String get labelQuantity => 'Menge';

  @override
  String get labelSize => 'Größe';

  @override
  String get labelTotal => 'Gesamt';

  @override
  String get labelSubtotal => 'Zwischensumme';

  @override
  String get labelShipping => 'Versand';

  @override
  String get labelDiscount => 'Rabatt';

  @override
  String get validationRequired => 'Dieses Feld ist erforderlich';

  @override
  String get validationInvalidEmail =>
      'Geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String validationMinLength(int count) {
    return 'Muss mindestens $count Zeichen lang sein';
  }

  @override
  String get errorGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get errorNoConnection => 'Keine Internetverbindung.';

  @override
  String get errorNotFound => 'Diese Seite konnte nicht gefunden werden.';

  @override
  String get navHome => 'Start';

  @override
  String get navDiscover => 'Entdecken';

  @override
  String get navBookmark => 'Merkliste';

  @override
  String get navProfile => 'Profil';

  @override
  String get navCart => 'Warenkorb';

  @override
  String get storefrontOnSale => 'Im Angebot';

  @override
  String get storefrontKids => 'Kinder';

  @override
  String get storefrontSizeGuide => 'Größentabelle';

  @override
  String get storefrontSearchHint => 'Finden Sie etwas, das Ihnen gefällt';

  @override
  String get storefrontAddToCart => 'In den Warenkorb';

  @override
  String get storefrontBuyNow => 'Jetzt kaufen';

  @override
  String get storefrontOutOfStock => 'Nicht auf Lager';

  @override
  String get storefrontReviews => 'Bewertungen';

  @override
  String get storefrontWallet => 'Guthaben';

  @override
  String get storefrontAddresses => 'Adressen';

  @override
  String get storefrontNotifications => 'Benachrichtigungen';

  @override
  String get storefrontOrders => 'Bestellungen';

  @override
  String get cartTitle => 'Warenkorb';

  @override
  String get cartEmptyTitle => 'Ihr Warenkorb ist leer';

  @override
  String get cartEmptyMessage =>
      'Stöbern Sie im Shop und fügen Sie Ihre Lieblingsstücke hinzu – sie erscheinen dann hier.';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '1 Artikel',
      zero: 'Keine Artikel',
    );
    return '$_temp0';
  }

  @override
  String get checkoutTitle => 'Kasse';

  @override
  String get checkoutPlaceOrder => 'Bestellung abschicken';

  @override
  String checkoutPayAmount(String amount) {
    return '$amount bezahlen';
  }

  @override
  String get checkoutSelectCard =>
      'Wählen Sie eine Karte aus oder fügen Sie eine hinzu, um fortzufahren.';

  @override
  String get checkoutEnterCvv =>
      'Geben Sie die CVV der Karte ein, um fortzufahren.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsSelectLanguage => 'Sprache auswählen';

  @override
  String settingsLanguageChanged(String language) {
    return 'Sprache geändert zu $language';
  }

  @override
  String get settingsCurrency => 'Währung';

  @override
  String get settingsTheme => 'Erscheinungsbild';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsAbout => 'Über';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageArabic => 'Arabisch';

  @override
  String get languageSpanish => 'Spanisch';

  @override
  String get languageFrench => 'Französisch';

  @override
  String get adminDashboard => 'Dashboard';

  @override
  String get adminSignInTitle => 'Inhaber-Anmeldung';

  @override
  String get adminSignInSubtitle =>
      'Melden Sie sich mit Ihrem Administratorkonto an, um den Shop zu verwalten.';

  @override
  String get adminAccessDenied => 'Zugriff verweigert';

  @override
  String get adminAccessDeniedMessage =>
      'Dieses Konto ist nicht als Shop-Administrator registriert.';

  @override
  String adminWelcome(String name) {
    return 'Willkommen zurück, $name';
  }

  @override
  String get adminNavOverview => 'Übersicht';

  @override
  String get adminNavProducts => 'Produkte';

  @override
  String get adminNavOrders => 'Bestellungen';

  @override
  String get adminNavCustomers => 'Kunden';

  @override
  String get adminNavReviews => 'Bewertungen';

  @override
  String get adminNavPromotions => 'Aktionen';

  @override
  String get adminNavSettings => 'Einstellungen';

  @override
  String get adminKpiRevenueToday => 'Umsatz heute';

  @override
  String get adminKpiRevenueTotal => 'Gesamtumsatz';

  @override
  String get adminKpiOrders => 'Bestellungen';

  @override
  String get adminKpiAverageOrderValue => 'Durchschnittlicher Bestellwert';

  @override
  String get adminKpiNewCustomers => 'Neue Kunden';

  @override
  String get adminKpiLowStock => 'Geringer Lagerbestand';

  @override
  String adminSalesLastDays(int count) {
    return 'Verkäufe – letzte $count Tage';
  }

  @override
  String get adminTopProducts => 'Topprodukte';

  @override
  String get adminRecentOrders => 'Letzte Bestellungen';

  @override
  String get adminNoData => 'Noch keine Daten';

  @override
  String get adminProductsTitle => 'Produkte';

  @override
  String get adminProductAdd => 'Produkt hinzufügen';

  @override
  String get adminProductEdit => 'Produkt bearbeiten';

  @override
  String get adminProductDelete => 'Produkt löschen';

  @override
  String adminProductDeleteConfirm(String title) {
    return '„$title“ löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get adminProductSaved => 'Produkt gespeichert';

  @override
  String get adminProductDeleted => 'Produkt gelöscht';

  @override
  String get adminProductNone =>
      'Noch keine Produkte. Fügen Sie Ihr erstes Produkt hinzu, um zu starten.';

  @override
  String get adminFieldTitle => 'Titel';

  @override
  String get adminFieldBrand => 'Marke';

  @override
  String get adminFieldCategory => 'Kategorie';

  @override
  String get adminFieldDescription => 'Beschreibung';

  @override
  String get adminFieldImageUrl => 'Bild-URL';

  @override
  String get adminFieldStock => 'Lagerbestand';

  @override
  String get adminFieldSku => 'SKU';

  @override
  String get adminFieldDiscountPercent => 'Rabatt %';

  @override
  String get adminFieldPublished => 'Veröffentlicht';

  @override
  String get adminStatePublished => 'Veröffentlicht';

  @override
  String get adminStateDraft => 'Entwurf';

  @override
  String adminStockLeft(int count) {
    return '$count übrig';
  }

  @override
  String get adminOrdersTitle => 'Bestellungen';

  @override
  String adminOrderNumber(String id) {
    return 'Bestellung $id';
  }

  @override
  String get adminOrderUpdateStatus => 'Status aktualisieren';

  @override
  String get adminOrderStatusUpdated => 'Bestellstatus aktualisiert';

  @override
  String get adminOrderNone => 'Keine Bestellungen entsprechen diesem Filter.';

  @override
  String get orderStatusPending => 'Ausstehend';

  @override
  String get orderStatusProcessing => 'In Bearbeitung';

  @override
  String get orderStatusShipped => 'Versandt';

  @override
  String get orderStatusDelivered => 'Geliefert';

  @override
  String get orderStatusCanceled => 'Storniert';

  @override
  String get orderStatusReturned => 'Zurückgesendet';

  @override
  String get adminCustomersTitle => 'Kunden';

  @override
  String adminCustomerSince(String date) {
    return 'Kunde seit $date';
  }

  @override
  String get adminCustomerTotalSpent => 'Gesamtausgaben';

  @override
  String get adminCustomerOrders => 'Aufgegebene Bestellungen';

  @override
  String get adminCustomerBlock => 'Kunde sperren';

  @override
  String get adminCustomerUnblock => 'Kunde entsperren';

  @override
  String get adminCustomerBlocked => 'Gesperrt';

  @override
  String get adminCustomerNone => 'Noch keine Kunden.';

  @override
  String get adminReviewsTitle => 'Bewertungen';

  @override
  String get adminReviewsPending => 'Freigabe ausstehend';

  @override
  String get adminReviewApprove => 'Freigeben';

  @override
  String get adminReviewReject => 'Ablehnen';

  @override
  String get adminReviewNone => 'Nichts zu moderieren.';

  @override
  String get adminPromotionsTitle => 'Aktionen';

  @override
  String get adminPromoCreate => 'Aktion erstellen';

  @override
  String get adminPromoCode => 'Aktionscode';

  @override
  String get adminPromoPercentOff => 'Rabatt in Prozent';

  @override
  String get adminPromoValidFrom => 'Gültig ab';

  @override
  String get adminPromoValidTo => 'Gültig bis';

  @override
  String get adminPromoUsageLimit => 'Nutzungslimit';

  @override
  String get adminPromoActive => 'Aktiv';

  @override
  String get adminPromoInactive => 'Inaktiv';

  @override
  String get adminPromoNone => 'Noch keine Aktionen.';

  @override
  String get adminSettingsStoreName => 'Shop-Name';

  @override
  String get adminSettingsCurrency => 'Währung';

  @override
  String get adminSettingsSupportEmail => 'Support-E-Mail';

  @override
  String get adminSettingsEnvironment => 'Umgebung';
}
