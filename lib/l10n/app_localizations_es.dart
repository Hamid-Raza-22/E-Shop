// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Gogguz';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionAdd => 'Añadir';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get actionApply => 'Aplicar';

  @override
  String get actionReset => 'Restablecer';

  @override
  String get actionRefresh => 'Actualizar';

  @override
  String get actionSeeAll => 'Ver todo';

  @override
  String get actionSearch => 'Buscar';

  @override
  String get actionSignIn => 'Iniciar sesión';

  @override
  String get actionSignOut => 'Cerrar sesión';

  @override
  String get actionYes => 'Sí';

  @override
  String get actionNo => 'No';

  @override
  String get labelEmail => 'Correo electrónico';

  @override
  String get labelPassword => 'Contraseña';

  @override
  String get labelName => 'Nombre';

  @override
  String get labelPhone => 'Teléfono';

  @override
  String get labelStatus => 'Estado';

  @override
  String get labelDate => 'Fecha';

  @override
  String get labelAll => 'Todo';

  @override
  String get labelLoading => 'Cargando…';

  @override
  String get labelPrice => 'Precio';

  @override
  String get labelQuantity => 'Cantidad';

  @override
  String get labelSize => 'Talla';

  @override
  String get labelTotal => 'Total';

  @override
  String get labelSubtotal => 'Subtotal';

  @override
  String get labelShipping => 'Envío';

  @override
  String get labelDiscount => 'Descuento';

  @override
  String get validationRequired => 'Este campo es obligatorio';

  @override
  String get validationInvalidEmail =>
      'Introduce una dirección de correo electrónico válida';

  @override
  String validationMinLength(int count) {
    return 'Debe tener al menos $count caracteres';
  }

  @override
  String get errorGeneric => 'Se ha producido un error. Inténtalo de nuevo.';

  @override
  String get errorNoConnection => 'Sin conexión a Internet.';

  @override
  String get errorNotFound => 'No hemos podido encontrar esa página.';

  @override
  String get navHome => 'Inicio';

  @override
  String get navDiscover => 'Descubrir';

  @override
  String get navBookmark => 'Favoritos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navCart => 'Carrito';

  @override
  String get storefrontOnSale => 'En oferta';

  @override
  String get storefrontKids => 'Niños';

  @override
  String get storefrontSizeGuide => 'Guía de tallas';

  @override
  String get storefrontSearchHint => 'Encuentra algo que te encante';

  @override
  String get storefrontAddToCart => 'Añadir al carrito';

  @override
  String get storefrontBuyNow => 'Comprar ahora';

  @override
  String get storefrontOutOfStock => 'Sin existencias';

  @override
  String get storefrontReviews => 'Valoraciones';

  @override
  String get storefrontWallet => 'Cartera';

  @override
  String get storefrontAddresses => 'Direcciones';

  @override
  String get storefrontNotifications => 'Notificaciones';

  @override
  String get storefrontOrders => 'Pedidos';

  @override
  String get cartTitle => 'Carrito';

  @override
  String get cartEmptyTitle => 'Tu carrito está vacío';

  @override
  String get cartEmptyMessage =>
      'Explora la tienda y añade las prendas que te gusten: aparecerán aquí.';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '1 artículo',
      zero: 'Ningún artículo',
    );
    return '$_temp0';
  }

  @override
  String get checkoutTitle => 'Pago';

  @override
  String get checkoutPlaceOrder => 'Realizar pedido';

  @override
  String checkoutPayAmount(String amount) {
    return 'Pagar $amount';
  }

  @override
  String get checkoutSelectCard =>
      'Selecciona o añade una tarjeta para continuar.';

  @override
  String get checkoutEnterCvv =>
      'Introduce el CVV de la tarjeta para continuar.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsSelectLanguage => 'Seleccionar idioma';

  @override
  String settingsLanguageChanged(String language) {
    return 'Idioma cambiado a $language';
  }

  @override
  String get settingsCurrency => 'Moneda';

  @override
  String get settingsTheme => 'Apariencia';

  @override
  String get settingsSupport => 'Soporte';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageGerman => 'Alemán';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageArabic => 'Árabe';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Francés';

  @override
  String get adminDashboard => 'Panel de control';

  @override
  String get adminSignInTitle => 'Acceso del propietario';

  @override
  String get adminSignInSubtitle =>
      'Inicia sesión con tu cuenta de administrador para gestionar la tienda.';

  @override
  String get adminAccessDenied => 'Acceso denegado';

  @override
  String get adminAccessDeniedMessage =>
      'Esta cuenta no está registrada como administradora de la tienda.';

  @override
  String adminWelcome(String name) {
    return 'Bienvenido de nuevo, $name';
  }

  @override
  String get adminNavOverview => 'Resumen';

  @override
  String get adminNavProducts => 'Productos';

  @override
  String get adminNavOrders => 'Pedidos';

  @override
  String get adminNavCustomers => 'Clientes';

  @override
  String get adminNavReviews => 'Valoraciones';

  @override
  String get adminNavPromotions => 'Promociones';

  @override
  String get adminNavSettings => 'Ajustes';

  @override
  String get adminKpiRevenueToday => 'Ingresos de hoy';

  @override
  String get adminKpiRevenueTotal => 'Ingresos totales';

  @override
  String get adminKpiOrders => 'Pedidos';

  @override
  String get adminKpiAverageOrderValue => 'Valor medio del pedido';

  @override
  String get adminKpiNewCustomers => 'Nuevos clientes';

  @override
  String get adminKpiLowStock => 'Existencias bajas';

  @override
  String adminSalesLastDays(int count) {
    return 'Ventas — últimos $count días';
  }

  @override
  String get adminTopProducts => 'Productos más vendidos';

  @override
  String get adminRecentOrders => 'Pedidos recientes';

  @override
  String get adminNoData => 'Aún no hay datos';

  @override
  String get adminProductsTitle => 'Productos';

  @override
  String get adminProductAdd => 'Añadir producto';

  @override
  String get adminProductEdit => 'Editar producto';

  @override
  String get adminProductDelete => 'Eliminar producto';

  @override
  String adminProductDeleteConfirm(String title) {
    return '¿Eliminar “$title”? Esta acción no se puede deshacer.';
  }

  @override
  String get adminProductSaved => 'Producto guardado';

  @override
  String get adminProductDeleted => 'Producto eliminado';

  @override
  String get adminProductNone =>
      'Aún no hay productos. Añade tu primer producto para empezar.';

  @override
  String get adminFieldTitle => 'Título';

  @override
  String get adminFieldBrand => 'Marca';

  @override
  String get adminFieldCategory => 'Categoría';

  @override
  String get adminFieldDescription => 'Descripción';

  @override
  String get adminFieldImageUrl => 'URL de la imagen';

  @override
  String get adminFieldStock => 'Existencias';

  @override
  String get adminFieldSku => 'SKU';

  @override
  String get adminFieldDiscountPercent => '% de descuento';

  @override
  String get adminFieldPublished => 'Publicado';

  @override
  String get adminStatePublished => 'Publicado';

  @override
  String get adminStateDraft => 'Borrador';

  @override
  String adminStockLeft(int count) {
    return 'Quedan $count';
  }

  @override
  String get adminOrdersTitle => 'Pedidos';

  @override
  String adminOrderNumber(String id) {
    return 'Pedido $id';
  }

  @override
  String get adminOrderUpdateStatus => 'Actualizar estado';

  @override
  String get adminOrderStatusUpdated => 'Estado del pedido actualizado';

  @override
  String get adminOrderNone => 'Ningún pedido coincide con este filtro.';

  @override
  String get orderStatusPending => 'Pendiente';

  @override
  String get orderStatusProcessing => 'En proceso';

  @override
  String get orderStatusShipped => 'Enviado';

  @override
  String get orderStatusDelivered => 'Entregado';

  @override
  String get orderStatusCanceled => 'Cancelado';

  @override
  String get orderStatusReturned => 'Devuelto';

  @override
  String get adminCustomersTitle => 'Clientes';

  @override
  String adminCustomerSince(String date) {
    return 'Cliente desde $date';
  }

  @override
  String get adminCustomerTotalSpent => 'Gasto total';

  @override
  String get adminCustomerOrders => 'Pedidos realizados';

  @override
  String get adminCustomerBlock => 'Bloquear cliente';

  @override
  String get adminCustomerUnblock => 'Desbloquear cliente';

  @override
  String get adminCustomerBlocked => 'Bloqueado';

  @override
  String get adminCustomerNone => 'Aún no hay clientes.';

  @override
  String get adminReviewsTitle => 'Valoraciones';

  @override
  String get adminReviewsPending => 'Pendientes de aprobación';

  @override
  String get adminReviewApprove => 'Aprobar';

  @override
  String get adminReviewReject => 'Rechazar';

  @override
  String get adminReviewNone => 'Nada que moderar.';

  @override
  String get adminPromotionsTitle => 'Promociones';

  @override
  String get adminPromoCreate => 'Crear promoción';

  @override
  String get adminPromoCode => 'Código promocional';

  @override
  String get adminPromoPercentOff => 'Porcentaje de descuento';

  @override
  String get adminPromoValidFrom => 'Válido desde';

  @override
  String get adminPromoValidTo => 'Válido hasta';

  @override
  String get adminPromoUsageLimit => 'Límite de uso';

  @override
  String get adminPromoActive => 'Activa';

  @override
  String get adminPromoInactive => 'Inactiva';

  @override
  String get adminPromoNone => 'Aún no hay promociones.';

  @override
  String get adminSettingsStoreName => 'Nombre de la tienda';

  @override
  String get adminSettingsCurrency => 'Moneda';

  @override
  String get adminSettingsSupportEmail => 'Correo electrónico de soporte';

  @override
  String get adminSettingsEnvironment => 'Entorno';
}
