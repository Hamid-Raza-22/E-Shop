import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/empty_state_view.dart';
import '../../../constants.dart';
import '../../../models/address_model.dart';
import '../../../repositories/address_repository.dart';
import '../../search/views/components/search_form.dart';
import 'components/address_card.dart';
import 'components/address_form_sheet.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final AddressRepository _repository = AddressRepository.instance;
  final TextEditingController _searchController = TextEditingController();

  /// A notifier (instead of setState) keeps the search field out of the rebuild
  /// scope, so typing only rebuilds the address list.
  final ValueNotifier<String> _query = ValueNotifier<String>("");

  @override
  void dispose() {
    _searchController.dispose();
    _query.dispose();
    super.dispose();
  }

  List<AddressModel> _filteredAddresses() {
    final term = _query.value.trim().toLowerCase();
    final addresses = _repository.addresses;
    if (term.isEmpty) return addresses;
    return addresses
        .where((address) =>
            address.label.toLowerCase().contains(term) ||
            address.fullName.toLowerCase().contains(term) ||
            address.formattedAddress.toLowerCase().contains(term))
        .toList();
  }

  Future<void> _openAddressForm({AddressModel? address}) async {
    final result = await customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.9,
      child: AddressFormSheet(address: address),
    );

    if (result is! AddressFormResult || !mounted) return;

    if (address == null) {
      _repository.add(
        label: result.label,
        fullName: result.fullName,
        phone: result.phone,
        addressLine: result.addressLine,
        city: result.city,
        zipCode: result.zipCode,
        isDefault: result.isDefault,
      );
      _showSnackBar("Address added");
    } else {
      _repository.update(address.copyWith(
        label: result.label,
        fullName: result.fullName,
        phone: result.phone,
        addressLine: result.addressLine,
        city: result.city,
        zipCode: result.zipCode,
      ));
      // Default flag is owned by the repository so only one address holds it.
      if (result.isDefault && !address.isDefault) {
        _repository.setDefault(address.id);
      }
      _showSnackBar("Address updated");
    }
  }

  Future<void> _confirmDelete(AddressModel address) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete address"),
        content: Text("Delete \"${address.label}\" from your address book?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;
    _repository.delete(address.id);
    _showSnackBar("Address deleted");
  }

  void _handleAction(AddressModel address, AddressAction action) {
    switch (action) {
      case AddressAction.setDefault:
        _repository.setDefault(address.id);
        _showSnackBar("\"${address.label}\" is now your default address");
      case AddressAction.edit:
        _openAddressForm(address: address);
      case AddressAction.delete:
        _confirmDelete(address);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address")),
      body: SafeArea(
        child: Column(
          children: [
            // Kept outside the rebuild scope on purpose.
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SearchForm(
                controller: _searchController,
                hintText: "Find an address...",
                onChanged: (value) => _query.value = value ?? "",
                onTabFilter: () => _openAddressForm(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: _AddNewAddressButton(press: () => _openAddressForm()),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([_repository, _query]),
                builder: (context, _) {
                  final addresses = _filteredAddresses();
                  final isSearching = _query.value.trim().isNotEmpty;

                  if (addresses.isEmpty) {
                    return EmptyStateView(
                      title: isSearching
                          ? "No matching address"
                          : "No saved addresses",
                      description: isSearching
                          ? "Try a different search term or add a new address."
                          : "Add a delivery address so we know where to send your orders.",
                      actionLabel: "Add new address",
                      onAction: () => _openAddressForm(),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(defaultPadding),
                    itemCount: addresses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: defaultPadding),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return AddressCard(
                        address: address,
                        press: () => _openAddressForm(address: address),
                        onAction: (action) => _handleAction(address, action),
                      );
                    },
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

/// Dashed-style "Add new address" button from the design.
class _AddNewAddressButton extends StatelessWidget {
  const _AddNewAddressButton({required this.press});

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: press,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        ),
        icon: SvgPicture.asset(
          "assets/icons/Location.svg",
          height: 24,
          colorFilter: ColorFilter.mode(
            Theme.of(context).textTheme.bodyLarge!.color!,
            BlendMode.srcIn,
          ),
        ),
        label: const Text("Add new address"),
      ),
    );
  }
}
