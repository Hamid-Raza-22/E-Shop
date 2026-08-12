import 'product_model.dart';

/// A single line item inside the cart.
///
/// [quantity] is mutable because the cart screen updates it in place through
/// [CartRepository]. Everything else is derived, so there is a single source of
/// truth for pricing.
class CartItem {
  CartItem({
    required this.product,
    this.quantity = 1,
  });

  final ProductModel product;
  int quantity;

  /// Price actually charged for one unit (discounted price when available).
  double get unitPrice => product.priceAfetDiscount ?? product.price;

  double get totalPrice => unitPrice * quantity;

  /// Identity used to merge duplicates in the cart. The demo [ProductModel] has
  /// no id, so title + image is the closest stable key available. When a real
  /// API is introduced this should become `product.id`.
  String get productKey => "${product.title}-${product.image}";
}
