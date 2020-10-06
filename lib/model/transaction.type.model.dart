enum Transaction { ripple, bitcoin, ethereum, unknown }

extension TransactionExt on Transaction {
  String get type {
    switch (this) {
      case Transaction.ripple:
        return "Ripple";
        break;
      case Transaction.bitcoin:
        return "Bitcoin";
        break;
      case Transaction.ethereum:
        return "Ethereum";
        break;
      default:
        return "Unknown";
        break;
    }
  }
}
