import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../components/card_info.dart';
import '../../../components/check_mark.dart';
import '../../../constants.dart';
import '../../../models/payment_card_model.dart';
import '../../../controllers/address_controller.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/payment_controller.dart';
import '../../../controllers/wallet_controller.dart';
import '../../../route/route_constants.dart';
import '../../../services/product_service.dart';
import '../../../utils/formatters.dart';
import '../../../utils/service_locator.dart';
import 'add_new_card_screen.dart';

/// Checkout step 2: choose how to pay, then place the order.
class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  /// Guards against a second tap while the order is being written.
  bool _isPlacingOrder = false;

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _placeOrder() async {
    final cart = CartController.to;
    if (cart.isEmpty || _isPlacingOrder) return;

    final payment = PaymentController.to;
    final wallet = WalletController.to;

    // Wallet payments must actually cover the total.
    if (payment.selectedOption == PaymentOption.wallet) {
      final paid = wallet.spend(
        cart.total,
        products: cart.items.map((item) => item.product).toList(),
      );
      if (!paid) {
        _showMessage(
          "Wallet balance is too low (${formatPrice(wallet.balance)}). Top up or choose another method.",
        );
        return;
      }
    }

    setState(() => _isPlacingOrder = true);
    final items = cart.items;
    final order = await OrderController.to.createFromCart(items, cart.total);

    if (order == null) {
      // The order never reached Firestore, so the cart stays as it was and a
      // wallet payment is refunded.
      if (payment.selectedOption == PaymentOption.wallet) {
        wallet.topUp(cart.total);
      }
      if (mounted) setState(() => _isPlacingOrder = false);
      _showMessage("We could not place your order. Please try again.");
      return;
    }

    // Selling reduces stock, which is what hides sold-out products in the
    // storefront and flags them in the dashboard.
    final products = serviceOrNull<ProductService>();
    if (products != null) {
      for (final item in items) {
        final productId = item.product.id;
        if (productId == null) continue;
        try {
          await products.adjustStock(productId, -item.quantity);
        } catch (_) {
          // Stock drift must not break a paid order.
        }
      }
    }

    // Counted only now that the order exists.
    await cart.redeemPromotion();

    cart.clear();
    payment.clearCvv();
    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    Navigator.pushNamedAndRemoveUntil(
      context,
      thanksForOrderScreenRoute,
      (route) => route.isFirst,
      arguments: order.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final payment = PaymentController.to;
    final cart = CartController.to;

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: SafeArea(
        child: GetBuilder<PaymentController>(
          builder: (paymentController) => GetBuilder<CartController>(
            builder: (cartController) => GetBuilder<WalletController>(
              builder: (walletController) {
                return ListView(
                  padding: const EdgeInsets.all(defaultPadding),
                  children: [
                    _DeliveryAddressCard(),
                    const SizedBox(height: defaultPadding * 1.5),
                    Text(
                      "Saved cards",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding),
                    if (payment.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(defaultBorderRadious)),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Text(
                          "You have no saved cards yet.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else
                      ...payment.cards.map(
                        (card) => Padding(
                          padding: const EdgeInsets.only(bottom: defaultPadding),
                          child: CardInfo(
                            last4Digits: card.last4Digits,
                            name: card.holderName,
                            expiryDate: card.expiryDate,
                            isSelected:
                                payment.selectedOption == PaymentOption.card &&
                                    payment.selectedCardId == card.id,
                            press: () => payment.selectCard(card.id),
                            onCvvChanged: payment.setCvv,
                          ),
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddNewCardScreen()),
                      ),
                      icon: SvgPicture.asset(
                        "assets/icons/Newcard.svg",
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).textTheme.bodyLarge!.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: const Text("Add new card"),
                    ),
                    const SizedBox(height: defaultPadding * 1.5),
                    Text(
                      "Other payment options",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    ...[PaymentOption.cashOnDelivery, PaymentOption.wallet].map(
                      (option) => Column(
                        children: [
                          ListTile(
                            onTap: () => payment.selectOption(option),
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 24,
                            leading: SvgPicture.asset(
                              option.svgSrc,
                              height: 24,
                              width: 24,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).textTheme.bodyLarge!.color!,
                                BlendMode.srcIn,
                              ),
                            ),
                            title: Text(option.label),
                            subtitle: option == PaymentOption.wallet
                                ? Text(
                                    "Balance ${formatPrice(WalletController.to.balance)}",
                                  )
                                : null,
                            trailing: payment.selectedOption == option
                                ? const CheckMark()
                                : null,
                          ),
                          const Divider(height: 1),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Total payable",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          formatPrice(cart.total),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      // Disabled until a usable payment selection exists.
                      onPressed: payment.canCheckout &&
                              !cart.isEmpty &&
                              !_isPlacingOrder
                          ? _placeOrder
                          : null,
                      child: Text("Pay ${formatPrice(cart.total)}"),
                    ),
                    if (!payment.canCheckout)
                      Padding(
                        padding: const EdgeInsets.only(top: defaultPadding / 2),
                        child: Text(
                          payment.selectedCard == null
                              ? "Select or add a card to continue."
                              : "Enter the card's CVV to continue.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: errorColor),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DeliveryAddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      builder: (controller) {
        final address = AddressController.to.defaultAddress;

        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(defaultBorderRadious)),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/Location.svg",
                height: 24,
                width: 24,
                colorFilter:
                    const ColorFilter.mode(primaryColor, BlendMode.srcIn),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deliver to",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    Text(
                      address == null
                          ? "No address selected"
                          : "${address.label} · ${address.formattedAddress}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, addressesScreenRoute),
                child: const Text("Change"),
              ),
            ],
          ),
        );
      },
    );
  }
}
