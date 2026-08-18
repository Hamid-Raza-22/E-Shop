import 'package:flutter/foundation.dart';

import '../models/product_model.dart';

/// In-memory wishlist/bookmarks shared between the product and bookmark screens.
class BookmarkRepository extends ChangeNotifier {
  BookmarkRepository._() {
    // Seeded so the Bookmark tab is not empty on first open.
    _products.addAll(demoPopularProducts.take(4));
  }

  static final BookmarkRepository instance = BookmarkRepository._();

  final List<ProductModel> _products = [];

  List<ProductModel> get products => List.unmodifiable(_products);

  bool get isEmpty => _products.isEmpty;

  int get count => _products.length;

  static String _keyOf(ProductModel product) =>
      "${product.title}-${product.image}";

  bool contains(ProductModel product) {
    final key = _keyOf(product);
    return _products.any((item) => _keyOf(item) == key);
  }

  /// Adds or removes [product]; returns true when it ends up bookmarked.
  bool toggle(ProductModel product) {
    final key = _keyOf(product);
    final index = _products.indexWhere((item) => _keyOf(item) == key);

    if (index == -1) {
      _products.add(product);
      notifyListeners();
      return true;
    }
    _products.removeAt(index);
    notifyListeners();
    return false;
  }

  void remove(ProductModel product) {
    final key = _keyOf(product);
    _products.removeWhere((item) => _keyOf(item) == key);
    notifyListeners();
  }

  void clear() {
    if (_products.isEmpty) return;
    _products.clear();
    notifyListeners();
  }
}
