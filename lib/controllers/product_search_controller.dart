import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';
import '../utils/service_locator.dart';

/// Product search + recent-search history, backed by the live published catalog.
///
/// Falls back to the bundled demo catalog when Firestore is unavailable, so
/// search keeps working offline and in tests.
class ProductSearchController extends GetxController {
  ProductSearchController({ProductService? service}) : _injected = service;

  static ProductSearchController get to => Get.find<ProductSearchController>();

  static const int maxHistoryLength = 8;

  final ProductService? _injected;
  final RxList<ProductModel> _catalog = <ProductModel>[].obs;
  final List<String> _history = ["White Shirt", "Guess Hat", "Gray Dress"];

  List<String> get history => List.unmodifiable(_history);

  List<ProductModel> get catalog => _catalog
      .where((product) => product.isPublished && product.isInStock)
      .toList();

  @override
  void onInit() {
    super.onInit();
    final service = _injected ?? serviceOrNull<ProductService>();
    if (service != null) {
      _catalog.bindStream(service.watchPublished());
      return;
    }
    _catalog.assignAll(_buildCatalog());
  }

  /// Case-insensitive match on title, brand or category. Returns an empty list
  /// for a blank query so callers can show the idle state instead of everything.
  List<ProductModel> search(String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return const [];
    return catalog
        .where((product) =>
            product.title.toLowerCase().contains(term) ||
            product.brandName.toLowerCase().contains(term) ||
            (product.category?.toLowerCase().contains(term) ?? false))
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

  static List<ProductModel> _buildCatalog() {
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
