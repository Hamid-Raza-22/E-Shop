// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Gogguz';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionAdd => 'Ajouter';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get actionApply => 'Appliquer';

  @override
  String get actionReset => 'Réinitialiser';

  @override
  String get actionRefresh => 'Actualiser';

  @override
  String get actionSeeAll => 'Tout voir';

  @override
  String get actionSearch => 'Rechercher';

  @override
  String get actionSignIn => 'Se connecter';

  @override
  String get actionSignOut => 'Se déconnecter';

  @override
  String get actionYes => 'Oui';

  @override
  String get actionNo => 'Non';

  @override
  String get labelEmail => 'E-mail';

  @override
  String get labelPassword => 'Mot de passe';

  @override
  String get labelName => 'Nom';

  @override
  String get labelPhone => 'Téléphone';

  @override
  String get labelStatus => 'Statut';

  @override
  String get labelDate => 'Date';

  @override
  String get labelAll => 'Tout';

  @override
  String get labelLoading => 'Chargement…';

  @override
  String get labelPrice => 'Prix';

  @override
  String get labelQuantity => 'Quantité';

  @override
  String get labelSize => 'Taille';

  @override
  String get labelTotal => 'Total';

  @override
  String get labelSubtotal => 'Sous-total';

  @override
  String get labelShipping => 'Livraison';

  @override
  String get labelDiscount => 'Remise';

  @override
  String get validationRequired => 'Ce champ est obligatoire';

  @override
  String get validationInvalidEmail => 'Saisissez une adresse e-mail valide';

  @override
  String validationMinLength(int count) {
    return 'Doit contenir au moins $count caractères';
  }

  @override
  String get errorGeneric => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get errorNoConnection => 'Aucune connexion Internet.';

  @override
  String get errorNotFound => 'Nous n\'avons pas trouvé cette page.';

  @override
  String get navHome => 'Accueil';

  @override
  String get navDiscover => 'Découvrir';

  @override
  String get navBookmark => 'Favoris';

  @override
  String get navProfile => 'Profil';

  @override
  String get navCart => 'Panier';

  @override
  String get storefrontOnSale => 'En promotion';

  @override
  String get storefrontKids => 'Enfants';

  @override
  String get storefrontSizeGuide => 'Guide des tailles';

  @override
  String get storefrontSearchHint => 'Trouvez ce qui vous plaît';

  @override
  String get storefrontAddToCart => 'Ajouter au panier';

  @override
  String get storefrontBuyNow => 'Acheter maintenant';

  @override
  String get storefrontOutOfStock => 'Rupture de stock';

  @override
  String get storefrontReviews => 'Avis';

  @override
  String get storefrontWallet => 'Portefeuille';

  @override
  String get storefrontAddresses => 'Adresses';

  @override
  String get storefrontNotifications => 'Notifications';

  @override
  String get storefrontOrders => 'Commandes';

  @override
  String get cartTitle => 'Panier';

  @override
  String get cartEmptyTitle => 'Votre panier est vide';

  @override
  String get cartEmptyMessage =>
      'Parcourez la boutique et ajoutez les articles qui vous plaisent : ils apparaîtront ici.';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
      zero: 'Aucun article',
    );
    return '$_temp0';
  }

  @override
  String get checkoutTitle => 'Paiement';

  @override
  String get checkoutPlaceOrder => 'Passer la commande';

  @override
  String checkoutPayAmount(String amount) {
    return 'Payer $amount';
  }

  @override
  String get checkoutSelectCard =>
      'Sélectionnez ou ajoutez une carte pour continuer.';

  @override
  String get checkoutEnterCvv => 'Saisissez le CVV de la carte pour continuer.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsSelectLanguage => 'Choisir la langue';

  @override
  String settingsLanguageChanged(String language) {
    return 'Langue changée en $language';
  }

  @override
  String get settingsCurrency => 'Devise';

  @override
  String get settingsTheme => 'Apparence';

  @override
  String get settingsSupport => 'Assistance';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageGerman => 'Allemand';

  @override
  String get languageUrdu => 'Ourdou';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get languageFrench => 'Français';

  @override
  String get adminDashboard => 'Tableau de bord';

  @override
  String get adminSignInTitle => 'Connexion propriétaire';

  @override
  String get adminSignInSubtitle =>
      'Connectez-vous avec votre compte administrateur pour gérer la boutique.';

  @override
  String get adminAccessDenied => 'Accès refusé';

  @override
  String get adminAccessDeniedMessage =>
      'Ce compte n\'est pas enregistré comme administrateur de la boutique.';

  @override
  String adminWelcome(String name) {
    return 'Bon retour, $name';
  }

  @override
  String get adminNavOverview => 'Vue d\'ensemble';

  @override
  String get adminNavProducts => 'Produits';

  @override
  String get adminNavOrders => 'Commandes';

  @override
  String get adminNavCustomers => 'Clients';

  @override
  String get adminNavReviews => 'Avis';

  @override
  String get adminNavPromotions => 'Promotions';

  @override
  String get adminNavSettings => 'Paramètres';

  @override
  String get adminKpiRevenueToday => 'Chiffre d\'affaires du jour';

  @override
  String get adminKpiRevenueTotal => 'Chiffre d\'affaires total';

  @override
  String get adminKpiOrders => 'Commandes';

  @override
  String get adminKpiAverageOrderValue => 'Panier moyen';

  @override
  String get adminKpiNewCustomers => 'Nouveaux clients';

  @override
  String get adminKpiLowStock => 'Stock faible';

  @override
  String adminSalesLastDays(int count) {
    return 'Ventes — $count derniers jours';
  }

  @override
  String get adminTopProducts => 'Meilleures ventes';

  @override
  String get adminRecentOrders => 'Commandes récentes';

  @override
  String get adminNoData => 'Aucune donnée pour le moment';

  @override
  String get adminProductsTitle => 'Produits';

  @override
  String get adminProductAdd => 'Ajouter un produit';

  @override
  String get adminProductEdit => 'Modifier le produit';

  @override
  String get adminProductDelete => 'Supprimer le produit';

  @override
  String adminProductDeleteConfirm(String title) {
    return 'Supprimer « $title » ? Cette action est irréversible.';
  }

  @override
  String get adminProductSaved => 'Produit enregistré';

  @override
  String get adminProductDeleted => 'Produit supprimé';

  @override
  String get adminProductNone =>
      'Aucun produit pour le moment. Ajoutez votre premier produit pour commencer.';

  @override
  String get adminFieldTitle => 'Titre';

  @override
  String get adminFieldBrand => 'Marque';

  @override
  String get adminFieldCategory => 'Catégorie';

  @override
  String get adminFieldDescription => 'Description';

  @override
  String get adminFieldImageUrl => 'URL de l\'image';

  @override
  String get adminFieldStock => 'Stock';

  @override
  String get adminFieldSku => 'SKU';

  @override
  String get adminFieldDiscountPercent => 'Remise en %';

  @override
  String get adminFieldPublished => 'Publié';

  @override
  String get adminStatePublished => 'Publié';

  @override
  String get adminStateDraft => 'Brouillon';

  @override
  String adminStockLeft(int count) {
    return '$count restant(s)';
  }

  @override
  String get adminOrdersTitle => 'Commandes';

  @override
  String adminOrderNumber(String id) {
    return 'Commande $id';
  }

  @override
  String get adminOrderUpdateStatus => 'Mettre à jour le statut';

  @override
  String get adminOrderStatusUpdated => 'Statut de la commande mis à jour';

  @override
  String get adminOrderNone => 'Aucune commande ne correspond à ce filtre.';

  @override
  String get orderStatusPending => 'En attente';

  @override
  String get orderStatusProcessing => 'En cours de traitement';

  @override
  String get orderStatusShipped => 'Expédiée';

  @override
  String get orderStatusDelivered => 'Livrée';

  @override
  String get orderStatusCanceled => 'Annulée';

  @override
  String get orderStatusReturned => 'Retournée';

  @override
  String get adminCustomersTitle => 'Clients';

  @override
  String adminCustomerSince(String date) {
    return 'Client depuis $date';
  }

  @override
  String get adminCustomerTotalSpent => 'Total dépensé';

  @override
  String get adminCustomerOrders => 'Commandes passées';

  @override
  String get adminCustomerBlock => 'Bloquer le client';

  @override
  String get adminCustomerUnblock => 'Débloquer le client';

  @override
  String get adminCustomerBlocked => 'Bloqué';

  @override
  String get adminCustomerNone => 'Aucun client pour le moment.';

  @override
  String get adminReviewsTitle => 'Avis';

  @override
  String get adminReviewsPending => 'En attente d\'approbation';

  @override
  String get adminReviewApprove => 'Approuver';

  @override
  String get adminReviewReject => 'Rejeter';

  @override
  String get adminReviewNone => 'Rien à modérer.';

  @override
  String get adminPromotionsTitle => 'Promotions';

  @override
  String get adminPromoCreate => 'Créer une promotion';

  @override
  String get adminPromoCode => 'Code promo';

  @override
  String get adminPromoPercentOff => 'Pourcentage de remise';

  @override
  String get adminPromoValidFrom => 'Valable du';

  @override
  String get adminPromoValidTo => 'Valable au';

  @override
  String get adminPromoUsageLimit => 'Limite d\'utilisation';

  @override
  String get adminPromoActive => 'Active';

  @override
  String get adminPromoInactive => 'Inactive';

  @override
  String get adminPromoNone => 'Aucune promotion pour le moment.';

  @override
  String get adminSettingsStoreName => 'Nom de la boutique';

  @override
  String get adminSettingsCurrency => 'Devise';

  @override
  String get adminSettingsSupportEmail => 'E-mail d\'assistance';

  @override
  String get adminSettingsEnvironment => 'Environnement';
}
