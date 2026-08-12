import 'product_model.dart';

enum OrderStatus { processing, delivered, canceled }

/// Snapshot of a product at the time the order was placed.
///
/// Prices are copied instead of referenced so later product/price changes never
/// rewrite order history.
class OrderItem {
  OrderItem({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  final ProductModel product;
  final int quantity;
  final double unitPrice;

  double get totalPrice => unitPrice * quantity;
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.placedOn,
    required this.items,
    required this.total,
    this.status = OrderStatus.processing,
    this.cancelReason,
  });

  final String id;
  final DateTime placedOn;
  final List<OrderItem> items;
  final double total;
  final OrderStatus status;
  final String? cancelReason;

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  bool get isActive => status == OrderStatus.processing;

  OrderModel copyWith({OrderStatus? status, String? cancelReason}) {
    return OrderModel(
      id: id,
      placedOn: placedOn,
      items: items,
      total: total,
      status: status ?? this.status,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }
}
