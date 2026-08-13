import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/network_image_with_loader.dart';
import '../../../../constants.dart';
import '../../../../models/cart_item_model.dart';
import '../../../../utils/formatters.dart';

/// Single cart line: image, brand, title, price and the quantity stepper.
class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.press,
  });

  final CartItem item;
  final VoidCallback onIncrement, onDecrement, onRemove, press;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final hasDiscount = product.priceAfetDiscount != null;

    return InkWell(
      onTap: press,
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
              width: 76,
              child: NetworkImageWithLoader(
                product.image,
                radius: defaultBorderRadious,
              ),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brandName.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Row(
                    children: [
                      Text(
                        formatPrice(item.unitPrice),
                        style: const TextStyle(
                          color: Color(0xFF31B0D8),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: defaultPadding / 4),
                        Text(
                          formatPrice(product.price),
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    children: [
                      _QuantityButton(
                        svgSrc: "assets/icons/Minus.svg",
                        // Minimum quantity is 1; removal is an explicit action.
                        onPressed: item.quantity > 1 ? onDecrement : null,
                      ),
                      SizedBox(
                        width: 36,
                        child: Center(
                          child: Text(
                            item.quantity.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      _QuantityButton(
                        svgSrc: "assets/icons/Plus1.svg",
                        onPressed: onIncrement,
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      // Flexible so a long line total cannot overflow on
                      // narrow screens.
                      Expanded(
                        child: Text(
                          formatPrice(item.totalPrice),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              visualDensity: VisualDensity.compact,
              tooltip: "Remove from cart",
              icon: SvgPicture.asset(
                "assets/icons/Close.svg",
                height: 16,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyMedium!.color!,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.svgSrc, this.onPressed});

  final String svgSrc;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return SizedBox(
      height: 32,
      width: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(defaultPadding / 4),
        ),
        child: SvgPicture.asset(
          svgSrc,
          height: 12,
          colorFilter: ColorFilter.mode(
            isEnabled
                ? Theme.of(context).iconTheme.color!
                : Theme.of(context).disabledColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
