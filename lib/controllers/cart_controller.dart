import 'package:get/get.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../models/promotion_model.dart';
import '../services/promotion_service.dart';
import '../utils/service_locator.dart';

/// In-memory cart shared across screens.
///
/// The line items are local to the session; the coupon is validated against the
/// promotions the dashboard manages, so a code only works while it is active.
class CartController extends GetxController {
  CartController({PromotionService? promotionService})
      : _injectedPromotions = promotionService;

  static CartController get to => Get.find<CartController>();

  /// Free shipping above this subtotal, otherwise [shippingRate] is charged.
  static const double freeShippingThreshold = 500;
  static const double shippingRate = 15;
  static const double vatRate = 0.05;

  final PromotionService? _injectedPromotions;

  PromotionService? get _promotions =>
      _injectedPromotions ?? serviceOrNull<PromotionService>();

  final List<CartItem> _items = [];
  PromotionModel? _promotion;

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  /// Coupon currently applied to this cart, if any.
  PromotionModel? get promotion => _promotion;

  /// Total number of units (not lines) in the cart.
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Coupon discount, capped at the subtotal so a total can never go negative.
  double get discount {
    final promotion = _promotion;
    if (promotion == null || _items.isEmpty) return 0;
    final value = promotion.discountFor(subtotal);
    return value > subtotal ? subtotal : value;
  }

  double get shippingFee {
    if (_items.isEmpty || subtotal >= freeShippingThreshold) return 0;
    return shippingRate;
  }

  double get vat => (subtotal - discount + shippingFee) * vatRate;

  double get total => subtotal - discount + shippingFee + vat;

  bool get hasFreeShipping => !isEmpty && shippingFee == 0;

  /// Validates [code] against Firestore and applies it.
  ///
  /// Returns null on success, otherwise a message explaining the refusal.
  Future<String?> applyPromotion(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return "Enter a coupon code.";

    final service = _promotions;
    if (service == null) return "Coupons are unavailable right now.";

    final PromotionModel? promotion;
    try {
      promotion = await service.findByCode(trimmed);
    } catch (_) {
      return "We could not check that coupon. Please try again.";
    }

    if (promotion == null) return "That coupon code does not exist.";
    if (promotion.isExhausted) return "That coupon has been fully redeemed.";
    if (!promotion.isCurrentlyValid) return "That coupon is no longer valid.";

    _promotion = promotion;
    update();
    return null;
  }

  void removePromotion() {
    if (_promotion == null) return;
    _promotion = null;
    update();
  }

  /// Counts the redemption after the order was placed, so an abandoned cart
  /// never eats into a coupon's usage limit.
  Future<void> redeemPromotion() async {
    final promotion = _promotion;
    final id = promotion?.id;
    if (promotion == null || id == null) return;

    try {
      await _promotions?.incrementUsage(id);
    } catch (_) {
      // A missed counter must not fail a completed order.
    }
  }

  /// Adds [product], merging into the existing line when already present.
  void add(ProductModel product, {int quantity = 1}) {
    if (quantity < 1) return;
    final key = "${product.title}-${product.image}";
    final existing =
        _items.where((item) => item.productKey == key).firstOrNull;

    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    update();
  }

  void increment(CartItem item) {
    item.quantity++;
    update();
  }

  /// Decrements down to a minimum of 1; removal is an explicit action.
  void decrement(CartItem item) {
    if (item.quantity <= 1) return;
    item.quantity--;
    update();
  }

  void remove(CartItem item) {
    _items.remove(item);
    update();
  }

  void clear() {
    if (_items.isEmpty && _promotion == null) return;
    _items.clear();
    _promotion = null;
    update();
  }

  /// Seeds a couple of items so the cart demo is not empty on first open.
  void seedDemoItems() {
    if (_items.isNotEmpty) return;
    _items.addAll([
      CartItem(product: demoPopularProducts.first, quantity: 1),
      CartItem(product: demoFlashSaleProducts.first, quantity: 2),
    ]);
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
