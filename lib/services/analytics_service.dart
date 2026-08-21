import '../models/customer_model.dart';
import '../models/dashboard_metrics.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import 'customer_service.dart';
import 'order_service.dart';
import 'product_service.dart';

/// Builds the dashboard's [DashboardMetrics] from the raw collections.
///
/// Everything is aggregated in Dart rather than with Firestore aggregation
/// queries: the catalog and order volume of this app is small, and one pass over
/// the fetched lists keeps the whole computation unit testable with fakes.
class AnalyticsService {
  AnalyticsService({
    OrderService? orderService,
    CustomerService? customerService,
    ProductService? productService,
  })  : _orderService = orderService ?? OrderService(),
        _customerService = customerService ?? CustomerService(),
        _productService = productService ?? ProductService();

  final OrderService _orderService;
  final CustomerService _customerService;
  final ProductService _productService;

  /// Loads every metric. [days] controls the length of the sales series.
  Future<DashboardMetrics> load({int days = 7}) async {
    final results = await Future.wait([
      _orderService.fetchAll(),
      _productService.fetchAll(),
      _customerService.fetchAll(),
    ]);

    final orders = results[0] as List<OrderModel>;
    final products = results[1] as List<ProductModel>;
    final customers = results[2] as List<CustomerModel>;

    final now = DateTime.now();
    final startOfToday = _startOfDay(now);
    final startOfWeek = startOfToday.subtract(const Duration(days: 6));

    // Canceled and returned orders never count towards revenue, but they do
    // still count in the status breakdown.
    final revenueOrders = orders.where(_countsAsRevenue).toList();

    double revenueTotal = 0;
    double revenueToday = 0;
    int ordersToday = 0;

    for (final order in revenueOrders) {
      revenueTotal += order.total;
      if (!order.placedOn.isBefore(startOfToday)) {
        revenueToday += order.total;
        ordersToday += 1;
      }
    }

    return DashboardMetrics(
      revenueToday: revenueToday,
      revenueTotal: revenueTotal,
      ordersToday: ordersToday,
      ordersTotal: orders.length,
      averageOrderValue:
          revenueOrders.isEmpty ? 0 : revenueTotal / revenueOrders.length,
      newCustomersThisWeek: customers
          .where((customer) =>
              customer.createdAt != null &&
              !customer.createdAt!.isBefore(startOfWeek))
          .length,
      lowStockCount: products.where((product) => product.isLowStock).length,
      ordersByStatus: _ordersByStatus(orders),
      salesSeries: _salesSeries(revenueOrders, days: days, now: now),
      topProducts: _topProducts(revenueOrders),
    );
  }

  /// Only fulfilled or in-flight orders represent money earned.
  bool _countsAsRevenue(OrderModel order) =>
      order.status != OrderStatus.canceled &&
      order.status != OrderStatus.returned;

  /// Every status is present so the UI can render a stable set of chips.
  Map<OrderStatus, int> _ordersByStatus(List<OrderModel> orders) {
    final counts = <OrderStatus, int>{
      for (final status in OrderStatus.values) status: 0,
    };
    for (final order in orders) {
      counts[order.status] = (counts[order.status] ?? 0) + 1;
    }
    return counts;
  }

  /// One bucket per day for the last [days] days including today, oldest first
  /// and zero-filled so the chart never shows gaps.
  List<DailySales> _salesSeries(
    List<OrderModel> orders, {
    required int days,
    required DateTime now,
  }) {
    final span = days < 1 ? 1 : days;
    final startOfToday = _startOfDay(now);
    final firstDay = startOfToday.subtract(Duration(days: span - 1));

    final revenueByDay = <DateTime, double>{};
    final countByDay = <DateTime, int>{};

    for (final order in orders) {
      final day = _startOfDay(order.placedOn);
      if (day.isBefore(firstDay) || day.isAfter(startOfToday)) continue;
      revenueByDay[day] = (revenueByDay[day] ?? 0) + order.total;
      countByDay[day] = (countByDay[day] ?? 0) + 1;
    }

    return List<DailySales>.generate(span, (index) {
      final day = firstDay.add(Duration(days: index));
      return DailySales(
        day: day,
        revenue: revenueByDay[day] ?? 0,
        orders: countByDay[day] ?? 0,
      );
    });
  }

  /// Top five products by revenue, aggregated from the denormalised order items
  /// so deleted catalog products still appear in history.
  List<TopProduct> _topProducts(List<OrderModel> orders) {
    final units = <String, int>{};
    final revenue = <String, double>{};
    final titles = <String, String>{};
    final productIds = <String, String?>{};

    for (final order in orders) {
      for (final item in order.items) {
        // Items saved before product ids existed are grouped by title instead.
        final key = item.product.id ?? "title:${item.product.title}";
        units[key] = (units[key] ?? 0) + item.quantity;
        revenue[key] = (revenue[key] ?? 0) + item.totalPrice;
        titles[key] = item.product.title;
        productIds[key] = item.product.id;
      }
    }

    final entries = units.keys
        .map((key) => TopProduct(
              productId: productIds[key],
              title: titles[key] ?? "",
              unitsSold: units[key] ?? 0,
              revenue: revenue[key] ?? 0,
            ))
        .toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    return entries.take(5).toList();
  }

  static DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
