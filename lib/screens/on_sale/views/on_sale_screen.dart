import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../components/Banner/M/banner_m_with_counter.dart';
import '../../../components/empty_state_view.dart';
import '../../../components/product/product_card.dart';
import '../../../constants.dart';
import '../../../models/product_model.dart';
import '../../../controllers/cart_controller.dart';
import '../../../route/route_constants.dart';
import '../../../services/product_service.dart';
import '../../../utils/service_locator.dart';

/// On-sale screen: flash-sale countdown banner + discounted product sections.
class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({super.key});

  /// Deepest discounts headline the flash sale, the rest fill the second
  /// section, so both sections of this screen keep their content.
  static const int _flashSaleMinimumDiscount = 20;

  List<ProductModel> _discounted(List<ProductModel>? products) =>
      (products ?? const [])
          .where((product) => product.isPublished && product.isInStock)
          .where((product) => product.priceAfetDiscount != null)
          .toList();

  @override
  Widget build(BuildContext context) {
    final service = serviceOrNull<ProductService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("On sale"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, cartScreenRoute),
            tooltip: "Cart",
            icon: GetBuilder<CartController>(
              builder: (controller) {
                final count = CartController.to.itemCount;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text("$count"),
                  child: SvgPicture.asset(
                    "assets/icons/Bag.svg",
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyLarge!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<ProductModel>>(
          stream: service?.watchPublished() ?? const Stream.empty(),
          builder: (context, snapshot) {
            final discounted = _discounted(snapshot.data);
            final flashSale = discounted
                .where((product) =>
                    (product.dicountpercent ?? 0) >= _flashSaleMinimumDiscount)
                .toList();
            final bestSellers = discounted
                .where((product) =>
                    (product.dicountpercent ?? 0) < _flashSaleMinimumDiscount)
                .toList();

            if (discounted.isEmpty) {
              return const EmptyStateView(
                title: "No sales right now",
                description:
                    "There are no discounted products at the moment. Check back during our next flash sale.",
              );
            }

            return ListView(
              children: [
                BannerMWithCounter(
                  duration: const Duration(hours: 8),
                  text: "Super Flash Sale \n50% Off",
                  // Already on the sale screen: scroll target is the list
                  // below, so tapping the banner is a no-op by design.
                  press: () {},
                ),
                if (flashSale.isNotEmpty)
                  _ProductSection(title: "Flash sale", products: flashSale),
                if (bestSellers.isNotEmpty)
                  _ProductSection(
                      title: "Best sellers on sale", products: bestSellers),
                const SizedBox(height: defaultPadding),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductSection extends StatelessWidget {
  const _ProductSection({required this.title, required this.products});

  final String title;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
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
                  brandName: product.brandName,
                  title: product.title,
                  price: product.price,
                  priceAfetDiscount: product.priceAfetDiscount,
                  dicountpercent: product.dicountpercent,
                  press: () => Navigator.pushNamed(
                      context, productDetailsScreenRoute,
                      arguments: product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
