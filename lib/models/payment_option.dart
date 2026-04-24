enum PaymentOption {
  cash,
  gcash,
}

extension PaymentOptionX on PaymentOption {
  String get label {
    switch (this) {
      case PaymentOption.cash:
        return 'Cash';
      case PaymentOption.gcash:
        return 'GCash';
    }
  }
}
