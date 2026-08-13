import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/cart_button.dart';
import '../../../components/empty_state_view.dart';
import '../../../constants.dart';
import '../../../models/cart_item_model.dart';
import '../../../repositories/cart_repository.dart';
import '../../../route/route_constants.dart';
import 'components/cart_item_card.dart';
import 'components/order_summary_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartRepository _cart = CartRepository.instance;
  final TextEditingController _couponController = TextEditingController();

  String? _appliedCoupon;

  @override
  void initState() {
    super.initState();
    // Demo convenience: the cart is not empty the first time it is opened.
    _cart.seedDemoItems();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _appliedCoupon = code.toUpperCase());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Coupon $_appliedCoupon saved for checkout")),
    );
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
    return ListenableBuilder(
      listenable: _cart,
      builder: (context, _) {
        final items = _cart.items;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Cart"),
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
                  title: "Checkout",
                  subTitle: "${_cart.itemCount} items",
                  press: _checkout,
                ),
          body: items.isEmpty
              ? EmptyStateView(
                  title: "Your cart is empty",
                  description:
                      "Looks like you have not added anything yet. Browse the shop and find something you love.",
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
                                context, productDetailsScreenRoute),
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
                          onPressed: _applyCoupon,
                          child: const Text("Apply"),
                        ),
                      ),
                    ),
                    if (_appliedCoupon != null)
                      Padding(
                        padding: const EdgeInsets.only(top: defaultPadding / 2),
                        child: Text(
                          "Coupon $_appliedCoupon will be validated at checkout.",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: successColor),
                        ),
                      ),
                    const SizedBox(height: defaultPadding * 1.5),
                    OrderSummaryCard(
                      subtotal: _cart.subtotal,
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
