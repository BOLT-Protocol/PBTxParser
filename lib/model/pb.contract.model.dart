import 'dart:typed_data';
import 'package:PBTxParser/utils/utils.dart';
import 'package:convert/convert.dart' show hex;

import '../utils/rlp.dart' as rlp;

enum PBContract { deposit, withdraw, transfer, swap, donate, unknown }

extension PBContractExt on PBContract {
  int get functionCode {
    switch (this) {
      case PBContract.deposit:
        return 0x48c73f68;
        break;
      case PBContract.withdraw:
        return 0x855511cc;
        break;
      case PBContract.transfer:
        return 0xb483afd3;
        break;
      case PBContract.swap:
        return 0x695543c3;
        break;
      case PBContract.donate:
        return 0x86ba0d37;
        break;
      default:
        return null;
        break;
    }
  }

  String get functionName {
    switch (this) {
      case PBContract.deposit:
        return 'Deposit';
        break;
      case PBContract.withdraw:
        return 'Withdraw';
        break;
      case PBContract.transfer:
        return 'Transfer';
        break;
      case PBContract.swap:
        return 'Swap';
        break;
      case PBContract.donate:
        return 'Donate';
        break;
      default:
        return null;
        break;
    }
  }
}

class PBContractData {
  static const String FieldName_Contract = 'contract';
  static const String FieldName_Function = 'function';
  static const String FieldName_FunctionCode = 'code';
  static const String FieldName_FunctionName = 'name';
  static const String FieldName_From = 'from_cointype';
  static const String FieldName_FromAmount = 'from_amount';
  static const String FieldName_To = 'to_cointype';
  static const String FieldName_ToAmount = 'to_expect_amount';
  static const String FieldName_ToAddress = 'to_address';
  static const String FieldName_CoinType = 'cointype';
  static const String FieldName_Amount = 'amount';
  static const String FieldName_Address = 'address';
  static const String FieldName_Withdraw = 'withdraw';
  PBContract pbContract;
  String contractAddress;
  String coinType;
  BigInt amount;
  BigInt fromAmount;
  BigInt toAmount;
  String address;
  String fromCoinType;
  String toCoinType;
  String toAddress;
  int withdraw;

  PBContractData(String contractAddress, Uint8List data)
      : this.contractAddress = contractAddress {
    List<dynamic> result;
    try {
      print(
          'contractAddress: $contractAddress ,data: ${hex.encode(data.last == 1 ? data.sublist(0, data.length - 1) : data)}');
      result = rlp.decode(data);
      print('result: $result');
    } catch (e) {
      try {
        this.withdraw = data.last;
        print(
            'contractAddress: $contractAddress ,data: ${hex.encode(data.last == 1 ? data.sublist(0, data.length - 1) : data)}');
        result = rlp.decode(data.sublist(0, data.length - 1));
        print('result: $result');
      } catch (e) {
        this.pbContract = PBContract.unknown;
        print('ERROR result: $e');
      }
    }
    if (result != null) {
      this.pbContract = PBContract.values.firstWhere((element) =>
          element.functionCode == decodeBigInt(result.first).toInt());
      switch (this.pbContract) {
        case PBContract.deposit:
          break;
        case PBContract.withdraw:
        case PBContract.transfer:
          this.coinType = hex.encode(result[1]);
          this.amount = decodeBigInt(result[2]);
          this.address = hex.encode(result[3]);
          break;
        case PBContract.swap:
          this.fromCoinType = hex.encode(result[1]);
          this.fromAmount = decodeBigInt(result[2]);
          this.toCoinType = hex.encode(result[3]);
          this.toAmount = decodeBigInt(result[4]);
          this.toAddress = hex.encode(result[5]);
          break;
        case PBContract.donate:
          break;
        case PBContract.unknown:
          break;
      }
      for (dynamic data in result) {
        print(hex.encode(data));
      }
    }
  }

  String get text {
    String data;
    switch (this.pbContract) {
      case PBContract.deposit:
      case PBContract.donate:
        data = "";
        break;
      case PBContract.withdraw:
        data = """
        $FieldName_Contract: ${this.contractAddress},
          $FieldName_Function: {
            $FieldName_FunctionCode: ${hex.encode(encodeBigInt(BigInt.from(this.pbContract.functionCode)))},
            $FieldName_FunctionName: ${this.pbContract.functionName},
          },
          $FieldName_CoinType: ${this.coinType},
          $FieldName_Amount: ${this.amount},
          $FieldName_Address: ${this.address},
        """;
        break;
      case PBContract.transfer:
        data = """
        $FieldName_Contract: ${this.contractAddress},
          $FieldName_Contract: {
            $FieldName_FunctionCode: ${hex.encode(encodeBigInt(BigInt.from(this.pbContract.functionCode)))},
            $FieldName_FunctionName: ${this.pbContract.functionName},
          },
          $FieldName_CoinType: ${this.coinType},
          $FieldName_Amount: ${this.amount},
          $FieldName_Address: ${this.address},
          $FieldName_Withdraw: ${this.withdraw},
        """;
        break;
      case PBContract.swap:
        data = """
    $FieldName_Contract: ${this.contractAddress},
          $FieldName_Contract: {
            $FieldName_FunctionCode: ${hex.encode(encodeBigInt(BigInt.from(this.pbContract.functionCode)))},
            $FieldName_FunctionName: ${this.pbContract.functionName},
          },
          $FieldName_From: ${this.fromCoinType},
          $FieldName_FromAmount: ${this.fromAmount},
          $FieldName_To: ${this.toCoinType},
          $FieldName_ToAmount: ${this.toAmount},
          $FieldName_ToAddress: ${this.toAddress},
          $FieldName_Withdraw: ${this.withdraw},
        """;
        break;
      default:
        data = "";
        break;
    }
    return data;
  }
}
