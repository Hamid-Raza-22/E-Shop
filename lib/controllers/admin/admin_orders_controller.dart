import 'package:get/get.dart';

import '../../models/order_model.dart';
import '../../services/customer_service.dart';
import '../../services/order_service.dart';

/// Order management: live list, status filter, search and status transitions.
class AdminOrdersController extends GetxController {
  AdminOrdersController({
    OrderService? orderService,
    CustomerService? customerService,
  })  : _orders = orderService ?? Get.find<OrderService>(),
        _customers = customerService ?? Get.find<CustomerService>();

  final OrderService _orders;
  final CustomerService _customers;

  static AdminOrdersController get to => Get.find<AdminOrdersController>();

  final RxList<OrderModel> _all = <OrderModel>[].obs;
  final Rxn<OrderStatus> _statusFilter = Rxn<OrderStatus>();
  final RxString _query = "".obs;
  final RxBool _isUpdating = false.obs;
  final RxnString _error = RxnString();

  OrderStatus? get statusFilter => _statusFilter.value;

  String get query => _query.value;

  bool get isUpdating => _isUpdating.value;

  String? get error => _error.value;

  int get openCount => _all.where((order) => order.status.isOpen).length;

  Map<OrderStatus, int> get countsByStatus {
    final counts = {for (final status in OrderStatus.values) status: 0};
    for (final order in _all) {
      counts[order.status] = (counts[order.status] ?? 0) + 1;
    }
    return counts;
  }

  List<OrderModel> get orders {
    final term = _query.value.trim().toLowerCase();
    final status = _statusFilter.value;

    return _all.where((order) {
      if (status != null && order.status != status) return false;
      if (term.isEmpty) return true;

      return order.id.toLowerCase().contains(term) ||
          (order.customerName?.toLowerCase().contains(term) ?? false) ||
          (order.customerEmail?.toLowerCase().contains(term) ?? false);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _all.bindStream(_orders.watchAll());
  }

  void search(String value) => _query.value = value;

  void setStatusFilter(OrderStatus? status) => _statusFilter.value = status;

  /// Applies a status change, refusing transitions the lifecycle disallows so
  /// the dashboard cannot, say, ship an order that was already canceled.
  Future<bool> updateStatus(
    OrderModel order,
    OrderStatus status, {
    String? cancelReason,
  }) async {
    if (order.status == status) return false;
    if (!order.status.allowedTransitions.contains(status)) {
      _error.value =
          "An order that is ${order.status.name} cannot become ${status.name}.";
      return false;
    }

    _isUpdating.value = true;
    _error.value = null;
    try {
      await _orders.updateStatus(order.id, status, cancelReason: cancelReason);

      // A canceled/returned order must not keep counting towards the
      // customer's lifetime spend.
      final customerId = order.customerId;
      if (customerId != null &&
          (status == OrderStatus.canceled || status == OrderStatus.returned)) {
        await _customers.reverseOrder(
          customerId: customerId,
          orderTotal: order.total,
        );
      }
      return true;
    } catch (exception) {
      _error.value = exception.toString();
      return false;
    } finally {
      _isUpdating.value = false;
    }
  }

  void clearError() => _error.value = null;
}
