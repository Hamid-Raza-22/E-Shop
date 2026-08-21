import 'package:flutter/material.dart';

import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../models/order_model.dart';

/// Localised, colour-coded label for an [OrderStatus].
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status, this.compact = true});

  final OrderStatus status;
  final bool compact;

  /// Shared so the dropdown, list and chip all agree on colours.
  static Color colorOf(OrderStatus status) => switch (status) {
        OrderStatus.pending => warningColor,
        OrderStatus.processing => warningColor,
        OrderStatus.shipped => primaryColor,
        OrderStatus.delivered => successColor,
        OrderStatus.canceled => errorColor,
        OrderStatus.returned => errorColor,
      };

  static String labelOf(BuildContext context, OrderStatus status) {
    final translations = AppLocalizations.of(context);
    return switch (status) {
      OrderStatus.pending => translations.orderStatusPending,
      OrderStatus.processing => translations.orderStatusProcessing,
      OrderStatus.shipped => translations.orderStatusShipped,
      OrderStatus.delivered => translations.orderStatusDelivered,
      OrderStatus.canceled => translations.orderStatusCanceled,
      OrderStatus.returned => translations.orderStatusReturned,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = colorOf(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? defaultPadding / 2 : defaultPadding,
        vertical: compact ? 2 : defaultPadding / 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        labelOf(context, status),
        style: TextStyle(
          color: color,
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
