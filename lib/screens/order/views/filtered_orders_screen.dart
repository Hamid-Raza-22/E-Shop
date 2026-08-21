import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/empty_state_view.dart';
import '../../../constants.dart';
import '../../../models/order_model.dart';
import '../../../controllers/order_controller.dart';
import '../../../route/route_constants.dart';
import 'components/order_card.dart';
import 'components/order_details_sheet.dart';

/// Single-status order list, used by the processing / delivered / canceled
/// routes so each status has its own screen without duplicating the UI.
class FilteredOrdersScreen extends StatelessWidget {
  const FilteredOrdersScreen({super.key, required this.status});

  final OrderStatus status;

  String get _title => switch (status) {
        OrderStatus.pending => "Pending orders",
        OrderStatus.processing => "Processing orders",
        OrderStatus.shipped => "Shipped orders",
        OrderStatus.delivered => "Delivered orders",
        OrderStatus.canceled => "Canceled orders",
        OrderStatus.returned => "Returned orders",
      };

  String get _emptyDescription => switch (status) {
        OrderStatus.pending => "You have no orders waiting to be confirmed.",
        OrderStatus.processing =>
          "You have no orders being processed right now.",
        OrderStatus.shipped => "None of your orders are on their way yet.",
        OrderStatus.delivered =>
          "None of your orders have been delivered yet.",
        OrderStatus.canceled => "You have not canceled any orders.",
        OrderStatus.returned => "You have not returned any orders.",
      };

  Future<void> _openDetails(BuildContext context, OrderModel order) async {
    await customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.85,
      child: OrderDetailsSheet(
        order: order,
        onCancel: (reason) =>
            OrderController.to.cancelOrder(order.id, reason: reason),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = OrderController.to;

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: GetBuilder<OrderController>(
          builder: (controller) {
            final orders = repository.orders
                .where((order) => order.status == status)
                .toList();

            if (orders.isEmpty) {
              return EmptyStateView(
                title: "Nothing here",
                description: _emptyDescription,
                actionLabel: "All orders",
                onAction: () =>
                    Navigator.pushNamed(context, ordersScreenRoute),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(defaultPadding),
              itemCount: orders.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: defaultPadding),
              itemBuilder: (context, index) => OrderCard(
                order: orders[index],
                press: () => _openDetails(context, orders[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
