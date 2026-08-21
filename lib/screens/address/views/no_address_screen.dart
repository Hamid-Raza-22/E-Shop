import 'package:flutter/material.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/empty_state_view.dart';
import '../../../controllers/address_controller.dart';
import 'components/address_form_sheet.dart';

class NoAddressScreen extends StatelessWidget {
  const NoAddressScreen({super.key});

  Future<void> _addAddress(BuildContext context) async {
    final result = await customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.9,
      child: const AddressFormSheet(),
    );

    if (result is! AddressFormResult || !context.mounted) return;

    AddressController.to.add(
      label: result.label,
      fullName: result.fullName,
      phone: result.phone,
      addressLine: result.addressLine,
      city: result.city,
      zipCode: result.zipCode,
      isDefault: result.isDefault,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address")),
      body: SafeArea(
        child: EmptyStateView(
          title: "No saved addresses",
          description:
              "Add a delivery address so we know where to send your orders.",
          actionLabel: "Add new address",
          onAction: () => _addAddress(context),
        ),
      ),
    );
  }
}
