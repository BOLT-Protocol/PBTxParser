import 'dart:typed_data';
import 'package:convert/convert.dart' show hex;

import 'cointype.model.dart';

import '../utils/utils.dart';
import '../utils/extensions.dart';
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
    // TEST
    // Uint8List data = toBuffer(
    //     'f484695543c384800000018716126af09898008480000001870a5fb243000a0094a21b6513cb69eadb105388027ee2f05006692b2001');
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
          // TODO ADDRESS
          this.address = hex.encode(result[3]);
          break;
        case PBContract.swap:
          this.fromCoinType = hex.encode(result[1]);
          this.fromAmount = decodeBigInt(result[2]);
          this.toCoinType = hex.encode(result[3]);
          this.toAmount = decodeBigInt(result[4]);
          // TODO
          if (decodeBigInt(result[3]).toInt() == 0x80000001 ||
              decodeBigInt(result[3]).toInt() ==
                  0x80000000) //CoinType.bitcoin.value)
          {
            this.toAddress = (result[5] as List<int>).decodeScript()["address"];
            if (this.toAddress == null)
              this.toAddress = "0x${hex.encode(result[5])}";
          } else if (decodeBigInt(result[3]).toInt() ==
              0x8000003C) //CoinType.ethereum.value)
            this.toAddress = "0x${hex.encode(result[5])}";
          // TODO Ripple
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
          $FieldName_Address: ${this.address},""";
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
          $FieldName_Withdraw: ${this.withdraw},""";
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
          $FieldName_Withdraw: ${this.withdraw},""";
        break;
      default:
        data = "";
        break;
    }
    return data;
  }
}
