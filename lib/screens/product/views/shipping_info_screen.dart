import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/address_controller.dart';
import 'components/expandable_info_section.dart';

/// "Shipping Information" bottom sheet content.
class ShippingInfoScreen extends StatelessWidget {
  const ShippingInfoScreen({super.key});

  static const List<(String, String, String, String)> _shippingMethods = [
    (
      "assets/icons/Delivery.svg",
      "Standard delivery",
      "3 – 5 working days",
      "Free"
    ),
    (
      "assets/icons/Trackorder.svg",
      "Express delivery",
      "1 – 2 working days",
      "\$9.99"
    ),
    (
      "assets/icons/Stores.svg",
      "Collect in store",
      "Ready in 24 hours",
      "Free"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Shipping Information"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              // Shows the real default address from the shared repository.
              GetBuilder<AddressController>(
                builder: (controller) {
                  final address = AddressController.to.defaultAddress;
                  return Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadious)),
                      border:
                          Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Location.svg",
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                              primaryColor, BlendMode.srcIn),
                        ),
                        const SizedBox(width: defaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivering to",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: defaultPadding / 4),
                              Text(
                                address == null
                                    ? "No default address saved"
                                    : "${address.label} · ${address.formattedAddress}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: defaultPadding * 1.5),
              Text(
                "Shipping methods",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: defaultPadding / 2),
              ..._shippingMethods.map(
                (method) => Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 24,
                      leading: SvgPicture.asset(
                        method.$1,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).textTheme.bodyLarge!.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                      title: Text(
                        method.$2,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      subtitle: Text(method.$3),
                      trailing: Text(
                        method.$4,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                              color: method.$4 == "Free" ? successColor : null,
                            ),
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding * 1.5),
              const ExpandableInfoSection(
                title: "Delivery information",
                isInitiallyExpanded: true,
                body:
                    "Orders placed before 2 PM are dispatched the same working day. You will receive a tracking link by email as soon as your parcel leaves our warehouse.",
              ),
              const ExpandableInfoSection(
                title: "Returns & refunds",
                body:
                    "You have 30 days from the delivery date to return your order. Items must be unworn with the original tags attached. Refunds are issued to the original payment method within 5 working days of the return arriving.",
              ),
              const ExpandableInfoSection(
                title: "International shipping",
                body:
                    "We ship to over 40 countries. Duties and taxes for orders outside the EU are calculated at checkout and may vary by destination.",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
