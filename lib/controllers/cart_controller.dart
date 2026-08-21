import 'package:get/get.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

/// In-memory cart shared across screens.
///
/// This is intentionally a thin [ChangeNotifier] singleton so it can later be
/// replaced by an API-backed repository without touching the widgets: screens
/// only depend on the public methods/getters below.
class CartController extends GetxController {
  CartController();

  static CartController get to => Get.find<CartController>();

  /// Free shipping above this subtotal, otherwise [shippingRate] is charged.
  static const double freeShippingThreshold = 500;
  static const double shippingRate = 15;
  static const double vatRate = 0.05;

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  /// Total number of units (not lines) in the cart.
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get shippingFee {
    if (_items.isEmpty || subtotal >= freeShippingThreshold) return 0;
    return shippingRate;
  }

  double get vat => (subtotal + shippingFee) * vatRate;

  double get total => subtotal + shippingFee + vat;

  bool get hasFreeShipping => !isEmpty && shippingFee == 0;

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
    if (_items.isEmpty) return;
    _items.clear();
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
