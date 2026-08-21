import 'package:get/get.dart';

import '../models/product_model.dart';

/// Product search + recent-search history, backed by the existing demo data.
class ProductSearchController extends GetxController {
  ProductSearchController();

  static ProductSearchController get to => Get.find<ProductSearchController>();

  static const int maxHistoryLength = 8;

  final List<String> _history = ["White Shirt", "Guess Hat", "Gray Dress"];

  /// De-duplicated pool of every demo product available to search.
  late final List<ProductModel> _catalog = _buildCatalog();

  List<String> get history => List.unmodifiable(_history);

  List<ProductModel> get catalog => List.unmodifiable(_catalog);

  /// Case-insensitive match on title or brand. Returns an empty list for a
  /// blank query so callers can show the idle state instead of everything.
  List<ProductModel> search(String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return const [];
    return _catalog
        .where((product) =>
            product.title.toLowerCase().contains(term) ||
            product.brandName.toLowerCase().contains(term))
        .toList();
  }

  void addToHistory(String query) {
    final term = query.trim();
    if (term.isEmpty) return;
    _history.removeWhere((item) => item.toLowerCase() == term.toLowerCase());
    _history.insert(0, term);
    if (_history.length > maxHistoryLength) {
      _history.removeRange(maxHistoryLength, _history.length);
    }
    update();
  }

  void removeFromHistory(String query) {
    _history.remove(query);
    update();
  }

  void clearHistory() {
    if (_history.isEmpty) return;
    _history.clear();
    update();
  }

  List<ProductModel> _buildCatalog() {
    final seen = <String>{};
    final all = <ProductModel>[
      ...demoPopularProducts,
      ...demoFlashSaleProducts,
      ...demoBestSellersProducts,
      ...kidsProducts,
    ];
    return all
        .where((product) => seen.add("${product.title}-${product.image}"))
        .toList();
  }
}
