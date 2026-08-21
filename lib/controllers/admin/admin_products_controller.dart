import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../services/product_service.dart';

/// How the product list is narrowed down in the dashboard.
enum ProductFilter { all, published, draft, lowStock }

/// Catalog management: live product list, search, filtering and CRUD.
class AdminProductsController extends GetxController {
  AdminProductsController({ProductService? service})
      : _service = service ?? Get.find<ProductService>();

  final ProductService _service;

  static AdminProductsController get to => Get.find<AdminProductsController>();

  final RxList<ProductModel> _products = <ProductModel>[].obs;
  final RxString _query = "".obs;
  final Rx<ProductFilter> _filter = ProductFilter.all.obs;
  final RxBool _isSaving = false.obs;
  final RxnString _error = RxnString();

  String get query => _query.value;

  ProductFilter get filter => _filter.value;

  bool get isSaving => _isSaving.value;

  String? get error => _error.value;

  int get totalCount => _products.length;

  int get lowStockCount =>
      _products.where((product) => product.isLowStock).length;

  /// Products after the active filter + search term are applied.
  List<ProductModel> get products {
    final term = _query.value.trim().toLowerCase();

    return _products.where((product) {
      final matchesFilter = switch (_filter.value) {
        ProductFilter.all => true,
        ProductFilter.published => product.isPublished,
        ProductFilter.draft => !product.isPublished,
        ProductFilter.lowStock => product.isLowStock || !product.isInStock,
      };
      if (!matchesFilter) return false;
      if (term.isEmpty) return true;

      return product.title.toLowerCase().contains(term) ||
          product.brandName.toLowerCase().contains(term) ||
          (product.sku?.toLowerCase().contains(term) ?? false);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _products.bindStream(_service.watchAll());
  }

  void search(String value) => _query.value = value;

  void setFilter(ProductFilter value) => _filter.value = value;

  Future<bool> save(ProductModel product) async {
    _isSaving.value = true;
    _error.value = null;
    try {
      if (product.id == null) {
        await _service.create(product);
      } else {
        await _service.update(product);
      }
      return true;
    } catch (exception) {
      _error.value = exception.toString();
      return false;
    } finally {
      _isSaving.value = false;
    }
  }

  Future<bool> delete(String id) => _guard(() => _service.delete(id));

  Future<bool> togglePublished(ProductModel product) {
    final id = product.id;
    if (id == null) return Future.value(false);
    return _guard(
      () => _service.setPublished(id, isPublished: !product.isPublished),
    );
  }

  Future<bool> adjustStock(ProductModel product, int delta) {
    final id = product.id;
    if (id == null) return Future.value(false);
    // Guard against pushing stock below zero from the quick +/- buttons.
    if ((product.stock ?? 0) + delta < 0) return Future.value(false);
    return _guard(() => _service.adjustStock(id, delta));
  }

  /// Copies the bundled demo catalog into Firestore so a fresh project has
  /// something to manage instead of an empty dashboard.
  Future<bool> seedDemoCatalog() {
    if (_products.isNotEmpty) return Future.value(false);
    return _guard(() => _service.importAll(_demoCatalog()));
  }

  List<ProductModel> _demoCatalog() {
    final seen = <String>{};
    return [
      ...demoPopularProducts,
      ...demoFlashSaleProducts,
      ...demoBestSellersProducts,
      ...kidsProducts,
    ]
        .where((product) => seen.add(product.key))
        .map((product) => product.copyWith(stock: 25, isPublished: true))
        .toList();
  }

  Future<bool> _guard(Future<void> Function() action) async {
    _error.value = null;
    try {
      await action();
      return true;
    } catch (exception) {
      _error.value = exception.toString();
      return false;
    }
  }
}
