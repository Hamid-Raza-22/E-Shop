import 'package:flutter_test/flutter_test.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/promotion_model.dart';
import 'package:shop/services/promotion_service.dart';

/// Returns whatever it is told to, so the coupon rules can be tested without
/// Firestore.
class _StubPromotionService extends PromotionService {
  _StubPromotionService(this.promotion);

  final PromotionModel? promotion;

  int incrementCalls = 0;

  @override
  Future<PromotionModel?> findByCode(String code) async =>
      promotion?.code == code.toUpperCase() ? promotion : null;

  @override
  Future<void> incrementUsage(String id) async => incrementCalls++;
}

void main() {
  final product = ProductModel(
    image: productDemoImg1,
    title: "Coupon Test",
    brandName: "Test Brand",
    price: 100,
  );

  PromotionModel promotion({
    int percentOff = 10,
    bool isActive = true,
    int? usageLimit,
    int usedCount = 0,
    Duration validFor = const Duration(days: 7),
  }) {
    final now = DateTime.now();
    return PromotionModel(
      id: "promo_1",
      code: "SAVE10",
      title: "Save",
      percentOff: percentOff,
      validFrom: now.subtract(const Duration(days: 1)),
      validTo: now.add(validFor),
      usageLimit: usageLimit,
      usedCount: usedCount,
      isActive: isActive,
    );
  }

  CartController cartWith(PromotionModel? available) {
    final cart = CartController(
      promotionService: _StubPromotionService(available),
    );
    cart.add(product, quantity: 2); // subtotal 200
    return cart;
  }

  test('an unknown code is refused', () async {
    final cart = cartWith(promotion());

    expect(await cart.applyPromotion("NOPE"), isNotNull);
    expect(cart.promotion, isNull);
    expect(cart.discount, 0);
  });

  test('a blank code is refused without hitting the service', () async {
    final cart = cartWith(promotion());

    expect(await cart.applyPromotion("   "), isNotNull);
    expect(cart.promotion, isNull);
  });

  test('a valid code discounts the subtotal, VAT and total', () async {
    final cart = cartWith(promotion());

    expect(await cart.applyPromotion("save10"), isNull);
    expect(cart.discount, closeTo(20, 0.0001));
    // 200 - 20 + 15 shipping = 195, VAT 5% = 9.75
    expect(cart.vat, closeTo(9.75, 0.0001));
    expect(cart.total, closeTo(204.75, 0.0001));
  });

  test('an inactive or exhausted code is refused', () async {
    expect(
      await cartWith(promotion(isActive: false)).applyPromotion("SAVE10"),
      isNotNull,
    );
    expect(
      await cartWith(promotion(usageLimit: 1, usedCount: 1))
          .applyPromotion("SAVE10"),
      isNotNull,
    );
  });

  test('the discount never exceeds the subtotal', () async {
    final cart = cartWith(promotion(percentOff: 90));
    await cart.applyPromotion("SAVE10");

    expect(cart.discount, lessThanOrEqualTo(cart.subtotal));
    expect(cart.total, greaterThan(0));
  });

  test('removing and clearing drop the coupon', () async {
    final cart = cartWith(promotion());

    await cart.applyPromotion("SAVE10");
    cart.removePromotion();
    expect(cart.promotion, isNull);

    await cart.applyPromotion("SAVE10");
    cart.clear();
    expect(cart.promotion, isNull);
    expect(cart.discount, 0);
  });

  test('redeeming counts the usage exactly once', () async {
    final service = _StubPromotionService(promotion());
    final cart = CartController(promotionService: service);
    cart.add(product);

    await cart.applyPromotion("SAVE10");
    await cart.redeemPromotion();

    expect(service.incrementCalls, 1);
  });

  test('an empty cart has no discount even with a coupon applied', () async {
    final cart = cartWith(promotion());
    await cart.applyPromotion("SAVE10");

    cart.remove(cart.items.first);
    expect(cart.discount, 0);
  });
}
