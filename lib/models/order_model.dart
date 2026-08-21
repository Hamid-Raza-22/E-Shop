import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_model.dart';

/// Lifecycle of an order, in the sequence the dashboard advances it.
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  canceled,
  returned;

  static OrderStatus fromName(String? name) => OrderStatus.values.firstWhere(
        (status) => status.name == name,
        orElse: () => OrderStatus.pending,
      );

  /// Still on its way to the customer.
  bool get isOpen => this == pending || this == processing || this == shipped;

  /// Statuses an order in this state may legally move to.
  List<OrderStatus> get allowedTransitions => switch (this) {
        pending => const [processing, canceled],
        processing => const [shipped, canceled],
        shipped => const [delivered, returned],
        delivered => const [returned],
        canceled => const [],
        returned => const [],
      };
}

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

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: ProductModel.fromMap(
        (map["product"] as Map<String, dynamic>?) ?? const {},
        id: map["productId"] as String?,
      ),
      quantity: (map["quantity"] as num?)?.toInt() ?? 1,
      unitPrice: (map["unitPrice"] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "productId": product.id,
      // Denormalised on purpose: order history must not change when the
      // catalog document is edited or deleted.
      "product": product.toMap(),
      "quantity": quantity,
      "unitPrice": unitPrice,
    };
  }
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.placedOn,
    required this.items,
    required this.total,
    this.status = OrderStatus.processing,
    this.cancelReason,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.shippingAddress,
    this.paymentMethod,
    this.updatedAt,
  });

  final String id;
  final DateTime placedOn;
  final List<OrderItem> items;
  final double total;
  final OrderStatus status;
  final String? cancelReason;
  final String? customerId, customerName, customerEmail;
  final String? shippingAddress, paymentMethod;
  final DateTime? updatedAt;

  int get totalQuantity =>
      items.fold(0, (quantity, item) => quantity + item.quantity);

  bool get isActive => status.isOpen;

  OrderModel copyWith({
    OrderStatus? status,
    String? cancelReason,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id,
      placedOn: placedOn,
      items: items,
      total: total,
      status: status ?? this.status,
      cancelReason: cancelReason ?? this.cancelReason,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return OrderModel(
      id: id,
      placedOn: _toDate(map["placedOn"]) ?? DateTime.now(),
      items: ((map["items"] as List<dynamic>?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(OrderItem.fromMap)
          .toList(),
      total: (map["total"] as num?)?.toDouble() ?? 0,
      status: OrderStatus.fromName(map["status"] as String?),
      cancelReason: map["cancelReason"] as String?,
      customerId: map["customerId"] as String?,
      customerName: map["customerName"] as String?,
      customerEmail: map["customerEmail"] as String?,
      shippingAddress: map["shippingAddress"] as String?,
      paymentMethod: map["paymentMethod"] as String?,
      updatedAt: _toDate(map["updatedAt"]),
    );
  }

  factory OrderModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      OrderModel.fromMap(doc.data() ?? const {}, id: doc.id);

  Map<String, dynamic> toMap() {
    return {
      "placedOn": Timestamp.fromDate(placedOn),
      "items": items.map((item) => item.toMap()).toList(),
      "total": total,
      "status": status.name,
      "cancelReason": cancelReason,
      "customerId": customerId,
      "customerName": customerName,
      "customerEmail": customerEmail,
      "shippingAddress": shippingAddress,
      "paymentMethod": paymentMethod,
      "updatedAt":
          updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  static DateTime? _toDate(Object? value) => switch (value) {
        Timestamp v => v.toDate(),
        DateTime v => v,
        String v => DateTime.tryParse(v),
        _ => null,
      };
}
