enum Transaction { RIPPLE, BITCOIN, ETHEREUM }

extension TransactionExt on Transaction {
  String get type {
    switch (this) {
      case Transaction.RIPPLE:
        return "Ripple";
        break;
      case Transaction.BITCOIN:
        return "Bitcoin";
        break;
      case Transaction.ETHEREUM:
        return "Ethereum";
        break;
      default:
        return "Unknown";
        break;
    }
  }
}
