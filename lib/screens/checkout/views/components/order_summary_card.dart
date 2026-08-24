import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../utils/formatters.dart';

/// Order summary block from the Cart design: subtotal, shipping, total and VAT.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.vat,
    required this.total,
    required this.isShippingFree,
    this.discount = 0,
  });

  final double subtotal, shippingFee, vat, total;

  /// Coupon discount. The row is hidden while it is zero.
  final double discount;
  final bool isShippingFree;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: defaultPadding),
          _SummaryRow(label: "Subtotal", value: formatPrice(subtotal)),
          const SizedBox(height: defaultPadding / 2),
          if (discount > 0) ...[
            _SummaryRow(
              label: "Discount",
              value: "-${formatPrice(discount)}",
              valueColor: successColor,
            ),
            const SizedBox(height: defaultPadding / 2),
          ],
          _SummaryRow(
            label: "Shipping Fee",
            value: isShippingFree ? "Free" : formatPrice(shippingFee),
            valueColor: isShippingFree ? successColor : null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: "Total (Include of VAT)",
            value: formatPrice(total),
            isEmphasized: true,
          ),
          const SizedBox(height: defaultPadding / 2),
          _SummaryRow(label: "Estimated VAT", value: formatPrice(vat)),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isEmphasized = false,
  });

  final String label, value;
  final Color? valueColor;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: (isEmphasized
                  ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(context).textTheme.titleSmall)!
              .copyWith(color: valueColor),
        ),
      ],
    );
  }
}
