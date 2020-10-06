import '../constant/config.dart';

enum CoinType { ripple, bitcoin, ethereum }

extension CoinTypeExt on CoinType {
  String get string {
    switch (this) {
      case CoinType.ripple:
        return '80000090';
        break;
      case CoinType.bitcoin:
        return '80000000';
        break;
      case CoinType.ethereum:
        return '8000003C';
        break;
      default:
        return null;
        break;
    }
  }

  int get value {
    switch (this) {
      case CoinType.ripple:
        return 0x80000090;
      case CoinType.bitcoin:
        return 0x80000000;
        break;
      case CoinType.ethereum:
        return 0x8000003C;
        break;
      default:
        return null;
        break;
    }
  }

  String get network {
    if (!Config().isTestnet) return "mainnet";
    switch (this) {
      case CoinType.ripple:
      case CoinType.bitcoin:
        return "testnet";
        break;
      case CoinType.ethereum:
        return "ropsten"; // ropsten, rinkeby
        break;
      default:
        return null;
        break;
    }
  }
}
