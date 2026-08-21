import 'package:get/get.dart';

import '../../models/promotion_model.dart';
import '../../services/promotion_service.dart';

/// Promo-code management.
class AdminPromotionsController extends GetxController {
  AdminPromotionsController({PromotionService? service})
      : _service = service ?? Get.find<PromotionService>();

  final PromotionService _service;

  static AdminPromotionsController get to =>
      Get.find<AdminPromotionsController>();

  final RxList<PromotionModel> _all = <PromotionModel>[].obs;
  final RxBool _isSaving = false.obs;
  final RxnString _error = RxnString();

  bool get isSaving => _isSaving.value;

  String? get error => _error.value;

  List<PromotionModel> get promotions => _all.toList();

  int get liveCount =>
      _all.where((promotion) => promotion.isCurrentlyValid).length;

  @override
  void onInit() {
    super.onInit();
    _all.bindStream(_service.watchAll());
  }

  /// True when [code] is already taken by another promotion, so the form can
  /// reject duplicates before hitting Firestore.
  bool isCodeTaken(String code, {String? ignoreId}) {
    final normalized = code.trim().toUpperCase();
    return _all.any(
      (promotion) => promotion.code == normalized && promotion.id != ignoreId,
    );
  }

  Future<bool> save(PromotionModel promotion) async {
    if (promotion.validTo.isBefore(promotion.validFrom)) {
      _error.value = "The end date cannot be before the start date.";
      return false;
    }
    if (isCodeTaken(promotion.code, ignoreId: promotion.id)) {
      _error.value = "That promo code already exists.";
      return false;
    }

    _isSaving.value = true;
    _error.value = null;
    try {
      if (promotion.id == null) {
        await _service.create(promotion);
      } else {
        await _service.update(promotion);
      }
      return true;
    } catch (exception) {
      _error.value = exception.toString();
      return false;
    } finally {
      _isSaving.value = false;
    }
  }

  Future<bool> toggleActive(PromotionModel promotion) {
    final id = promotion.id;
    if (id == null) return Future.value(false);
    return _guard(() => _service.setActive(id, isActive: !promotion.isActive));
  }

  Future<bool> delete(String id) => _guard(() => _service.delete(id));

  void clearError() => _error.value = null;

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
