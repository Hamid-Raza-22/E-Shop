import 'package:get/get.dart';

import '../../models/customer_model.dart';
import '../../services/customer_service.dart';

/// Customer list for the dashboard, with search and blocking.
class AdminCustomersController extends GetxController {
  AdminCustomersController({CustomerService? service})
      : _service = service ?? Get.find<CustomerService>();

  final CustomerService _service;

  static AdminCustomersController get to =>
      Get.find<AdminCustomersController>();

  final RxList<CustomerModel> _all = <CustomerModel>[].obs;
  final RxString _query = "".obs;
  final RxBool _showBlockedOnly = false.obs;
  final RxnString _error = RxnString();

  String get query => _query.value;

  bool get showBlockedOnly => _showBlockedOnly.value;

  String? get error => _error.value;

  int get totalCount => _all.length;

  int get blockedCount => _all.where((customer) => customer.isBlocked).length;

  double get lifetimeRevenue =>
      _all.fold(0, (sum, customer) => sum + customer.totalSpent);

  List<CustomerModel> get customers {
    final term = _query.value.trim().toLowerCase();

    return _all.where((customer) {
      if (_showBlockedOnly.value && !customer.isBlocked) return false;
      if (term.isEmpty) return true;

      return customer.name.toLowerCase().contains(term) ||
          customer.email.toLowerCase().contains(term) ||
          (customer.phone?.toLowerCase().contains(term) ?? false);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _all.bindStream(_service.watchAll());
  }

  void search(String value) => _query.value = value;

  void toggleBlockedOnly() =>
      _showBlockedOnly.value = !_showBlockedOnly.value;

  Future<bool> toggleBlocked(CustomerModel customer) => _guard(
        () => _service.setBlocked(
          customer.id,
          isBlocked: !customer.isBlocked,
        ),
      );

  Future<bool> _guard(Future<void> Function() action) async {
    _error.value = null;
    try {
      await action();
      return true;
    } catch (exception) {
      _error.value = exception.toString();
      return false;
    }
  }
}
