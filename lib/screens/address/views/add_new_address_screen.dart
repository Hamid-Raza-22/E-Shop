import 'package:flutter/material.dart';

import '../../../models/address_model.dart';
import '../../../controllers/address_controller.dart';
import 'components/address_form_sheet.dart';

/// Full-screen add/edit address route.
///
/// Reuses the same validated [AddressFormSheet] as the bottom sheet and just
/// supplies its own submit handler so no form logic is duplicated.
class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key, this.address});

  /// When non-null the screen edits an existing address.
  final AddressModel? address;

  void _save(BuildContext context, AddressFormResult result) {
    final repository = AddressController.to;
    final existing = address;

    if (existing == null) {
      repository.add(
        label: result.label,
        fullName: result.fullName,
        phone: result.phone,
        addressLine: result.addressLine,
        city: result.city,
        zipCode: result.zipCode,
        isDefault: result.isDefault,
      );
    } else {
      repository.updateAddress(existing.copyWith(
        label: result.label,
        fullName: result.fullName,
        phone: result.phone,
        addressLine: result.addressLine,
        city: result.city,
        zipCode: result.zipCode,
      ));
      // The default flag is owned by the repository so only one can hold it.
      if (result.isDefault && !existing.isDefault) {
        repository.setDefault(existing.id);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(existing == null ? "Address added" : "Address updated"),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AddressFormSheet(
          address: address,
          onSubmit: (result) => _save(context, result),
        ),
      ),
    );
  }
}
