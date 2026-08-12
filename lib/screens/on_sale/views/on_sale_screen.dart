import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/Banner/M/banner_m_with_counter.dart';
import '../../../components/empty_state_view.dart';
import '../../../components/product/product_card.dart';
import '../../../constants.dart';
import '../../../models/product_model.dart';
import '../../../repositories/cart_repository.dart';
import '../../../route/route_constants.dart';

/// On-sale screen: flash-sale countdown banner + discounted product sections.
class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({super.key});

  /// Only products that actually carry a discount belong on this screen.
  List<ProductModel> _discounted(List<ProductModel> products) =>
      products.where((product) => product.priceAfetDiscount != null).toList();

  @override
  Widget build(BuildContext context) {
    final flashSale = _discounted(demoFlashSaleProducts);
    final bestSellers = _discounted(demoBestSellersProducts);
    final hasProducts = flashSale.isNotEmpty || bestSellers.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("On sale"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, cartScreenRoute),
            tooltip: "Cart",
            icon: ListenableBuilder(
              listenable: CartRepository.instance,
              builder: (context, _) {
                final count = CartRepository.instance.itemCount;
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
        child: hasProducts
            ? ListView(
                children: [
                  BannerMWithCounter(
                    duration: const Duration(hours: 8),
                    text: "Super Flash Sale \n50% Off",
                    press: () {},
                  ),
                  if (flashSale.isNotEmpty)
                    _ProductSection(title: "Flash sale", products: flashSale),
                  if (bestSellers.isNotEmpty)
                    _ProductSection(
                        title: "Best sellers on sale", products: bestSellers),
                  const SizedBox(height: defaultPadding),
                ],
              )
            : const EmptyStateView(
                title: "No sales right now",
                description:
                    "There are no discounted products at the moment. Check back during our next flash sale.",
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
                      context, productDetailsScreenRoute),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
