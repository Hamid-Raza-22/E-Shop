import 'package:flutter/material.dart';

import '../../../components/empty_state_view.dart';
import '../../../components/product/product_card.dart';
import '../../../constants.dart';
import '../../../models/product_model.dart';
import '../../../route/route_constants.dart';

/// Kids category grid, driven by [kidsProducts].
class KidsScreen extends StatelessWidget {
  const KidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = kidsProducts;

    return Scaffold(
      appBar: AppBar(title: const Text("Kids")),
      body: SafeArea(
        child: products.isEmpty
            ? const EmptyStateView(
                title: "Nothing here yet",
                description:
                    "There are no kids products available right now. Please check back soon.",
              )
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "${products.length} products",
                        style: Theme.of(context).textTheme.bodyMedium,
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
                          final product = products[index];
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
