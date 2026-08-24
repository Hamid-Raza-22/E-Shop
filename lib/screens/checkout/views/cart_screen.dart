import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shop/l10n/app_localizations.dart';

import '../../../components/cart_button.dart';
import '../../../components/empty_state_view.dart';
import '../../../constants.dart';
import '../../../models/cart_item_model.dart';
import '../../../controllers/cart_controller.dart';
import '../../../route/route_constants.dart';
import 'components/cart_item_card.dart';
import 'components/order_summary_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cart = CartController.to;
  final TextEditingController _couponController = TextEditingController();

  bool _isApplyingCoupon = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty || _isApplyingCoupon) return;

    FocusScope.of(context).unfocus();
    setState(() => _isApplyingCoupon = true);
    final failure = await _cart.applyPromotion(code);
    if (!mounted) return;
    setState(() => _isApplyingCoupon = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          failure ?? "Coupon ${code.toUpperCase()} applied",
        ),
      ),
    );
    if (failure == null) _couponController.clear();
  }

  void _removeCoupon() {
    _cart.removePromotion();
    _couponController.clear();
  }

  Future<void> _confirmRemove(CartItem item) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove item"),
        content: Text("Remove \"${item.product.title}\" from your cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Remove"),
          ),
        ],
      ),
    );

    if (shouldRemove == true) _cart.remove(item);
  }

  /// Cart is step 1 of checkout; the order is created on the payment screen.
  void _checkout() {
    if (_cart.isEmpty) return;
    Navigator.pushNamed(context, paymentMethodScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) {
        final translations = AppLocalizations.of(context);
        final items = _cart.items;

        return Scaffold(
          appBar: AppBar(
            title: Text(translations.cartTitle),
            actions: [
              if (items.isNotEmpty)
                IconButton(
                  onPressed: _cart.clear,
                  tooltip: "Clear cart",
                  icon: SvgPicture.asset(
                    "assets/icons/Delete.svg",
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyLarge!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: items.isEmpty
              ? null
              : CartButton(
                  price: _cart.total,
                  title: translations.checkoutTitle,
                  subTitle: translations.cartItemsCount(_cart.itemCount),
                  press: _checkout,
                ),
          body: items.isEmpty
              ? EmptyStateView(
                  title: translations.cartEmptyTitle,
                  description:
                      translations.cartEmptyMessage,
                  actionLabel: "Start shopping",
                  onAction: () =>
                      Navigator.pushNamed(context, homeScreenRoute),
                )
              : ListView(
                  padding: const EdgeInsets.all(defaultPadding),
                  children: [
                    Text(
                      "Review your order",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    ...List.generate(items.length, (index) {
                      final item = items[index];
                      return Column(
                        children: [
                          CartItemCard(
                            item: item,
                            onIncrement: () => _cart.increment(item),
                            onDecrement: () => _cart.decrement(item),
                            onRemove: () => _confirmRemove(item),
                            press: () => Navigator.pushNamed(
                                context, productDetailsScreenRoute,
                                arguments: item.product),
                          ),
                          if (index != items.length - 1)
                            const Divider(height: 1),
                        ],
                      );
                    }),
                    const SizedBox(height: defaultPadding * 1.5),
                    Text(
                      "Your Coupon code",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextField(
                      controller: _couponController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _applyCoupon(),
                      decoration: InputDecoration(
                        hintText: "Type coupon code",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding * 0.75),
                          child: SvgPicture.asset(
                            "assets/icons/Coupon.svg",
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              greyColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        suffixIcon: TextButton(
                          onPressed: _isApplyingCoupon ? null : _applyCoupon,
                          child: Text(_isApplyingCoupon ? "…" : "Apply"),
                        ),
                      ),
                    ),
                    if (_cart.promotion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: defaultPadding / 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${_cart.promotion!.code} applied — ${_cart.promotion!.percentOff}% off",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: successColor),
                              ),
                            ),
                            TextButton(
                              onPressed: _removeCoupon,
                              child: const Text("Remove"),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: defaultPadding * 1.5),
                    OrderSummaryCard(
                      subtotal: _cart.subtotal,
                      discount: _cart.discount,
                      shippingFee: _cart.shippingFee,
                      vat: _cart.vat,
                      total: _cart.total,
                      isShippingFree: _cart.hasFreeShipping,
                    ),
                    const SizedBox(height: defaultPadding),
                  ],
                ),
        );
      },
    );
  }
}
