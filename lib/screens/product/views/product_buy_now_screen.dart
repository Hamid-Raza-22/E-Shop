import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/repositories/bookmark_repository.dart';
import 'package:shop/repositories/cart_repository.dart';
import 'package:shop/screens/product/views/added_to_cart_message_screen.dart';
import 'package:shop/screens/product/views/components/product_list_tile.dart';
import 'package:shop/screens/product/views/location_permission_store_availability_screen.dart';
import 'package:shop/screens/product/views/size_guide_screen.dart';

import '../../../constants.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen({super.key, this.product});

  /// Product being added to the cart. Falls back to the demo product shown in
  /// the design when the caller does not pass one.
  final ProductModel? product;

  @override
  State<ProductBuyNowScreen> createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  static const List<Color> _colors = [
    Color(0xFFEA6262),
    Color(0xFFB1CC63),
    Color(0xFFFFBF5F),
    Color(0xFF9FE1DD),
    Color(0xFFC482DB),
  ];
  static const List<String> _sizes = ["S", "M", "L", "XL", "XXL"];

  late final ProductModel _product = widget.product ??
      ProductModel(
        image: productDemoImg1,
        title: "Sleeveless Ruffle",
        brandName: "Lipsy london",
        price: 145,
        priceAfetDiscount: 134.7,
        dicountpercent: 7,
      );

  int _quantity = 1;
  int _selectedColorIndex = 2;
  int _selectedSizeIndex = 1;

  double get _unitPrice => _product.priceAfetDiscount ?? _product.price;

  double get _totalPrice => _unitPrice * _quantity;

  void _addToCart() {
    CartRepository.instance.add(_product, quantity: _quantity);
    customModalBottomSheet(
      context,
      isDismissible: false,
      child: const AddedToCartMessageScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: _totalPrice,
        title: "Add to cart",
        subTitle: "Total price",
        press: _addToCart,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Expanded(
                  child: Text(
                    _product.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ListenableBuilder(
                  listenable: BookmarkRepository.instance,
                  builder: (context, _) {
                    final isSaved =
                        BookmarkRepository.instance.contains(_product);
                    return IconButton(
                      onPressed: () =>
                          BookmarkRepository.instance.toggle(_product),
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
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: NetworkImageWithLoader(_product.image),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: UnitPrice(
                            price: _product.price,
                            priceAfterDiscount: _product.priceAfetDiscount,
                          ),
                        ),
                        ProductQuantity(
                          numOfItem: _quantity,
                          onIncrement: () => setState(() => _quantity++),
                          onDecrement: () {
                            // Minimum purchasable quantity is 1.
                            if (_quantity <= 1) return;
                            setState(() => _quantity--);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(
                  child: SelectedColors(
                    colors: _colors,
                    selectedColorIndex: _selectedColorIndex,
                    press: (value) =>
                        setState(() => _selectedColorIndex = value),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SelectedSize(
                    sizes: _sizes,
                    selectedIndex: _selectedSizeIndex,
                    press: (value) => setState(() => _selectedSizeIndex = value),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Size guide",
                    svgSrc: "assets/icons/Sizeguid.svg",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const SizeGuideScreen(),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: defaultPadding / 2),
                        Text(
                          "Store pickup availability",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        Text(
                          "Size ${_sizes[_selectedSizeIndex]} selected. Check store availability and In-Store pickup options.",
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Check stores",
                    svgSrc: "assets/icons/Stores.svg",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: const LocationPermissonStoreAvailabilityScreen(),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding))
              ],
            ),
          )
        ],
      ),
    );
  }
}
