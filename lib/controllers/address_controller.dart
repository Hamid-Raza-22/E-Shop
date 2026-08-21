import 'package:get/get.dart';

import '../models/address_model.dart';

/// In-memory address book. Changes persist for the lifetime of the app run.
class AddressController extends GetxController {
  AddressController() {
    _seedDemoAddresses();
  }

  static AddressController get to => Get.find<AddressController>();

  final List<AddressModel> _addresses = [];
  int _sequence = 0;

  List<AddressModel> get addresses => List.unmodifiable(_addresses);

  bool get isEmpty => _addresses.isEmpty;

  AddressModel? get defaultAddress =>
      _addresses.where((address) => address.isDefault).firstOrNull;

  void add({
    required String label,
    required String fullName,
    required String phone,
    required String addressLine,
    required String city,
    required String zipCode,
    bool isDefault = false,
  }) {
    _sequence++;
    // First address always becomes the default, otherwise honour the flag.
    final shouldBeDefault = isDefault || _addresses.isEmpty;
    if (shouldBeDefault) _clearDefaultFlag();

    _addresses.add(AddressModel(
      id: "address_$_sequence",
      label: label,
      fullName: fullName,
      phone: phone,
      addressLine: addressLine,
      city: city,
      zipCode: zipCode,
      isDefault: shouldBeDefault,
    ));
    update();
  }

  /// Named `updateAddress` (not `update`) because `GetxController.update()` is
  /// the rebuild trigger and cannot be overloaded.
  void updateAddress(AddressModel updated) {
    final index = _addresses.indexWhere((address) => address.id == updated.id);
    if (index == -1) return;
    _addresses[index] = updated;
    update();
  }

  void delete(String id) {
    final removedWasDefault =
        _addresses.where((address) => address.id == id).firstOrNull?.isDefault ??
            false;
    _addresses.removeWhere((address) => address.id == id);

    // Never leave the book without a default address.
    if (removedWasDefault && _addresses.isNotEmpty) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    update();
  }

  void setDefault(String id) {
    _clearDefaultFlag();
    final index = _addresses.indexWhere((address) => address.id == id);
    if (index == -1) return;
    _addresses[index] = _addresses[index].copyWith(isDefault: true);
    update();
  }

  void _clearDefaultFlag() {
    for (var i = 0; i < _addresses.length; i++) {
      if (_addresses[i].isDefault) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
  }

  void _seedDemoAddresses() {
    add(
      label: "Home",
      fullName: "Sepide Moqadam",
      phone: "+1 202 555 0134",
      addressLine: "2148 Straford Park",
      city: "Winchester, KY",
      zipCode: "40391",
      isDefault: true,
    );
    add(
      label: "Office",
      fullName: "Sepide Moqadam",
      phone: "+1 202 555 0177",
      addressLine: "5 Sunshine Coast Hwy",
      city: "Gibsons, BC",
      zipCode: "V0N 1V8",
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
