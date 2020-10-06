enum TransactionType { ripple, bitcoin, ethereum, unknown }

extension TransactionTypeExt on TransactionType {
  String get type {
    switch (this) {
      case TransactionType.ripple:
        return "Ripple";
        break;
      case TransactionType.bitcoin:
        return "Bitcoin";
        break;
      case TransactionType.ethereum:
        return "Ethereum";
        break;
      default:
        return "Unknown";
        break;
    }
  }
}
