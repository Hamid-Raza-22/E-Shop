import 'package:get/get.dart';

import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

/// In-memory order store shared between checkout and the Orders screen.
class OrderController extends GetxController {
  OrderController() {
    _seedDemoOrders();
  }

  static OrderController get to => Get.find<OrderController>();

  final List<OrderModel> _orders = [];
  int _sequence = 0;

  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> get activeOrders =>
      _orders.where((order) => order.isActive).toList();

  List<OrderModel> get historyOrders =>
      _orders.where((order) => !order.isActive).toList();

  int countByStatus(OrderStatus status) =>
      _orders.where((order) => order.status == status).length;

  OrderModel? findById(String id) =>
      _orders.where((order) => order.id == id).firstOrNull;

  /// Creates an order from the current cart contents. Returns the new order so
  /// the caller can navigate straight to it.
  OrderModel createFromCart(List<CartItem> cartItems, double total) {
    final order = OrderModel(
      id: _nextOrderId(),
      placedOn: DateTime.now(),
      total: total,
      items: cartItems
          .map((item) => OrderItem(
                product: item.product,
                quantity: item.quantity,
                unitPrice: item.unitPrice,
              ))
          .toList(),
    );
    _orders.insert(0, order);
    update();
    return order;
  }

  void cancelOrder(String id, {String? reason}) {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index == -1 || !_orders[index].isActive) return;
    _orders[index] = _orders[index]
        .copyWith(status: OrderStatus.canceled, cancelReason: reason);
    update();
  }

  void markDelivered(String id) {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index == -1 || !_orders[index].isActive) return;
    _orders[index] = _orders[index].copyWith(status: OrderStatus.delivered);
    update();
  }

  String _nextOrderId() {
    _sequence++;
    return "FDS${(639420 + _sequence)}";
  }

  void _seedDemoOrders() {
    final now = DateTime.now();
    _orders.addAll([
      OrderModel(
        id: _nextOrderId(),
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
        id: _nextOrderId(),
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
        id: _nextOrderId(),
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
