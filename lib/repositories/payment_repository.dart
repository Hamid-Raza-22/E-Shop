import 'package:flutter/foundation.dart';

import '../models/payment_card_model.dart';

/// In-memory saved cards + the selected checkout payment option.
///
/// Only the last four digits are ever stored — full card numbers are
/// deliberately never kept, since this demo has no PCI-compliant backend.
class PaymentRepository extends ChangeNotifier {
  PaymentRepository._() {
    _seedDemoCards();
  }

  static final PaymentRepository instance = PaymentRepository._();

  final List<PaymentCardModel> _cards = [];
  int _sequence = 0;

  String? _selectedCardId;
  PaymentOption _selectedOption = PaymentOption.card;

  /// CVV typed for the currently selected card. Never persisted anywhere.
  String _cvv = "";

  List<PaymentCardModel> get cards => List.unmodifiable(_cards);

  bool get isEmpty => _cards.isEmpty;

  PaymentOption get selectedOption => _selectedOption;

  String? get selectedCardId => _selectedCardId;

  PaymentCardModel? get selectedCard =>
      _cards.where((card) => card.id == _selectedCardId).firstOrNull;

  String get cvv => _cvv;

  bool get isCvvValid => _cvv.length == 3 || _cvv.length == 4;

  /// True when the current selection is enough to place an order.
  bool get canCheckout => _selectedOption != PaymentOption.card
      ? true
      : selectedCard != null && isCvvValid;

  String get selectionLabel {
    if (_selectedOption != PaymentOption.card) return _selectedOption.label;
    final card = selectedCard;
    return card == null ? "Select a card" : "•••• ${card.last4Digits}";
  }

  void selectOption(PaymentOption option) {
    if (_selectedOption == option) return;
    _selectedOption = option;
    _cvv = "";
    notifyListeners();
  }

  void selectCard(String id) {
    if (_selectedOption == PaymentOption.card && _selectedCardId == id) return;
    _selectedOption = PaymentOption.card;
    _selectedCardId = id;
    // A CVV belongs to a single card, so it never carries over.
    _cvv = "";
    notifyListeners();
  }

  void setCvv(String value) {
    final wasValid = isCvvValid;
    _cvv = value.trim();
    // Only rebuild when the checkout button's enabled state can change,
    // so the field isn't rebuilt on every keystroke.
    if (wasValid != isCvvValid) notifyListeners();
  }

  /// Called once an order is placed so the CVV doesn't linger in memory.
  void clearCvv() {
    if (_cvv.isEmpty) return;
    _cvv = "";
    notifyListeners();
  }

  /// [cardNumber] is only used to derive the last four digits.
  void addCard({
    required String holderName,
    required String cardNumber,
    required String expiryDate,
  }) {
    _sequence++;
    final digits = cardNumber.replaceAll(RegExp(r"\D"), "");
    final last4 = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : digits.padLeft(4, "0");

    final card = PaymentCardModel(
      id: "card_$_sequence",
      holderName: holderName,
      last4Digits: last4,
      expiryDate: expiryDate,
    );
    _cards.add(card);
    _selectedCardId = card.id;
    _selectedOption = PaymentOption.card;
    notifyListeners();
  }

  void removeCard(String id) {
    _cards.removeWhere((card) => card.id == id);
    if (_selectedCardId == id) {
      _selectedCardId = _cards.isEmpty ? null : _cards.first.id;
    }
    notifyListeners();
  }

  void _seedDemoCards() {
    _sequence++;
    _cards.add(PaymentCardModel(
      id: "card_$_sequence",
      holderName: "Sepide Moqadam",
      last4Digits: "4242",
      expiryDate: "09/27",
    ));
    _selectedCardId = _cards.first.id;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
