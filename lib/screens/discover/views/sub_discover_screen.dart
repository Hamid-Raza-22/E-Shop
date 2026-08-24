import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/product/product_card.dart';
import '../../../constants.dart';
import '../../../models/category_model.dart';
import '../../../models/product_model.dart';
import '../../../controllers/product_search_controller.dart';
import '../../../route/route_constants.dart';

/// Sub-category listing reached from a Discover category.
class SubDiscoverScreen extends StatefulWidget {
  const SubDiscoverScreen({super.key, this.title = "All Clothing"});

  final String title;

  @override
  State<SubDiscoverScreen> createState() => _SubDiscoverScreenState();
}

class _SubDiscoverScreenState extends State<SubDiscoverScreen> {
  /// Sub-category chips reused from the existing demo category data.
  late final List<String> _subCategories = [
    "All",
    ...?demoCategories.first.subCategories?.map((c) => c.title),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() => _build(context, _products()));
  }

  /// "All" shows the whole published catalog; every other chip matches the
  /// category the dashboard assigned to a product.
  List<ProductModel> _products() {
    final catalog = ProductSearchController.to.catalog;
    if (_selectedIndex == 0) return catalog;

    final category = _subCategories[_selectedIndex].toLowerCase();
    return catalog
        .where((product) => (product.category ?? "").toLowerCase() == category)
        .toList();
  }

  Widget _build(BuildContext context, List<ProductModel> products) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding),
                itemCount: _subCategories.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: defaultPadding / 2),
                    child: ChoiceChip(
                      label: Text(_subCategories[index]),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedIndex = index),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          "No products in this sub-category.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(defaultPadding),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                        childAspectRatio: 0.66,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          image: product.image,
                          brandName: product.brandName,
                          title: product.title,
                          price: product.price,
                          priceAfetDiscount: product.priceAfetDiscount,
                          dicountpercent: product.dicountpercent,
                          press: () => Navigator.pushNamed(
                              context, productDetailsScreenRoute,
                              arguments: product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
