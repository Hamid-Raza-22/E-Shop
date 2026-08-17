import 'package:flutter/material.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/empty_state_view.dart';
import '../../../constants.dart';
import '../../../models/order_model.dart';
import '../../../repositories/order_repository.dart';
import '../../../route/route_constants.dart';
import 'components/order_card.dart';
import 'components/order_details_sheet.dart';

/// Single-status order list, used by the processing / delivered / canceled
/// routes so each status has its own screen without duplicating the UI.
class FilteredOrdersScreen extends StatelessWidget {
  const FilteredOrdersScreen({super.key, required this.status});

  final OrderStatus status;

  String get _title {
    switch (status) {
      case OrderStatus.processing:
        return "Processing orders";
      case OrderStatus.delivered:
        return "Delivered orders";
      case OrderStatus.canceled:
        return "Canceled orders";
    }
  }

  String get _emptyDescription {
    switch (status) {
      case OrderStatus.processing:
        return "You have no orders being processed right now.";
      case OrderStatus.delivered:
        return "None of your orders have been delivered yet.";
      case OrderStatus.canceled:
        return "You have not canceled any orders.";
    }
  }

  Future<void> _openDetails(BuildContext context, OrderModel order) async {
    await customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.85,
      child: OrderDetailsSheet(
        order: order,
        onCancel: (reason) =>
            OrderRepository.instance.cancelOrder(order.id, reason: reason),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = OrderRepository.instance;

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: repository,
          builder: (context, _) {
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
