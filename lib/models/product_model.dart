import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/constants.dart';

/// A catalog product.
///
/// The storefront only needs the presentation fields, while the dashboard also
/// manages the commerce fields ([stock], [isPublished], [sku], …). Those are
/// nullable/defaulted so the demo catalog below — and any older call site —
/// keeps compiling unchanged.
class ProductModel {
  ProductModel({
    this.id,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.category,
    this.description,
    this.sku,
    this.stock,
    this.isPublished = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Firestore document id. Null for the bundled demo products.
  final String? id;
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final String? category, description, sku;
  final int? stock;
  final bool isPublished;
  final DateTime? createdAt, updatedAt;

  /// Price actually charged for one unit.
  double get effectivePrice => priceAfetDiscount ?? price;

  /// Unknown stock (demo data) counts as available.
  bool get isInStock => stock == null || stock! > 0;

  bool get isLowStock => stock != null && stock! > 0 && stock! <= lowStockThreshold;

  /// Stock level at or below which the dashboard flags a product.
  static const int lowStockThreshold = 5;

  /// Stable identity used for cart/bookmark de-duplication.
  String get key => id ?? "$title-$image";

  ProductModel copyWith({
    String? id,
    String? image,
    String? brandName,
    String? title,
    double? price,
    double? priceAfetDiscount,
    bool clearPriceAfterDiscount = false,
    int? dicountpercent,
    bool clearDiscountPercent = false,
    String? category,
    String? description,
    String? sku,
    int? stock,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      image: image ?? this.image,
      brandName: brandName ?? this.brandName,
      title: title ?? this.title,
      price: price ?? this.price,
      priceAfetDiscount: clearPriceAfterDiscount
          ? null
          : priceAfetDiscount ?? this.priceAfetDiscount,
      dicountpercent:
          clearDiscountPercent ? null : dicountpercent ?? this.dicountpercent,
      category: category ?? this.category,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      stock: stock ?? this.stock,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ProductModel(
      id: id ?? map["id"] as String?,
      image: (map["image"] as String?) ?? "",
      brandName: (map["brandName"] as String?) ?? "",
      title: (map["title"] as String?) ?? "",
      price: _toDouble(map["price"]) ?? 0,
      priceAfetDiscount: _toDouble(map["priceAfterDiscount"]),
      dicountpercent: _toInt(map["discountPercent"]),
      category: map["category"] as String?,
      description: map["description"] as String?,
      sku: map["sku"] as String?,
      stock: _toInt(map["stock"]),
      isPublished: map["isPublished"] as bool? ?? true,
      createdAt: _toDate(map["createdAt"]),
      updatedAt: _toDate(map["updatedAt"]),
    );
  }

  factory ProductModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ProductModel.fromMap(doc.data() ?? const {}, id: doc.id);

  /// Firestore payload. The document id is never duplicated inside the document.
  Map<String, dynamic> toMap() {
    return {
      "image": image,
      "brandName": brandName,
      "title": title,
      "price": price,
      "priceAfterDiscount": priceAfetDiscount,
      "discountPercent": dicountpercent,
      "category": category,
      "description": description,
      "sku": sku,
      "stock": stock,
      "isPublished": isPublished,
      "createdAt":
          createdAt == null ? null : Timestamp.fromDate(createdAt!),
      "updatedAt":
          updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  static double? _toDouble(Object? value) => switch (value) {
        num v => v.toDouble(),
        String v => double.tryParse(v),
        _ => null,
      };

  static int? _toInt(Object? value) => switch (value) {
        num v => v.toInt(),
        String v => int.tryParse(v),
        _ => null,
      };

  static DateTime? _toDate(Object? value) => switch (value) {
        Timestamp v => v.toDate(),
        DateTime v => v,
        String v => DateTime.tryParse(v),
        _ => null,
      };
}

List<ProductModel> demoPopularProducts = [
  ProductModel(
    image: productDemoImg1,
    title: "Mountain Warehouse for Women",
    brandName: "Lipsy london",
    price: 540,
    priceAfetDiscount: 420,
    dicountpercent: 20,
  ),
  ProductModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 800,
  ),
  ProductModel(
    image: productDemoImg5,
    title: "FS - Nike Air Max 270 Really React",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
  ),
  ProductModel(
    image: productDemoImg6,
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
  ),
  ProductModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
  ),
  ProductModel(
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
  ),
];
List<ProductModel> demoFlashSaleProducts = [
  ProductModel(
    image: productDemoImg5,
    title: "FS - Nike Air Max 270 Really React",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
  ),
  ProductModel(
    image: productDemoImg6,
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
  ),
  ProductModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 800,
    priceAfetDiscount: 680,
    dicountpercent: 15,
  ),
];
List<ProductModel> demoBestSellersProducts = [
  ProductModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 390.36,
    dicountpercent: 40,
  ),
  ProductModel(
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    brandName: "Lipsy london",
    price: 1264,
    priceAfetDiscount: 1200.8,
    dicountpercent: 5,
  ),
  ProductModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 800,
    priceAfetDiscount: 680,
    dicountpercent: 15,
  ),
];
List<ProductModel> kidsProducts = [
  ProductModel(
    image: "https://i.imgur.com/dbbT6PA.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    price: 650.62,
    priceAfetDiscount: 590.36,
    dicountpercent: 24,
  ),
  ProductModel(
    image: "https://i.imgur.com/7fSxC7k.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    price: 650.62,
  ),
  ProductModel(
    image: "https://i.imgur.com/pXnYE9Q.png",
    title: "Ruffle-Sleeve Ponte-Knit Sheath ",
    brandName: "Lipsy london",
    price: 400,
  ),
  ProductModel(
    image: "https://i.imgur.com/V1MXgfa.png",
    title: "Green Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 400,
    priceAfetDiscount: 360,
    dicountpercent: 20,
  ),
  ProductModel(
    image: "https://i.imgur.com/8gvE5Ss.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    price: 654,
  ),
  ProductModel(
    image: "https://i.imgur.com/cBvB5YB.png",
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    price: 250,
  ),
];
