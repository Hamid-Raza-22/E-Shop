import 'package:flutter/material.dart';

import '../../../components/empty_state_view.dart';
import '../../../repositories/order_repository.dart';
import 'components/order_details_sheet.dart';

/// Full-screen order details (same content as the bottom sheet variant).
class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final repository = OrderRepository.instance;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: repository,
          builder: (context, _) {
            final order = repository.findById(orderId);

            if (order == null) {
              return EmptyStateView(
                title: "Order not found",
                description:
                    "We could not find order #$orderId. It may have been removed.",
                actionLabel: "Go back",
                onAction: () => Navigator.pop(context),
              );
            }

            return OrderDetailsSheet(
              order: order,
              onCancel: (reason) =>
                  repository.cancelOrder(order.id, reason: reason),
            );
          },
        ),
      ),
    );
  }
}
