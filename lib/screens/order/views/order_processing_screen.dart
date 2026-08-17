import 'package:flutter/material.dart';

import '../../../components/empty_state_view.dart';
import '../../../components/order_process.dart';
import '../../../components/order_status_card.dart';
import '../../../constants.dart';
import '../../../models/order_model.dart';
import '../../../repositories/order_repository.dart';
import '../../../route/route_constants.dart';
import '../../../utils/formatters.dart';
import 'cancel_order_screen.dart';

/// Live tracking view for a single in-progress order, built on the existing
/// [OrderStatusCard] / [OrderProgress] components.
class OrderProcessingScreen extends StatelessWidget {
  const OrderProcessingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final repository = OrderRepository.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Track order")),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: repository,
          builder: (context, _) {
            final order = repository.findById(orderId);

            if (order == null) {
              return EmptyStateView(
                title: "Order not found",
                description: "We could not find order #$orderId.",
                actionLabel: "All orders",
                onAction: () =>
                    Navigator.pushNamed(context, ordersScreenRoute),
              );
            }

            final isCanceled = order.status == OrderStatus.canceled;
            final isDelivered = order.status == OrderStatus.delivered;

            return ListView(
              padding: const EdgeInsets.all(defaultPadding),
              children: [
                OrderStatusCard(
                  orderId: order.id,
                  placedOn: formatDate(order.placedOn),
                  orderStatus: OrderProcessStatus.done,
                  processingStatus: isCanceled || isDelivered
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
                  isCancled: isCanceled,
                  products: order.items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: defaultPadding / 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${item.quantity} x ${item.product.title}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(width: defaultPadding / 2),
                              Text(
                                formatPrice(item.totalPrice),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: defaultPadding * 1.5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Order total",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      formatPrice(order.total),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                if (order.isActive) ...[
                  const SizedBox(height: defaultPadding * 1.5),
                  OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CancelOrderScreen(orderId: order.id),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: errorColor,
                      side: const BorderSide(color: errorColor),
                    ),
                    child: const Text("Cancel order"),
                  ),
                ],
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
              ],
            );
          },
        ),
      ),
    );
  }
}
