import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import 'firestore_paths.dart';

/// What a seeding run actually wrote.
class DemoSeedResult {
  const DemoSeedResult({
    required this.customers,
    required this.orders,
    required this.reviews,
    required this.promotions,
  });

  const DemoSeedResult.empty()
      : customers = 0,
        orders = 0,
        reviews = 0,
        promotions = 0;

  final int customers, orders, reviews, promotions;

  bool get isEmpty =>
      customers == 0 && orders == 0 && reviews == 0 && promotions == 0;

  int get total => customers + orders + reviews + promotions;
}

/// Fills an empty project with realistic sample data so the dashboard has
/// something to manage before the first real customer arrives.
///
/// Every document is written to a fixed id with `merge`, which makes a second
/// run a no-op update instead of a duplicate. Products are seeded separately by
/// `ProductService.importAll`, because that data is also what the storefront
/// shows.
class DemoSeedService {
  DemoSeedService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Prefix that marks a document as demo data, so it can be told apart from
  /// anything a real shopper created.
  static const String idPrefix = "demo_";

  CollectionReference<Map<String, dynamic>> _collection(String name) =>
      _firestore.collection(name);

  /// Writes the sample customers, orders, reviews and promotions.
  ///
  /// [products] are used to give the seeded orders and reviews real catalog
  /// references; pass the freshly imported catalog. When it is empty the orders
  /// and reviews are skipped, since an order without products is meaningless.
  Future<DemoSeedResult> seedAll({
    required List<ProductModel> products,
    bool force = false,
  }) async {
    if (!force && await _alreadySeeded()) return const DemoSeedResult.empty();

    final customers = await _seedCustomers();
    final promotions = await _seedPromotions();

    if (products.isEmpty) {
      return DemoSeedResult(
        customers: customers,
        orders: 0,
        reviews: 0,
        promotions: promotions,
      );
    }

    final orders = await _seedOrders(products);
    final reviews = await _seedReviews(products);

    return DemoSeedResult(
      customers: customers,
      orders: orders,
      reviews: reviews,
      promotions: promotions,
    );
  }

  /// One marker read is enough: the customers are always written first.
  Future<bool> _alreadySeeded() async {
    final doc = await _collection(FirestorePaths.customers)
        .doc("${idPrefix}customer_1")
        .get();
    return doc.exists;
  }

  static const List<({String name, String email, String phone})> _people = [
    (name: "Amelia Turner", email: "amelia.turner@example.com", phone: "+1 202 555 0134"),
    (name: "Noah Fischer", email: "noah.fischer@example.com", phone: "+49 30 5550 118"),
    (name: "Zara Ahmed", email: "zara.ahmed@example.com", phone: "+92 300 5550 173"),
    (name: "Lucas Moreau", email: "lucas.moreau@example.com", phone: "+33 1 5550 142"),
  ];

  Future<int> _seedCustomers() async {
    final batch = _firestore.batch();
    final collection = _collection(FirestorePaths.customers);
    final now = DateTime.now();

    for (var index = 0; index < _people.length; index++) {
      final person = _people[index];
      batch.set(
        collection.doc("${idPrefix}customer_${index + 1}"),
        {
          "name": person.name,
          "email": person.email,
          "phone": person.phone,
          "createdAt":
              Timestamp.fromDate(now.subtract(Duration(days: 30 - index * 6))),
          "ordersCount": 0,
          "totalSpent": 0.0,
          "isBlocked": false,
          "isDemo": true,
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
    return _people.length;
  }

  /// One order per customer, spread over the last three weeks and across the
  /// lifecycle so the dashboard's KPIs, chart and status filters all have data.
  Future<int> _seedOrders(List<ProductModel> products) async {
    const statuses = [
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final batch = _firestore.batch();
    final collection = _collection(FirestorePaths.orders);
    final now = DateTime.now();

    for (var index = 0; index < _people.length; index++) {
      final person = _people[index];
      final product = products[index % products.length];
      final quantity = 1 + index % 2;
      final unitPrice = product.effectivePrice;
      final placedOn = now.subtract(Duration(days: index * 5 + 1));

      final order = OrderModel(
        id: "${idPrefix}order_${index + 1}",
        placedOn: placedOn,
        total: unitPrice * quantity,
        status: statuses[index % statuses.length],
        customerId: "${idPrefix}customer_${index + 1}",
        customerName: person.name,
        customerEmail: person.email,
        shippingAddress: "12 Example Street, Springfield",
        paymentMethod: index.isEven ? "Card" : "Cash on delivery",
        items: [
          OrderItem(
            product: product,
            quantity: quantity,
            unitPrice: unitPrice,
          ),
        ],
      );

      batch.set(
        collection.doc(order.id),
        {
          ...order.toMap(),
          "updatedAt": Timestamp.fromDate(placedOn),
          "isDemo": true,
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
    return _people.length;
  }

  /// A mix of approved and pending reviews, so the moderation queue is not empty
  /// either.
  Future<int> _seedReviews(List<ProductModel> products) async {
    const texts = [
      (rating: 5.0, text: "Exactly as pictured and the fabric feels premium."),
      (rating: 4.0, text: "Great fit, though delivery took a couple of days longer."),
      (rating: 3.0, text: "Decent for the price but it creases quickly."),
      (rating: 5.0, text: "Second one I have bought. Washes really well."),
    ];

    final batch = _firestore.batch();
    final collection = _collection(FirestorePaths.reviews);
    final now = DateTime.now();
    var written = 0;

    for (var index = 0; index < texts.length; index++) {
      final product = products[index % products.length];
      final productId = product.id;
      if (productId == null) continue;

      batch.set(
        collection.doc("${idPrefix}review_${index + 1}"),
        {
          "productId": productId,
          "userName": _people[index % _people.length].name,
          "rating": texts[index].rating,
          "review": texts[index].text,
          "createdAt":
              Timestamp.fromDate(now.subtract(Duration(days: index * 3 + 1))),
          // The last one stays pending so moderation has something to do.
          "isApproved": index != texts.length - 1,
          "isDemo": true,
        },
        SetOptions(merge: true),
      );
      written++;
    }

    if (written == 0) return 0;
    await batch.commit();
    return written;
  }

  Future<int> _seedPromotions() async {
    final now = DateTime.now();
    final promotions = [
      (
        code: "WELCOME10",
        title: "10% off your first order",
        percentOff: 10,
        validTo: now.add(const Duration(days: 90)),
        usageLimit: null,
      ),
      (
        code: "FLASH25",
        title: "Flash sale — 25% off",
        percentOff: 25,
        validTo: now.add(const Duration(days: 14)),
        usageLimit: 100,
      ),
    ];

    final batch = _firestore.batch();
    final collection = _collection(FirestorePaths.promotions);

    for (var index = 0; index < promotions.length; index++) {
      final promotion = promotions[index];
      batch.set(
        collection.doc("${idPrefix}promotion_${index + 1}"),
        {
          "code": promotion.code,
          "title": promotion.title,
          "percentOff": promotion.percentOff,
          "validFrom": Timestamp.fromDate(now),
          "validTo": Timestamp.fromDate(promotion.validTo),
          "usageLimit": promotion.usageLimit,
          "usedCount": 0,
          "isActive": true,
          "createdAt": Timestamp.fromDate(now),
          "updatedAt": Timestamp.fromDate(now),
          "isDemo": true,
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
    return promotions.length;
  }
}
