import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shop/components/empty_state_view.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/controllers/bookmark_controller.dart';
import 'package:shop/route/route_constants.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = BookmarkController.to;

    return Scaffold(
      body: GetBuilder<BookmarkController>(
        builder: (controller) {
          final products = repository.products;

          if (products.isEmpty) {
            return EmptyStateView(
              title: "No saved items",
              description:
                  "Tap the bookmark icon on any product to save it here for later.",
              actionLabel: "Browse products",
              onAction: () => Navigator.pushNamed(context, homeScreenRoute),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: defaultPadding,
                  right: defaultPadding,
                  top: defaultPadding,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${products.length} saved item${products.length == 1 ? "" : "s"}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: repository.clear,
                        child: const Text("Clear all"),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(defaultPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final product = products[index];
                      return Stack(
                        children: [
                          ProductCard(
                            image: product.image,
                            brandName: product.brandName,
                            title: product.title,
                            price: product.price,
                            priceAfetDiscount: product.priceAfetDiscount,
                            dicountpercent: product.dicountpercent,
                            press: () {
                              Navigator.pushNamed(
                                  context, productDetailsScreenRoute,
                                  arguments: product);
                            },
                          ),
                          // Quick "unsave" action on each card.
                          Positioned(
                            top: 0,
                            left: 0,
                            child: IconButton(
                              onPressed: () => repository.remove(product),
                              tooltip: "Remove from saved",
                              icon: SvgPicture.asset(
                                "assets/icons/Close.svg",
                                height: 14,
                                colorFilter: const ColorFilter.mode(
                                  greyColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
