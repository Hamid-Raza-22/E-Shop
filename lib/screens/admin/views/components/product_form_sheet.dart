import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';
import '../../../../controllers/admin/admin_products_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/product_model.dart';
import '../../../../services/storage_service.dart';
import '../../../../utils/responsive.dart';
import '../../../../utils/service_locator.dart';

/// Create/edit form for a catalog product.
///
/// Pops with `true` once the product was written to Firestore.
class ProductFormSheet extends StatefulWidget {
  const ProductFormSheet({super.key, this.product});

  /// Null when adding a new product.
  final ProductModel? product;

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final _title = TextEditingController(text: widget.product?.title);
  late final _brand = TextEditingController(text: widget.product?.brandName);
  late final _image = TextEditingController(text: widget.product?.image);
  late final _category = TextEditingController(text: widget.product?.category);
  late final _description =
      TextEditingController(text: widget.product?.description);
  late final _sku = TextEditingController(text: widget.product?.sku);
  late final _price =
      TextEditingController(text: widget.product?.price.toStringAsFixed(2));
  late final _discount = TextEditingController(
    text: widget.product?.dicountpercent?.toString(),
  );
  late final _stock =
      TextEditingController(text: widget.product?.stock?.toString() ?? "0");

  late bool _isPublished = widget.product?.isPublished ?? true;

  bool _isUploading = false;

  bool get _isEditing => widget.product != null;

  /// Picks an image and puts its Storage download URL into the image field, so
  /// uploading and pasting a URL end up in exactly the same place.
  Future<void> _pickImage() async {
    final storage = serviceOrNull<StorageService>();
    if (storage == null) {
      _showMessage("Image uploads need Firebase Storage to be configured.");
      return;
    }

    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // Product art does not need to be bigger than this, and it keeps the
      // upload small enough to feel instant.
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _isUploading = true);
    try {
      final url = await storage.uploadProductImage(
        bytes: await picked.readAsBytes(),
        fileName: picked.name,
        contentType: picked.mimeType,
      );
      if (!mounted) return;
      setState(() => _image.text = url);
    } catch (exception) {
      _showMessage("Upload failed: $exception");
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    for (final controller in [
      _title,
      _brand,
      _image,
      _category,
      _description,
      _sku,
      _price,
      _discount,
      _stock,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final price = double.parse(_price.text.trim());
    final discount = int.tryParse(_discount.text.trim());
    // The discounted price is derived, never typed, so the two can't disagree.
    final priceAfterDiscount = discount == null || discount <= 0
        ? null
        : double.parse((price * (100 - discount) / 100).toStringAsFixed(2));

    final product = ProductModel(
      id: widget.product?.id,
      title: _title.text.trim(),
      brandName: _brand.text.trim(),
      image: _image.text.trim(),
      category: _category.text.trim().isEmpty ? null : _category.text.trim(),
      description:
          _description.text.trim().isEmpty ? null : _description.text.trim(),
      sku: _sku.text.trim().isEmpty ? null : _sku.text.trim(),
      price: price,
      priceAfetDiscount: priceAfterDiscount,
      dicountpercent: discount == null || discount <= 0 ? null : discount,
      stock: int.tryParse(_stock.text.trim()) ?? 0,
      isPublished: _isPublished,
      createdAt: widget.product?.createdAt,
    );

    final saved = await AdminProductsController.to.save(product);
    if (!mounted) return;

    if (saved) {
      Navigator.pop(context, true);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AdminProductsController.to.error ??
              AppLocalizations.of(context).errorGeneric,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final isWide = !Responsive.isMobile(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Form(
          key: _formKey,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing
                          ? translations.adminProductEdit
                          : translations.adminProductAdd,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              _field(
                controller: _title,
                label: translations.adminFieldTitle,
                required: true,
              ),
              _pair(
                isWide: isWide,
                first: _field(
                  controller: _brand,
                  label: translations.adminFieldBrand,
                  required: true,
                ),
                second: _field(
                  controller: _category,
                  label: translations.adminFieldCategory,
                ),
              ),
              _field(
                controller: _image,
                label: translations.adminFieldImageUrl,
                required: true,
                keyboardType: TextInputType.url,
                validator: (value) {
                  final url = value?.trim() ?? "";
                  if (url.isEmpty) return translations.validationRequired;
                  // Bundled asset paths stay valid so the demo catalog keeps
                  // working next to uploaded images.
                  if (url.startsWith("assets/")) return null;
                  final uri = Uri.tryParse(url);
                  if (uri == null || !uri.isAbsolute) {
                    return "Enter a full image URL (https://…)";
                  }
                  return null;
                },
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  onPressed: _isUploading ? null : _pickImage,
                  icon: _isUploading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_outlined),
                  label: Text(_isUploading ? "Uploading…" : "Upload image"),
                ),
              ),
              const SizedBox(height: defaultPadding),
              _pair(
                isWide: isWide,
                first: _field(
                  controller: _price,
                  label: translations.labelPrice,
                  required: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  ],
                  validator: (value) {
                    final price = double.tryParse(value?.trim() ?? "");
                    if (price == null) return translations.validationRequired;
                    if (price <= 0) return "Price must be greater than zero";
                    return null;
                  },
                ),
                second: _field(
                  controller: _discount,
                  label: translations.adminFieldDiscountPercent,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final text = value?.trim() ?? "";
                    if (text.isEmpty) return null;
                    final discount = int.tryParse(text);
                    if (discount == null || discount < 0 || discount > 90) {
                      return "0–90 only";
                    }
                    return null;
                  },
                ),
              ),
              _pair(
                isWide: isWide,
                first: _field(
                  controller: _stock,
                  label: translations.adminFieldStock,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                second: _field(
                  controller: _sku,
                  label: translations.adminFieldSku,
                ),
              ),
              _field(
                controller: _description,
                label: translations.adminFieldDescription,
                maxLines: 4,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _isPublished,
                onChanged: (value) => setState(() => _isPublished = value),
                title: Text(translations.adminFieldPublished),
                subtitle: Text(
                  _isPublished
                      ? translations.adminStatePublished
                      : translations.adminStateDraft,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Obx(
                () => ElevatedButton(
                  onPressed:
                      AdminProductsController.to.isSaving ? null : _save,
                  child: AdminProductsController.to.isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(translations.actionSave),
                ),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        );
      },
    );
  }

  /// Two fields side by side on wide screens, stacked on phones.
  Widget _pair({
    required bool isWide,
    required Widget first,
    required Widget second,
  }) {
    if (!isWide) return Column(children: [first, second]);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: defaultPadding),
        Expanded(child: second),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator ??
            (required
                ? (value) => (value?.trim() ?? "").isEmpty
                    ? AppLocalizations.of(context).validationRequired
                    : null
                : null),
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }
}
