import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import '../../../../models/address_model.dart';

enum AddressAction { setDefault, edit, delete }

/// Address card from the Address design: label + details + "Default" marker.
class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    required this.onAction,
    required this.press,
  });

  final AddressModel address;
  final ValueChanged<AddressAction> onAction;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final isDefault = address.isDefault;

    return InkWell(
      onTap: press,
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultBorderRadious)),
          border: Border.all(
            color: isDefault ? primaryColor : Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isDefault
                      ? primaryColor
                      : Theme.of(context).dividerColor,
                  child: SvgPicture.asset(
                    "assets/icons/Address.svg",
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: defaultPadding / 2),
                Expanded(
                  child: Text(
                    address.label,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: isDefault ? primaryColor : null,
                        ),
                  ),
                ),
                if (isDefault)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                    height: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(defaultBorderRadious)),
                    ),
                    child: const Text(
                      "Default",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                PopupMenuButton<AddressAction>(
                  onSelected: onAction,
                  tooltip: "Address options",
                  itemBuilder: (context) => [
                    if (!isDefault)
                      const PopupMenuItem(
                        value: AddressAction.setDefault,
                        child: Text("Set as default"),
                      ),
                    const PopupMenuItem(
                      value: AddressAction.edit,
                      child: Text("Edit"),
                    ),
                    const PopupMenuItem(
                      value: AddressAction.delete,
                      child: Text("Delete"),
                    ),
                  ],
                  icon: SvgPicture.asset(
                    "assets/icons/DotsV.svg",
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyMedium!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              address.fullName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: defaultPadding / 4),
            Text(
              address.formattedAddress,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: defaultPadding / 4),
            Text(
              address.phone,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
