import 'package:flutter_test/flutter_test.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/repositories/cart_repository.dart';

void main() {
  final cart = CartRepository.instance;

  final cheapProduct = ProductModel(
    image: productDemoImg1,
    title: "Test Cheap",
    brandName: "Test Brand",
    price: 100,
  );

  final discountedProduct = ProductModel(
    image: productDemoImg2,
    title: "Test Discounted",
    brandName: "Test Brand",
    price: 200,
    priceAfetDiscount: 150,
    dicountpercent: 25,
  );

  setUp(cart.clear);

  test('starts empty', () {
    expect(cart.isEmpty, isTrue);
    expect(cart.itemCount, 0);
    expect(cart.subtotal, 0);
  });

  test('adding the same product merges into one line', () {
    cart.add(cheapProduct);
    cart.add(cheapProduct);

    expect(cart.items.length, 1);
    expect(cart.items.first.quantity, 2);
    expect(cart.itemCount, 2);
  });

  test('uses the discounted price as the unit price', () {
    cart.add(discountedProduct);

    expect(cart.items.first.unitPrice, 150);
    expect(cart.subtotal, 150);
  });

  test('subtotal reflects quantity changes', () {
    cart.add(cheapProduct);
    final item = cart.items.first;

    cart.increment(item);
    expect(cart.subtotal, 200);

    cart.decrement(item);
    expect(cart.subtotal, 100);
  });

  test('decrement never goes below one', () {
    cart.add(cheapProduct);
    final item = cart.items.first;

    cart.decrement(item);
    cart.decrement(item);

    expect(item.quantity, 1);
  });

  test('charges shipping below the free-shipping threshold', () {
    cart.add(cheapProduct);

    expect(cart.subtotal, lessThan(CartRepository.freeShippingThreshold));
    expect(cart.shippingFee, CartRepository.shippingRate);
    expect(cart.hasFreeShipping, isFalse);
  });

  test('gives free shipping at or above the threshold', () {
    cart.add(cheapProduct, quantity: 5); // 5 x 100 = 500

    expect(cart.subtotal, CartRepository.freeShippingThreshold);
    expect(cart.shippingFee, 0);
    expect(cart.hasFreeShipping, isTrue);
  });

  test('total is subtotal + shipping + VAT', () {
    cart.add(cheapProduct); // 100 + 15 shipping = 115, VAT 5% = 5.75

    expect(cart.vat, closeTo(5.75, 0.0001));
    expect(cart.total, closeTo(120.75, 0.0001));
  });

  test('remove drops the line and empties the cart', () {
    cart.add(cheapProduct);
    cart.remove(cart.items.first);

    expect(cart.isEmpty, isTrue);
    expect(cart.shippingFee, 0);
  });

  test('notifies listeners when the cart changes', () {
    var notifications = 0;
    void listener() => notifications++;

    cart.addListener(listener);
    addTearDown(() => cart.removeListener(listener));

    cart.add(cheapProduct);
    cart.increment(cart.items.first);

    expect(notifications, 2);
  });

  test('ignores non-positive quantities', () {
    cart.add(cheapProduct, quantity: 0);
    expect(cart.isEmpty, isTrue);
  });
}
