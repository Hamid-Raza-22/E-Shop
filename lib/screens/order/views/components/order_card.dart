import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/network_image_with_loader.dart';
import '../../../../constants.dart';
import '../../../../models/order_model.dart';
import '../../../../utils/formatters.dart';

/// Compact order row used by both the active and history tabs.
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.press,
  });

  final OrderModel order;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.first;

    return InkWell(
      onTap: press,
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultBorderRadious)),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 64,
              width: 64,
              child: NetworkImageWithLoader(
                firstItem.product.image,
                radius: defaultBorderRadious,
              ),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "#${order.id}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: defaultPadding / 4),
                      OrderStatusTag(status: order.status),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Text(
                    order.items.length == 1
                        ? firstItem.product.title
                        : "${firstItem.product.title} + ${order.items.length - 1} more",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          formatDate(order.placedOn),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      Flexible(
                        child: Text(
                          formatPrice(order.total),
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
            SvgPicture.asset(
              "assets/icons/miniRight.svg",
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).dividerColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small coloured pill showing the order status.
class OrderStatusTag extends StatelessWidget {
  const OrderStatusTag({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      OrderStatus.processing => ("Processing", warningColor),
      OrderStatus.delivered => ("Delivered", successColor),
      OrderStatus.canceled => ("Canceled", errorColor),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
