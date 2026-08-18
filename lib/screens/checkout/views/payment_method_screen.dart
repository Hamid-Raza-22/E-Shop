import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/card_info.dart';
import '../../../components/check_mark.dart';
import '../../../constants.dart';
import '../../../models/payment_card_model.dart';
import '../../../repositories/address_repository.dart';
import '../../../repositories/cart_repository.dart';
import '../../../repositories/order_repository.dart';
import '../../../repositories/payment_repository.dart';
import '../../../repositories/wallet_repository.dart';
import '../../../route/route_constants.dart';
import '../../../utils/formatters.dart';
import 'add_new_card_screen.dart';

/// Checkout step 2: choose how to pay, then place the order.
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  void _placeOrder(BuildContext context) {
    final cart = CartRepository.instance;
    if (cart.isEmpty) return;

    final payment = PaymentRepository.instance;

    // Wallet payments must actually cover the total.
    if (payment.selectedOption == PaymentOption.wallet) {
      final paid = WalletRepository.instance.spend(
        cart.total,
        products: cart.items.map((item) => item.product).toList(),
      );
      if (!paid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Wallet balance is too low (${formatPrice(WalletRepository.instance.balance)}). Top up or choose another method.",
            ),
          ),
        );
        return;
      }
    }

    final order =
        OrderRepository.instance.createFromCart(cart.items, cart.total);
    cart.clear();

    Navigator.pushNamedAndRemoveUntil(
      context,
      thanksForOrderScreenRoute,
      (route) => route.isFirst,
      arguments: order.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final payment = PaymentRepository.instance;
    final cart = CartRepository.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge(
              [payment, cart, WalletRepository.instance]),
          builder: (context, _) {
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
                                "Balance ${formatPrice(WalletRepository.instance.balance)}",
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
                  onPressed: payment.canCheckout && !cart.isEmpty
                      ? () => _placeOrder(context)
                      : null,
                  child: Text("Pay ${formatPrice(cart.total)}"),
                ),
                if (!payment.canCheckout)
                  Padding(
                    padding: const EdgeInsets.only(top: defaultPadding / 2),
                    child: Text(
                      "Select or add a card to continue.",
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
    );
  }
}

class _DeliveryAddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AddressRepository.instance,
      builder: (context, _) {
        final address = AddressRepository.instance.defaultAddress;

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
