import 'package:flutter/material.dart';

import '../../../../components/network_image_with_loader.dart';
import '../../../../components/order_process.dart';
import '../../../../constants.dart';
import '../../../../models/order_model.dart';
import '../../../../utils/formatters.dart';

/// Order details bottom sheet: progress, line items and the cancel action.
///
/// Pops with `true` when the user confirms a cancellation so the caller can
/// refresh/notify.
class OrderDetailsSheet extends StatelessWidget {
  const OrderDetailsSheet({
    super.key,
    required this.order,
    required this.onCancel,
  });

  final OrderModel order;

  /// Called with the selected reason when the user confirms cancellation.
  final ValueChanged<String> onCancel;

  static const List<String> cancelReasons = [
    "Ordered by mistake",
    "Found a better price",
    "Delivery takes too long",
    "Changed my mind",
  ];

  Future<void> _openCancelFlow(BuildContext context) async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorderRadious * 2),
          topRight: Radius.circular(defaultBorderRadious * 2),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "Select a reason",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            ...cancelReasons.map(
              (reason) => Column(
                children: [
                  ListTile(
                    title: Text(reason),
                    onTap: () => Navigator.pop(context, reason),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );

    if (reason == null || !context.mounted) return;
    onCancel(reason);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    // Map the order status onto the existing OrderProgress step statuses.
    final isCanceled = order.status == OrderStatus.canceled;
    final isDelivered = order.status == OrderStatus.delivered;

    return Column(
      children: [
        AppBar(
          title: Text("Order #${order.id}"),
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
              Text(
                "Placed on ${formatDate(order.placedOn)}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: defaultPadding * 1.5),
              OrderProgress(
                orderStatus: OrderProcessStatus.done,
                processingStatus: isCanceled
                    ? OrderProcessStatus.done
                    : isDelivered
                        ? OrderProcessStatus.done
                        : OrderProcessStatus.processing,
                packedStatus: isDelivered
                    ? OrderProcessStatus.done
                    : OrderProcessStatus.notDoneYeat,
                shippedStatus: isDelivered
                    ? OrderProcessStatus.done
                    : OrderProcessStatus.notDoneYeat,
                deliveredStatus: isDelivered
                    ? OrderProcessStatus.done
                    : OrderProcessStatus.notDoneYeat,
                isCanceled: isCanceled,
              ),
              if (isCanceled && order.cancelReason != null)
                Padding(
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: Text(
                    "Canceled: ${order.cancelReason}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: errorColor),
                  ),
                ),
              const Divider(height: defaultPadding * 2),
              Text(
                "Items (${order.totalQuantity})",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: defaultPadding / 2),
              ...order.items.map((item) => _OrderItemRow(item: item)),
              const Divider(height: defaultPadding * 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    formatPrice(order.total),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (order.isActive)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: OutlinedButton(
                onPressed: () => _openCancelFlow(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: errorColor,
                  side: const BorderSide(color: errorColor),
                ),
                child: const Text("Cancel order"),
              ),
            ),
          ),
      ],
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: Row(
        children: [
          SizedBox(
            height: 56,
            width: 56,
            child: NetworkImageWithLoader(
              item.product.image,
              radius: defaultBorderRadious,
            ),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: defaultPadding / 4),
                Text(
                  "${item.quantity} x ${formatPrice(item.unitPrice)}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            formatPrice(item.totalPrice),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
