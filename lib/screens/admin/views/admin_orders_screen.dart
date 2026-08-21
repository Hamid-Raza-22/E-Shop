import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/admin/admin_orders_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/order_model.dart';
import '../../../utils/formatters.dart';
import 'package:shop/components/order_status_chip.dart';

/// Order management: filter by status, search, inspect items, advance status.
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  Future<void> _changeStatus(
    BuildContext context,
    OrderModel order,
    OrderStatus status,
  ) async {
    final translations = AppLocalizations.of(context);
    String? reason;

    // Cancelling must record why, the same way the customer-facing flow does.
    if (status == OrderStatus.canceled) {
      reason = await _askForReason(context);
      if (reason == null) return;
    }

    final updated = await AdminOrdersController.to
        .updateStatus(order, status, cancelReason: reason);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated
              ? translations.adminOrderStatusUpdated
              : AdminOrdersController.to.error ?? translations.errorGeneric,
        ),
      ),
    );
  }

  Future<String?> _askForReason(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translations.orderStatusCanceled),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Reason"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translations.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              controller.text.trim().isEmpty
                  ? "Canceled by the shop"
                  : controller.text.trim(),
            ),
            child: Text(translations.actionConfirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminOrdersController.to;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              TextField(
                onChanged: controller.search,
                decoration: InputDecoration(
                  hintText: translations.actionSearch,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              Obx(() {
                final counts = controller.countsByStatus;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(right: defaultPadding / 2),
                        child: FilterChip(
                          label: Text(translations.labelAll),
                          selected: controller.statusFilter == null,
                          onSelected: (_) => controller.setStatusFilter(null),
                        ),
                      ),
                      for (final status in OrderStatus.values)
                        Padding(
                          padding:
                              const EdgeInsets.only(right: defaultPadding / 2),
                          child: FilterChip(
                            label: Text(
                              "${OrderStatusChip.labelOf(context, status)}"
                              " (${counts[status] ?? 0})",
                            ),
                            selected: controller.statusFilter == status,
                            onSelected: (_) =>
                                controller.setStatusFilter(status),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final orders = controller.orders;

            if (orders.isEmpty) {
              return Center(child: Text(translations.adminOrderNone));
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                defaultPadding,
                0,
                defaultPadding,
                defaultPadding,
              ),
              itemCount: orders.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: defaultPadding / 2),
              itemBuilder: (context, index) => _OrderTile(
                order: orders[index],
                onStatusSelected: (status) =>
                    _changeStatus(context, orders[index], status),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order, required this.onStatusSelected});

  final OrderModel order;
  final ValueChanged<OrderStatus> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final transitions = order.status.allowedTransitions;

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        title: Text(
          order.customerName?.isNotEmpty == true
              ? order.customerName!
              : translations.adminOrderNumber(order.id),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${formatDateTime(order.placedOn)} · "
          "${translations.cartItemsCount(order.totalQuantity)}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatPrice(order.total),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            OrderStatusChip(status: order.status),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              defaultPadding,
              0,
              defaultPadding,
              defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.customerEmail != null)
                  Text(
                    order.customerEmail!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (order.shippingAddress != null)
                  Text(
                    order.shippingAddress!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (order.cancelReason != null)
                  Padding(
                    padding: const EdgeInsets.only(top: defaultPadding / 4),
                    child: Text(
                      order.cancelReason!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: errorColor),
                    ),
                  ),
                const SizedBox(height: defaultPadding / 2),
                for (final item in order.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${item.quantity} × ${item.product.title}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(formatPrice(item.totalPrice)),
                      ],
                    ),
                  ),
                const Divider(),
                if (transitions.isEmpty)
                  Text(
                    translations.adminOrderStatusUpdated,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  Wrap(
                    spacing: defaultPadding / 2,
                    runSpacing: defaultPadding / 2,
                    children: [
                      Text(
                        "${translations.adminOrderUpdateStatus}:",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      for (final status in transitions)
                        OutlinedButton(
                          onPressed: () => onStatusSelected(status),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 32),
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2,
                            ),
                            foregroundColor: OrderStatusChip.colorOf(status),
                          ),
                          child: Text(
                            OrderStatusChip.labelOf(context, status),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
