import 'package:flutter/material.dart';

import '../../../components/network_image_with_loader.dart';
import '../../../constants.dart';
import '../../../models/category_model.dart';
import '../../search/views/components/search_form.dart';
import 'sub_discover_screen.dart';

/// Image-led category grid variant of the Discover screen.
class DiscoverWithImageScreen extends StatelessWidget {
  const DiscoverWithImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discover")),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: SearchForm(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Categories",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: defaultPadding,
                  crossAxisSpacing: defaultPadding,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final CategoryModel category =
                        demoCategoriesWithImage[index];
                    return _CategoryImageCard(category: category);
                  },
                  childCount: demoCategoriesWithImage.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryImageCard extends StatelessWidget {
  const _CategoryImageCard({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubDiscoverScreen(title: category.title),
        ),
      ),
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkImageWithLoader(
            category.image!,
            radius: defaultBorderRadious,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(defaultBorderRadious)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                category.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
