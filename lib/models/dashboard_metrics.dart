import 'order_model.dart';

/// Revenue and order count for a single calendar day, used by the sales chart.
class DailySales {
  const DailySales({
    required this.day,
    required this.revenue,
    required this.orders,
  });

  /// Midnight of the day this bucket covers.
  final DateTime day;
  final double revenue;
  final int orders;
}

/// One row of the "best sellers" table, aggregated from order items.
class TopProduct {
  const TopProduct({
    required this.productId,
    required this.title,
    required this.unitsSold,
    required this.revenue,
  });

  /// Null for legacy order items that were stored without a product id.
  final String? productId;
  final String title;
  final int unitsSold;
  final double revenue;
}

/// Everything the dashboard home screen renders, computed in one pass.
///
/// Immutable and free of Firestore types so it can be built in tests from
/// plain models and compared field by field.
class DashboardMetrics {
  const DashboardMetrics({
    required this.revenueToday,
    required this.revenueTotal,
    required this.ordersToday,
    required this.ordersTotal,
    required this.averageOrderValue,
    required this.newCustomersThisWeek,
    required this.lowStockCount,
    required this.ordersByStatus,
    required this.salesSeries,
    required this.topProducts,
  });

  /// Zeroed metrics, shown while the first load is still in flight and after a
  /// failure so the UI never has to deal with a nullable model.
  factory DashboardMetrics.empty() => const DashboardMetrics(
        revenueToday: 0,
        revenueTotal: 0,
        ordersToday: 0,
        ordersTotal: 0,
        averageOrderValue: 0,
        newCustomersThisWeek: 0,
        lowStockCount: 0,
        ordersByStatus: <OrderStatus, int>{},
        salesSeries: <DailySales>[],
        topProducts: <TopProduct>[],
      );

  final double revenueToday, revenueTotal;
  final int ordersToday, ordersTotal;
  final double averageOrderValue;
  final int newCustomersThisWeek;
  final int lowStockCount;

  /// Every [OrderStatus] is present, zero-filled, so callers can index safely.
  final Map<OrderStatus, int> ordersByStatus;

  /// One entry per day, oldest first, zero-filled for days without orders.
  final List<DailySales> salesSeries;
  final List<TopProduct> topProducts;

  int countFor(OrderStatus status) => ordersByStatus[status] ?? 0;

  /// Highest revenue in [salesSeries]; handy for scaling the chart axis.
  double get peakDailyRevenue => salesSeries.isEmpty
      ? 0
      : salesSeries
          .map((entry) => entry.revenue)
          .reduce((a, b) => a > b ? a : b);
}
