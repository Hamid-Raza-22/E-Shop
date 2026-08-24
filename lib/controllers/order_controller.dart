import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/customer_service.dart';
import '../services/order_service.dart';
import '../utils/service_locator.dart';
import 'address_controller.dart';
import 'user_controller.dart';

/// Order store for the storefront.
///
/// Once a customer is signed in the list is a live Firestore stream, so a status
/// change made in the dashboard shows up here without a refresh. Without a
/// signed-in customer (or without Firebase at all, as in tests) it falls back to
/// the bundled demo orders so the order screens stay usable.
class OrderController extends GetxController {
  OrderController({OrderService? orderService, CustomerService? customerService})
      : _injectedOrders = orderService,
        _injectedCustomers = customerService {
    _seedDemoOrders();
  }

  static OrderController get to => Get.find<OrderController>();

  final OrderService? _injectedOrders;
  final CustomerService? _injectedCustomers;

  OrderService? get _orderService =>
      _injectedOrders ?? serviceOrNull<OrderService>();

  CustomerService? get _customerService =>
      _injectedCustomers ?? serviceOrNull<CustomerService>();

  final List<OrderModel> _orders = [];
  StreamSubscription<List<OrderModel>>? _subscription;
  String? _customerId;
  int _sequence = 0;

  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> get activeOrders =>
      _orders.where((order) => order.isActive).toList();

  List<OrderModel> get historyOrders =>
      _orders.where((order) => !order.isActive).toList();

  /// True while the list mirrors Firestore instead of the local demo data.
  bool get isLive => _subscription != null;

  int countByStatus(OrderStatus status) =>
      _orders.where((order) => order.status == status).length;

  OrderModel? findById(String id) =>
      _orders.where((order) => order.id == id).firstOrNull;

  /// Points the list at [customerId]'s Firestore orders, or back at the local
  /// demo orders when the customer signs out.
  void bindCustomer(String? customerId) {
    if (_customerId == customerId) return;
    _customerId = customerId;
    _subscription?.cancel();
    _subscription = null;

    final service = _orderService;
    if (customerId == null || service == null) {
      _orders.clear();
      _seedDemoOrders();
      update();
      return;
    }

    _orders.clear();
    update();
    _subscription = service.watchForCustomer(customerId).listen((orders) {
      _orders
        ..clear()
        ..addAll(orders);
      update();
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// Places [cartItems] as a new order.
  ///
  /// Returns the order on success and `null` when the Firestore write failed —
  /// the caller must not clear the cart in that case. When no Firestore service
  /// is available the order is kept locally so the demo flow still works.
  Future<OrderModel?> createFromCart(
    List<CartItem> cartItems,
    double total,
  ) async {
    final order = OrderModel(
      id: _newOrderId(),
      placedOn: DateTime.now(),
      total: total,
      status: OrderStatus.pending,
      customerId: _customerId,
      customerName: UserController.to.user.name,
      customerEmail: UserController.to.user.email,
      shippingAddress: AddressController.to.defaultAddress?.formattedAddress,
      items: cartItems
          .map((item) => OrderItem(
                product: item.product,
                quantity: item.quantity,
                unitPrice: item.unitPrice,
              ))
          .toList(),
    );

    final service = _orderService;
    if (service == null) {
      _orders.insert(0, order);
      update();
      return order;
    }

    try {
      await service.create(order);
    } catch (_) {
      return null;
    }

    // The customer directory the dashboard shows is a by-product of checkout.
    final customerId = _customerId;
    if (customerId != null) {
      // A failed counter update must not fail an order that is already placed.
      try {
        await _customerService?.upsertFromOrder(
          customerId: customerId,
          name: order.customerName ?? "",
          email: order.customerEmail ?? "",
          orderTotal: total,
        );
      } catch (_) {
        // Ignored on purpose: the order itself is safely stored.
      }
    }

    // A live list is refreshed by the stream; a local list needs the insert.
    if (!isLive) {
      _orders.insert(0, order);
      update();
    }
    return order;
  }

  Future<void> cancelOrder(String id, {String? reason}) async {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index == -1 || !_orders[index].isActive) return;

    final service = _orderService;
    if (isLive && service != null) {
      await service.updateStatus(id, OrderStatus.canceled,
          cancelReason: reason);
      return;
    }

    _orders[index] = _orders[index]
        .copyWith(status: OrderStatus.canceled, cancelReason: reason);
    update();
  }

  Future<void> markDelivered(String id) async {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index == -1 || !_orders[index].isActive) return;

    final service = _orderService;
    if (isLive && service != null) {
      await service.updateStatus(id, OrderStatus.delivered);
      return;
    }

    _orders[index] = _orders[index].copyWith(status: OrderStatus.delivered);
    update();
  }

  /// Human-readable but globally unique, so it can double as the Firestore
  /// document id without two devices ever colliding on a counter.
  String _newOrderId() {
    final stamp =
        DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase();
    final noise = Random().nextInt(1296).toRadixString(36).padLeft(2, "0");
    return "FDS$stamp${noise.toUpperCase()}";
  }

  String _nextDemoOrderId() {
    _sequence++;
    return "FDS${(639420 + _sequence)}";
  }

  void _seedDemoOrders() {
    _sequence = 0;
    final now = DateTime.now();
    _orders.addAll([
      OrderModel(
        id: _nextDemoOrderId(),
        placedOn: now.subtract(const Duration(days: 2)),
        total: 420.0,
        items: [
          OrderItem(
            product: demoPopularProducts[0],
            quantity: 1,
            unitPrice: demoPopularProducts[0].priceAfetDiscount ??
                demoPopularProducts[0].price,
          ),
        ],
      ),
      OrderModel(
        id: _nextDemoOrderId(),
        placedOn: now.subtract(const Duration(days: 12)),
        total: 800.0,
        status: OrderStatus.delivered,
        items: [
          OrderItem(
            product: demoPopularProducts[1],
            quantity: 1,
            unitPrice: demoPopularProducts[1].price,
          ),
        ],
      ),
      OrderModel(
        id: _nextDemoOrderId(),
        placedOn: now.subtract(const Duration(days: 26)),
        total: 390.36,
        status: OrderStatus.canceled,
        cancelReason: "Ordered by mistake",
        items: [
          OrderItem(
            product: demoBestSellersProducts[0],
            quantity: 1,
            unitPrice: demoBestSellersProducts[0].priceAfetDiscount ??
                demoBestSellersProducts[0].price,
          ),
        ],
      ),
    ]);
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
