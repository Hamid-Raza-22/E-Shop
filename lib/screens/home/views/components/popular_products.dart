import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/screen_export.dart';

import '../../../../constants.dart';
import '../../../../services/product_service.dart';
import '../../../../utils/service_locator.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({
    super.key,
  });

  List<ProductModel> _visibleProducts(List<ProductModel>? products) =>
      (products ?? const [])
          .where((product) => product.isPublished && product.isInStock)
          .toList();

  @override
  Widget build(BuildContext context) {
    final service = serviceOrNull<ProductService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Popular products",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        StreamBuilder<List<ProductModel>>(
          stream: service?.watchPublished() ?? const Stream.empty(),
          builder: (context, snapshot) {
            final products = _visibleProducts(snapshot.data);
            if (products.isEmpty) {
              return const SizedBox.shrink();
            }

            return SizedBox(
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
                      press: () {
                        Navigator.pushNamed(context, productDetailsScreenRoute,
                            arguments: product);
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
