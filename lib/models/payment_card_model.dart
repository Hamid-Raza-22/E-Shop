class PaymentCardModel {
  const PaymentCardModel({
    required this.id,
    required this.holderName,
    required this.last4Digits,
    required this.expiryDate,
  });

  final String id, holderName, last4Digits, expiryDate;
}

/// Non-card payment options offered at checkout.
enum PaymentOption { card, cashOnDelivery, wallet }

extension PaymentOptionInfo on PaymentOption {
  String get label {
    switch (this) {
      case PaymentOption.card:
        return "Credit / Debit card";
      case PaymentOption.cashOnDelivery:
        return "Cash on delivery";
      case PaymentOption.wallet:
        return "Shoplon wallet";
    }
  }

  String get svgSrc {
    switch (this) {
      case PaymentOption.card:
        return "assets/icons/card.svg";
      case PaymentOption.cashOnDelivery:
        return "assets/icons/Cash.svg";
      case PaymentOption.wallet:
        return "assets/icons/Wallet.svg";
    }
  }
}
