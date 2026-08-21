import 'package:get/get.dart';

import '../../models/dashboard_metrics.dart';
import '../../models/order_model.dart';
import '../../services/analytics_service.dart';
import '../../services/order_service.dart';

/// Overview screen state: KPIs, sales chart series and the recent-orders feed.
class AdminDashboardController extends GetxController {
  AdminDashboardController({
    AnalyticsService? analyticsService,
    OrderService? orderService,
  })  : _analytics = analyticsService ?? Get.find<AnalyticsService>(),
        _orders = orderService ?? Get.find<OrderService>();

  final AnalyticsService _analytics;
  final OrderService _orders;

  static AdminDashboardController get to => Get.find<AdminDashboardController>();

  /// Ranges the chart offers.
  static const List<int> rangeOptions = [7, 30, 90];

  final Rx<DashboardMetrics> _metrics = DashboardMetrics.empty().obs;
  final RxList<OrderModel> _recentOrders = <OrderModel>[].obs;
  final RxInt _rangeInDays = 7.obs;
  final RxBool _isLoading = true.obs;
  final RxnString _error = RxnString();

  DashboardMetrics get metrics => _metrics.value;

  List<OrderModel> get recentOrders => _recentOrders;

  int get rangeInDays => _rangeInDays.value;

  bool get isLoading => _isLoading.value;

  String? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    _recentOrders.bindStream(_orders.watchRecent());
    refreshMetrics();
  }

  Future<void> setRange(int days) async {
    if (_rangeInDays.value == days) return;
    _rangeInDays.value = days;
    await refreshMetrics();
  }

  /// Metrics are aggregated client-side, so they are pulled on demand rather
  /// than streamed — a Firestore listener per order would be wasteful here.
  Future<void> refreshMetrics() async {
    _isLoading.value = true;
    _error.value = null;
    try {
      _metrics.value = await _analytics.load(days: _rangeInDays.value);
    } catch (exception) {
      _error.value = exception.toString();
    } finally {
      _isLoading.value = false;
    }
  }
}
