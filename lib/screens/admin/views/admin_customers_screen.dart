import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/admin/admin_customers_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/customer_model.dart';
import '../../../utils/formatters.dart';
import '../../../utils/responsive.dart';

/// Customer directory with search, blocking and lifetime-value summary.
class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminCustomersController.to;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: controller.search,
                  decoration: InputDecoration(
                    hintText: translations.actionSearch,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding / 2),
              Obx(
                () => FilterChip(
                  label: Text(translations.adminCustomerBlocked),
                  selected: controller.showBlockedOnly,
                  onSelected: (_) => controller.toggleBlockedOnly(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final customers = controller.customers;

            if (customers.isEmpty) {
              return Center(child: Text(translations.adminCustomerNone));
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                defaultPadding,
                0,
                defaultPadding,
                defaultPadding,
              ),
              itemCount: customers.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: defaultPadding / 2),
              itemBuilder: (context, index) =>
                  _CustomerTile(customer: customers[index]),
            );
          }),
        ),
      ],
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.customer});

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final isWide = !Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(
          color: customer.isBlocked
              ? errorColor.withValues(alpha: 0.4)
              : Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryColor.withValues(alpha: 0.1),
            backgroundImage: customer.photoUrl == null
                ? null
                : NetworkImage(customer.photoUrl!),
            child: customer.photoUrl != null
                ? null
                : Text(
                    customer.name.isEmpty
                        ? "?"
                        : customer.name.characters.first.toUpperCase(),
                    style: const TextStyle(color: primaryColor),
                  ),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        customer.name.isEmpty ? customer.email : customer.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    if (customer.isBlocked) ...[
                      const SizedBox(width: defaultPadding / 2),
                      Text(
                        translations.adminCustomerBlocked,
                        style: const TextStyle(
                          color: errorColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  customer.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (customer.createdAt != null)
                  Text(
                    translations
                        .adminCustomerSince(formatDate(customer.createdAt!)),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          if (isWide) ...[
            _Metric(
              label: translations.adminCustomerOrders,
              value: formatNumber(customer.ordersCount),
            ),
            const SizedBox(width: defaultPadding),
            _Metric(
              label: translations.adminCustomerTotalSpent,
              value: formatPrice(customer.totalSpent),
            ),
            const SizedBox(width: defaultPadding),
          ],
          IconButton(
            tooltip: customer.isBlocked
                ? translations.adminCustomerUnblock
                : translations.adminCustomerBlock,
            onPressed: () =>
                AdminCustomersController.to.toggleBlocked(customer),
            icon: Icon(
              customer.isBlocked ? Icons.lock_open : Icons.block,
              color: customer.isBlocked ? successColor : errorColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
