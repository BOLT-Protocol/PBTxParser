import 'package:decimal/decimal.dart';

enum EthereumUnit {
  ///Wei, the smallest and atomic amount of Ether
  wei,

  ///kwei, 1000 wei
  kwei,

  ///Mwei, one million wei
  mwei,

  ///Gwei, one billion wei. Typically a reasonable unit to measure gas prices.
  gwei,

  ///szabo, 10^12 wei or 1 μEther
  szabo,

  ///finney, 10^15 wei or 1 mEther
  finney,

  ether
}

extension EthereumUnitExt on EthereumUnit {
  BigInt get value {
    switch (this) {
      case EthereumUnit.wei:
        return BigInt.one;
        break;
      case EthereumUnit.kwei:
        return BigInt.from(10).pow(3);
        break;
      case EthereumUnit.mwei:
        return BigInt.from(10).pow(6);
        break;
      case EthereumUnit.gwei:
        return BigInt.from(10).pow(9);
        break;
      case EthereumUnit.szabo:
        return BigInt.from(10).pow(12);
        break;
      case EthereumUnit.finney:
        return BigInt.from(10).pow(15);
        break;
      case EthereumUnit.ether:
        return BigInt.from(10).pow(18);
        break;
      default:
        return BigInt.zero;
        break;
    }
  }

  Decimal get decimal {
    return Decimal.parse(this.value.toString());
  }

  String get string {
    switch (this) {
      case EthereumUnit.wei:
        return 'wei';
        break;
      case EthereumUnit.kwei:
        return 'kwei';
        break;
      case EthereumUnit.mwei:
        return 'mwei';
        break;
      case EthereumUnit.gwei:
        return 'gwei';
        break;
      case EthereumUnit.szabo:
        return 'szabo';
        break;
      case EthereumUnit.finney:
        return 'finney';
        break;
      case EthereumUnit.ether:
        return 'ether';
        break;
      default:
        return null;
        break;
    }
  }
}

class Converter {
  static String toEther(dynamic v, EthereumUnit unit) {
    Decimal value;
    if (v is BigInt)
      value = Decimal.fromInt(toWei(v.toString(), unit).toInt());
    else if (v is String)
      value = Decimal.fromInt(toWei(v, unit).toInt());
    else
      print('Wrong type');
    return (value / EthereumUnit.ether.decimal).toString();
  }

  static String toGwei(dynamic v, EthereumUnit unit) {
    Decimal value;
    if (v is BigInt)
      value = Decimal.fromInt(toWei(v.toString(), unit).toInt());
    else if (v is String)
      value = Decimal.fromInt(toWei(v, unit).toInt());
    else
      print('Wrong type');
    return (value / EthereumUnit.gwei.decimal).toString();
  }

  static BigInt toWei(String v, EthereumUnit unit) {
    Decimal value = Decimal.parse(v);
    return BigInt.parse((value * unit.decimal).toString());
  }
}
