import 'package:flutter/material.dart';

import '../../../components/empty_state_view.dart';
import '../../../components/network_image_with_loader.dart';
import '../../../components/product/product_card.dart';
import '../../../constants.dart';
import '../../../models/product_model.dart';
import '../../../repositories/search_repository.dart';
import '../../../route/route_constants.dart';

/// Brand landing page: banner + every product from that brand.
class BrandScreen extends StatelessWidget {
  const BrandScreen({
    super.key,
    this.brandName = "Lipsy london",
    this.bannerImage = "https://i.imgur.com/dz0BBom.png",
  });

  final String brandName, bannerImage;

  @override
  Widget build(BuildContext context) {
    final products = SearchRepository.instance.catalog
        .where((product) =>
            product.brandName.toLowerCase() == brandName.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(brandName)),
      body: SafeArea(
        child: products.isEmpty
            ? EmptyStateView(
                title: "No products",
                description: "$brandName has no products available right now.",
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: AspectRatio(
                        aspectRatio: 1.8,
                        child: NetworkImageWithLoader(bannerImage),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "${products.length} products by $brandName",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(defaultPadding),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                        childAspectRatio: 0.66,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final ProductModel product = products[index];
                          return ProductCard(
                            image: product.image,
                            brandName: product.brandName,
                            title: product.title,
                            price: product.price,
                            priceAfetDiscount: product.priceAfetDiscount,
                            dicountpercent: product.dicountpercent,
                            press: () => Navigator.pushNamed(
                                context, productDetailsScreenRoute),
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
