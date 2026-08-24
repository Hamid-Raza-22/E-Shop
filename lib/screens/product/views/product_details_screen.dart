import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/controllers/bookmark_controller.dart';
import 'package:shop/controllers/review_controller.dart';
import 'package:shop/screens/product/views/product_returns_screen.dart';
import 'package:shop/services/product_service.dart';
import 'package:shop/utils/service_locator.dart';

import 'package:shop/route/screen_export.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    this.product,
    this.isProductAvailable = true,
  });

  /// Product to show. Falls back to the demo product from the design when the
  /// route is opened without one.
  final ProductModel? product;

  /// Only used for the fallback product; a real product decides availability
  /// from its own stock level.
  final bool isProductAvailable;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  /// Product represented by this screen's static content, used when no product
  /// was passed through the route.
  static final ProductModel _fallbackProduct = ProductModel(
    image: productDemoImg1,
    title: "Sleeveless Ruffle",
    brandName: "LIPSY LONDON",
    price: 145,
    priceAfetDiscount: 140,
    dicountpercent: 4,
    description:
        "A cool gray cap in soft corduroy. Watch me.' By buying cotton products from Lindex, you’re supporting more responsibly...",
  );

  /// Back-in-stock notification opt-in for the out-of-stock variant.
  bool _isNotifyEnabled = false;

  ProductModel get _product => widget.product ?? _fallbackProduct;

  bool get isProductAvailable =>
      widget.product == null ? widget.isProductAvailable : _product.isInStock;

  @override
  void initState() {
    super.initState();
    // Reviews shown below belong to this product only.
    ReviewController.to.bindProduct(_product.id);
  }

  @override
  void didUpdateWidget(ProductDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product?.id != widget.product?.id) {
      ReviewController.to.bindProduct(_product.id);
    }
  }

  /// A Firestore product carries a single image; the gallery keeps working by
  /// showing the demo set only for the fallback product.
  List<String> get _images => widget.product == null
      ? const [productDemoImg1, productDemoImg2, productDemoImg3]
      : [_product.image];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isProductAvailable
          ? CartButton(
              price: _product.effectivePrice,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: ProductBuyNowScreen(product: _product),
                );
              },
            )
          :

          /// If profuct is not available then show [NotifyMeCard]
          NotifyMeCard(
              isNotify: _isNotifyEnabled,
              onChanged: (value) {
                setState(() => _isNotifyEnabled = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value
                        ? "We will notify you when this item is back in stock"
                        : "Back-in-stock alerts turned off"),
                  ),
                );
              },
            ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                // Live bookmark toggle backed by BookmarkController.
                GetBuilder<BookmarkController>(
                  builder: (controller) {
                    final isSaved =
                        BookmarkController.to.contains(_product);
                    return IconButton(
                      onPressed: () {
                        final nowSaved =
                            BookmarkController.to.toggle(_product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(nowSaved
                                ? "Saved to your wishlist"
                                : "Removed from your wishlist"),
                          ),
                        );
                      },
                      tooltip: isSaved ? "Remove from saved" : "Save",
                      icon: SvgPicture.asset(
                        "assets/icons/Bookmark.svg",
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          isSaved
                              ? primaryColor
                              : Theme.of(context).textTheme.bodyLarge!.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            ProductImages(images: _images),
            GetBuilder<ReviewController>(
              builder: (controller) {
                final summary = controller.summary;
                return ProductInfo(
                  brand: _product.brandName,
                  title: _product.title,
                  isAvailable: isProductAvailable,
                  description: _product.description ??
                      "No description has been added for this product yet.",
                  rating: summary.average,
                  numOfReviews: summary.total,
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: "Product Details",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductInfoScreen(),
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: "Shipping Information",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ShippingInfoScreen(),
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Returns",
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductReturnsScreen(),
                );
              },
            ),
            SliverToBoxAdapter(
              child: GetBuilder<ReviewController>(
                builder: (controller) {
                  final summary = controller.summary;
                  return Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: ReviewCard(
                      rating: summary.average,
                      numOfReviews: summary.total,
                      numOfFiveStar: summary.countFor(5),
                      numOfFourStar: summary.countFor(4),
                      numOfThreeStar: summary.countFor(3),
                      numOfTwoStar: summary.countFor(2),
                      numOfOneStar: summary.countFor(1),
                    ),
                  );
                },
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Reviews",
              isShowBottomBorder: true,
              press: () {
                Navigator.pushNamed(context, productReviewsScreenRoute,
                    arguments: _product.id);
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You may also like",
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: _RelatedProducts(current: _product),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}

/// Live "you may also like" strip: published products other than this one,
/// preferring the same category.
class _RelatedProducts extends StatelessWidget {
  const _RelatedProducts({required this.current});

  final ProductModel current;

  static const int _maxItems = 5;

  List<ProductModel> _related(List<ProductModel>? products) {
    final candidates = (products ?? const [])
        .where((product) => product.isPublished && product.isInStock)
        .where((product) => product.key != current.key)
        .toList();

    final sameCategory = candidates
        .where((product) =>
            current.category != null && product.category == current.category)
        .toList();

    return [
      ...sameCategory,
      ...candidates.where((product) => !sameCategory.contains(product)),
    ].take(_maxItems).toList();
  }

  @override
  Widget build(BuildContext context) {
    final service = serviceOrNull<ProductService>();

    return StreamBuilder<List<ProductModel>>(
      stream: service?.watchPublished() ?? const Stream.empty(),
      builder: (context, snapshot) {
        final products = _related(snapshot.data);
        if (products.isEmpty) return const SizedBox.shrink();

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == products.length - 1 ? defaultPadding : 0,
              ),
              child: ProductCard(
                image: product.image,
                title: product.title,
                brandName: product.brandName,
                price: product.price,
                priceAfetDiscount: product.priceAfetDiscount,
                dicountpercent: product.dicountpercent,
                press: () => Navigator.pushNamed(
                  context,
                  productDetailsScreenRoute,
                  arguments: product,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
