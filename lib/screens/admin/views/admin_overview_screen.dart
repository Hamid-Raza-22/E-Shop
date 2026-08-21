import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/admin/admin_dashboard_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/dashboard_metrics.dart';
import '../../../models/order_model.dart';
import '../../../utils/formatters.dart';
import '../../../utils/responsive.dart';
import 'components/kpi_card.dart';
import 'package:shop/components/order_status_chip.dart';
import 'components/sales_chart.dart';
import 'components/section_card.dart';

/// Business overview: KPIs, the revenue chart, top products and recent orders.
class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminDashboardController.to;

    return Obx(() {
      final metrics = controller.metrics;

      return RefreshIndicator(
        onRefresh: controller.refreshMetrics,
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            if (controller.isLoading) const LinearProgressIndicator(),
            if (controller.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  controller.error!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: errorColor),
                ),
              ),
            _KpiGrid(metrics: metrics),
            const SizedBox(height: defaultPadding),
            SectionCard(
              title: translations.adminSalesLastDays(controller.rangeInDays),
              trailing: _RangeSelector(controller: controller),
              child: SizedBox(
                height: 260,
                child: metrics.salesSeries.isEmpty
                    ? Center(child: Text(translations.adminNoData))
                    : SalesChart(series: metrics.salesSeries),
              ),
            ),
            const SizedBox(height: defaultPadding),
            ResponsiveBuilder(
              mobile: (context) => Column(
                children: [
                  _TopProductsCard(products: metrics.topProducts),
                  const SizedBox(height: defaultPadding),
                  _RecentOrdersCard(orders: controller.recentOrders),
                ],
              ),
              desktop: (context) => IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _TopProductsCard(products: metrics.topProducts),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      flex: 2,
                      child: _RecentOrdersCard(orders: controller.recentOrders),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.metrics});

  final DashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    final cards = [
      KpiCard(
        label: translations.adminKpiRevenueToday,
        value: formatPrice(metrics.revenueToday),
        icon: Icons.today_outlined,
        color: primaryColor,
      ),
      KpiCard(
        label: translations.adminKpiRevenueTotal,
        value: formatPrice(metrics.revenueTotal),
        icon: Icons.payments_outlined,
        color: successColor,
      ),
      KpiCard(
        label: translations.adminKpiOrders,
        value: formatNumber(metrics.ordersTotal),
        icon: Icons.receipt_long_outlined,
        color: warningColor,
        caption: "${formatNumber(metrics.ordersToday)} today",
      ),
      KpiCard(
        label: translations.adminKpiAverageOrderValue,
        value: formatPrice(metrics.averageOrderValue),
        icon: Icons.trending_up,
        color: primaryColor,
      ),
      KpiCard(
        label: translations.adminKpiNewCustomers,
        value: formatNumber(metrics.newCustomersThisWeek),
        icon: Icons.person_add_alt,
        color: successColor,
      ),
      KpiCard(
        label: translations.adminKpiLowStock,
        value: formatNumber(metrics.lowStockCount),
        icon: Icons.warning_amber_outlined,
        color: metrics.lowStockCount > 0 ? errorColor : successColor,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: Responsive.value(context, mobile: 2, tablet: 3, desktop: 6),
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: Responsive.value(context, mobile: 1.15, tablet: 1.3),
      children: cards,
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({required this.controller});

  final AdminDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SegmentedButton<int>(
        showSelectedIcon: false,
        segments: AdminDashboardController.rangeOptions
            .map(
              (days) => ButtonSegment<int>(
                value: days,
                label: Text("${days}d"),
              ),
            )
            .toList(),
        selected: {controller.rangeInDays},
        onSelectionChanged: (selection) =>
            controller.setRange(selection.first),
      ),
    );
  }
}

class _TopProductsCard extends StatelessWidget {
  const _TopProductsCard({required this.products});

  final List<TopProduct> products;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return SectionCard(
      title: translations.adminTopProducts,
      child: products.isEmpty
          ? Text(translations.adminNoData)
          : Column(
              children: [
                for (final product in products)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      child: Text(
                        formatNumber(product.unitsSold),
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      formatPrice(product.revenue),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _RecentOrdersCard extends StatelessWidget {
  const _RecentOrdersCard({required this.orders});

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return SectionCard(
      title: translations.adminRecentOrders,
      child: orders.isEmpty
          ? Text(translations.adminNoData)
          : Column(
              children: [
                for (final order in orders)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      order.customerName?.isNotEmpty == true
                          ? order.customerName!
                          : translations.adminOrderNumber(order.id),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(formatDateTime(order.placedOn)),
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
                  ),
              ],
            ),
    );
  }
}
