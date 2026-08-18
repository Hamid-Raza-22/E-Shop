import 'package:flutter/foundation.dart';

import '../models/product_model.dart';

class WalletTransaction {
  const WalletTransaction({
    required this.date,
    required this.amount,
    required this.isReturn,
    required this.products,
  });

  final DateTime date;
  final double amount;

  /// True when money came back into the wallet (refund/return).
  final bool isReturn;
  final List<ProductModel> products;
}

/// In-memory wallet balance + transaction history.
class WalletRepository extends ChangeNotifier {
  WalletRepository._() {
    _seedDemoHistory();
  }

  static final WalletRepository instance = WalletRepository._();

  double _balance = 384.90;
  final List<WalletTransaction> _transactions = [];

  double get balance => _balance;

  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);

  bool get isEmpty => _transactions.isEmpty;

  /// Tops the wallet up and records the transaction.
  void topUp(double amount) {
    if (amount <= 0) return;
    _balance += amount;
    _transactions.insert(
      0,
      WalletTransaction(
        date: DateTime.now(),
        amount: amount,
        isReturn: true,
        products: const [],
      ),
    );
    notifyListeners();
  }

  /// Spends from the wallet. Returns false when the balance is insufficient.
  bool spend(double amount, {List<ProductModel> products = const []}) {
    if (amount <= 0 || amount > _balance) return false;
    _balance -= amount;
    _transactions.insert(
      0,
      WalletTransaction(
        date: DateTime.now(),
        amount: amount,
        isReturn: false,
        products: products,
      ),
    );
    notifyListeners();
    return true;
  }

  void _seedDemoHistory() {
    final now = DateTime.now();
    _transactions.addAll([
      WalletTransaction(
        date: now.subtract(const Duration(days: 3)),
        amount: 129,
        isReturn: false,
        products: [demoPopularProducts[0], demoPopularProducts[1]],
      ),
      WalletTransaction(
        date: now.subtract(const Duration(days: 11)),
        amount: 420,
        isReturn: true,
        products: [demoPopularProducts[0]],
      ),
      WalletTransaction(
        date: now.subtract(const Duration(days: 24)),
        amount: 800,
        isReturn: false,
        products: [demoPopularProducts[1]],
      ),
    ]);
  }
}
