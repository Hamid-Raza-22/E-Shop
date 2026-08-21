import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/network_image_with_loader.dart';
import '../../../constants.dart';
import '../../../controllers/admin/admin_products_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/product_model.dart';
import '../../../utils/formatters.dart';
import '../../../utils/responsive.dart';
import 'components/product_form_sheet.dart';

/// Catalog management: search, filter, publish/unpublish, stock and CRUD.
class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  Future<void> _openForm(BuildContext context, {ProductModel? product}) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ProductFormSheet(product: product),
    );

    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).adminProductSaved)),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductModel product,
  ) async {
    final translations = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translations.adminProductDelete),
        content: Text(translations.adminProductDeleteConfirm(product.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(translations.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: errorColor),
            onPressed: () => Navigator.pop(context, true),
            child: Text(translations.actionDelete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final id = product.id;
    if (id == null) return;

    final deleted = await AdminProductsController.to.delete(id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted
              ? translations.adminProductDeleted
              : AdminProductsController.to.error ?? translations.errorGeneric,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminProductsController.to;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: Text(translations.adminProductAdd),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                TextField(
                  onChanged: controller.search,
                  decoration: InputDecoration(
                    hintText: translations.actionSearch,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final filter in ProductFilter.values)
                          Padding(
                            padding:
                                const EdgeInsets.only(right: defaultPadding / 2),
                            child: FilterChip(
                              label: Text(_filterLabel(translations, filter)),
                              selected: controller.filter == filter,
                              onSelected: (_) => controller.setFilter(filter),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final products = controller.products;

              if (products.isEmpty) {
                return _EmptyCatalog(
                  hasFilter: controller.query.isNotEmpty ||
                      controller.filter != ProductFilter.all,
                );
              }

              final columns = Responsive.value(
                context,
                mobile: 1,
                tablet: 2,
                desktop: 3,
              );

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  defaultPadding,
                  0,
                  defaultPadding,
                  defaultPadding * 5,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: defaultPadding,
                  crossAxisSpacing: defaultPadding,
                  mainAxisExtent: 132,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => _ProductRow(
                  product: products[index],
                  onEdit: () => _openForm(context, product: products[index]),
                  onDelete: () => _confirmDelete(context, products[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _filterLabel(AppLocalizations translations, ProductFilter filter) =>
      switch (filter) {
        ProductFilter.all => translations.labelAll,
        ProductFilter.published => translations.adminStatePublished,
        ProductFilter.draft => translations.adminStateDraft,
        ProductFilter.lowStock => translations.adminKpiLowStock,
      };
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductModel product;
  final VoidCallback onEdit, onDelete;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminProductsController.to;

    return Container(
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 108,
            child: NetworkImageWithLoader(
              product.image,
              radius: defaultBorderRadious,
            ),
          ),
          const SizedBox(width: defaultPadding / 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  product.brandName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: defaultPadding / 4),
                Row(
                  children: [
                    Text(
                      formatPrice(product.effectivePrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: defaultPadding / 2),
                    _StatePill(
                      label: product.isPublished
                          ? translations.adminStatePublished
                          : translations.adminStateDraft,
                      color:
                          product.isPublished ? successColor : warningColor,
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding / 4),
                Row(
                  children: [
                    Text(
                      product.stock == null
                          ? "—"
                          : translations.adminStockLeft(product.stock!),
                      style: TextStyle(
                        fontSize: 12,
                        color: product.isLowStock ? errorColor : null,
                        fontWeight:
                            product.isLowStock ? FontWeight.w600 : null,
                      ),
                    ),
                    const SizedBox(width: defaultPadding / 4),
                    _StockButton(
                      icon: Icons.remove,
                      onPressed: () => controller.adjustStock(product, -1),
                    ),
                    _StockButton(
                      icon: Icons.add,
                      onPressed: () => controller.adjustStock(product, 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => switch (value) {
              "edit" => onEdit(),
              "delete" => onDelete(),
              _ => controller.togglePublished(product),
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "edit", child: Text(translations.actionEdit)),
              PopupMenuItem(
                value: "publish",
                child: Text(
                  product.isPublished
                      ? translations.adminStateDraft
                      : translations.adminStatePublished,
                ),
              ),
              PopupMenuItem(
                value: "delete",
                child: Text(
                  translations.actionDelete,
                  style: const TextStyle(color: errorColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockButton extends StatelessWidget {
  const _StockButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      padding: EdgeInsets.zero,
      iconSize: 16,
      icon: Icon(icon),
    );
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({required this.hasFilter});

  /// An empty result because of search/filter must not offer demo seeding.
  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 40),
            const SizedBox(height: defaultPadding),
            Text(
              hasFilter
                  ? translations.adminNoData
                  : translations.adminProductNone,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (!hasFilter) ...[
              const SizedBox(height: defaultPadding),
              OutlinedButton.icon(
                onPressed: AdminProductsController.to.seedDemoCatalog,
                icon: const Icon(Icons.auto_awesome),
                label: const Text("Import demo catalog"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
