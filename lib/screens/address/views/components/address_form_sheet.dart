import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../components/icon_text_form_field.dart';
import '../../../../constants.dart';
import '../../../../models/address_model.dart';

/// Add/edit address bottom sheet.
///
/// Pops with the created/updated [AddressModel] data via an [AddressFormResult]
/// so the caller decides whether to insert or update.
class AddressFormResult {
  const AddressFormResult({
    required this.label,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.zipCode,
    required this.isDefault,
  });

  final String label, fullName, phone, addressLine, city, zipCode;
  final bool isDefault;
}

class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key, this.address});

  /// When non-null the sheet is in edit mode and fields are pre-filled.
  final AddressModel? address;

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _labelController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressLineController;
  late final TextEditingController _cityController;
  late final TextEditingController _zipController;

  late bool _isDefault;

  bool get _isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _labelController = TextEditingController(text: address?.label ?? "");
    _fullNameController = TextEditingController(text: address?.fullName ?? "");
    _phoneController = TextEditingController(text: address?.phone ?? "");
    _addressLineController =
        TextEditingController(text: address?.addressLine ?? "");
    _cityController = TextEditingController(text: address?.city ?? "");
    _zipController = TextEditingController(text: address?.zipCode ?? "");
    _isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.pop(
      context,
      AddressFormResult(
        label: _labelController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine: _addressLineController.text.trim(),
        city: _cityController.text.trim(),
        zipCode: _zipController.text.trim(),
        isDefault: _isDefault,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(_isEditing ? "Edit address" : "Add new address"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(defaultPadding),
              children: [
                IconTextFormField(
                  controller: _labelController,
                  hintText: "Label (Home, Office...)",
                  svgSrc: "assets/icons/Bookmark.svg",
                  textCapitalization: TextCapitalization.words,
                  validator: RequiredValidator(
                    errorText: "Label is required",
                  ).call,
                ),
                const SizedBox(height: defaultPadding),
                IconTextFormField(
                  controller: _fullNameController,
                  hintText: "Full name",
                  svgSrc: "assets/icons/Profile.svg",
                  textCapitalization: TextCapitalization.words,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Full name is required"),
                    MinLengthValidator(3,
                        errorText: "Enter at least 3 characters"),
                  ]).call,
                ),
                const SizedBox(height: defaultPadding),
                IconTextFormField(
                  controller: _phoneController,
                  hintText: "Phone number",
                  svgSrc: "assets/icons/Call.svg",
                  keyboardType: TextInputType.phone,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Phone number is required"),
                    MinLengthValidator(7, errorText: "Enter a valid number"),
                  ]).call,
                ),
                const SizedBox(height: defaultPadding),
                IconTextFormField(
                  controller: _addressLineController,
                  hintText: "Street address",
                  svgSrc: "assets/icons/Location.svg",
                  textCapitalization: TextCapitalization.words,
                  validator: RequiredValidator(
                    errorText: "Street address is required",
                  ).call,
                ),
                const SizedBox(height: defaultPadding),
                IconTextFormField(
                  controller: _cityController,
                  hintText: "City / State",
                  svgSrc: "assets/icons/Mylocation.svg",
                  textCapitalization: TextCapitalization.words,
                  validator: RequiredValidator(
                    errorText: "City is required",
                  ).call,
                ),
                const SizedBox(height: defaultPadding),
                IconTextFormField(
                  controller: _zipController,
                  hintText: "Zip code",
                  svgSrc: "assets/icons/Scan.svg",
                  textInputAction: TextInputAction.done,
                  validator: RequiredValidator(
                    errorText: "Zip code is required",
                  ).call,
                ),
                const SizedBox(height: defaultPadding / 2),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text("Set as default address"),
                  value: _isDefault,
                  onChanged: (value) =>
                      setState(() => _isDefault = value ?? false),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(_isEditing ? "Save changes" : "Add address"),
            ),
          ),
        ),
      ],
    );
  }
}
