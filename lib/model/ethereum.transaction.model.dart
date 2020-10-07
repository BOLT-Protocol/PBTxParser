import 'dart:convert';

import 'package:PBTxParser/utils/utils.dart';
import 'package:convert/convert.dart' show hex;

import 'pb.contract.model.dart';
import 'ethereum.unit.model.dart';
import 'transaction.type.model.dart';

class EthereumTransaction {
  static const String FieldName_Type = "type";
  static const String FieldName_Detail = "detail";
  static const String FieldName_Network = "network";
  static const String FieldName_Nonce = "nonce"; // Eth
  static const String FieldName_GasPrice = "gas_price"; // Eth
  static const String FieldName_GasLimit = "gas_limit"; // Eth
  static const String FieldName_TO = "to";
  static const String FieldName_Value = "value";
  static const String FieldName_Data = "data";
  static const String FieldName_PocketBank = "pocket_bank";
  static const String FieldName_V = "v";
  static const String FieldName_R = "r";
  static const String FieldName_S = "s";

  int nonce;
  BigInt gasPrice;
  BigInt gasLimit;
  String to;
  BigInt value;
  String data;
  PBContractData contractData;
  int v;
  BigInt r;
  BigInt s;
  bool _signed;
  String _pubkey;
  int chainId;
  String _type = TransactionType.ethereum.type;

  String get type => "Type: $_type";
  String get signed => "Signed: $_signed";
  String get signedPubkey => this._signed && this._pubkey != null
      ? "Signed Pubkic Key: $_pubkey"
      : null;
  String get detail {
    String data = """
$FieldName_Detail: {
      $FieldName_Network: ${EthereumNetwork.values.firstWhere((element) => element.chainId == this.chainId).name},
      $FieldName_Nonce: ${this.nonce},
      $FieldName_GasPrice: ${Converter.toGwei(this.gasPrice, EthereumUnit.wei)} Gwei,
      $FieldName_GasLimit: ${this.gasLimit},
      $FieldName_TO: ${this.to}
      $FieldName_Value: ${Converter.toEther(this.value, EthereumUnit.wei)} ETH,
      $FieldName_Data: ${this.data},
      $FieldName_V: ${this.v},
      $FieldName_R: 0x${hex.encode(encodeBigInt(this.r))},
      $FieldName_S: 0x${hex.encode(encodeBigInt(this.s))}
}""";
    return data;
  }

  String get pbData => this.contractData != null
      ? """$FieldName_PocketBank: {
      ${this.contractData.text}
      }
  """
      : null;

  EthereumTransaction();
  static EthereumTransaction decode(List<dynamic> rlpdecoded) {
    print('rlpdecoded: $rlpdecoded');
    EthereumTransaction transaction = EthereumTransaction();
    try {
      transaction.nonce = decodeBigInt(rlpdecoded[0]).toInt();
      print('transaction.nonce: ${transaction.nonce}');
    } catch (e) {
      print(e);
      return null;
    }
    try {
      transaction.gasPrice = decodeBigInt(rlpdecoded[1]);
      print('transaction.gasPrice: ${transaction.gasPrice}');
    } catch (e) {
      print(e);
      return null;
    }
    try {
      transaction.gasLimit = decodeBigInt(rlpdecoded[2]);
      print('transaction.gasLimit: ${transaction.gasLimit}');
    } catch (e) {
      print(e);
      return null;
    }
    try {
      transaction.to = "0x${hex.encode(rlpdecoded[3])}";
      print('transaction.to: ${transaction.to}');
    } catch (e) {
      print(e);
      return null;
    }
    try {
      transaction.value = decodeBigInt(rlpdecoded[4]);
      print('transaction.value: ${transaction.value}');
    } catch (e) {
      print(e);
      return null;
    }

    var error;
    String data;
    try {
      data = hex.encode(rlpdecoded[5]);
      print('transaction.data: ${transaction.data}');
    } catch (e) {
      error = e;
    }
    if (error == null) {
      try {
        transaction.contractData =
            PBContractData(transaction.to, toBuffer(data));
        print('transaction.contractData: ${transaction.contractData}');
      } catch (e) {
        error = e;
      }
    } else {
      try {
        data = utf8.decode(rlpdecoded[5]);
        print('transaction.data: ${transaction.data}');
      } catch (e) {
        error = e;
        return null;
      }
    }
    transaction.data = data;
    try {
      transaction.v = decodeBigInt(rlpdecoded[6]).toInt();
      print('transaction.v: ${transaction.v}');
    } catch (e) {
      print(e);
      return null;
    }
    try {
      transaction.r = decodeBigInt(rlpdecoded[7]);
      print('transaction.r: ${transaction.r}');
    } catch (e) {
      print(e);
      return null;
    }

    try {
      transaction.s = decodeBigInt(rlpdecoded[8]);
      print('transaction.s: ${transaction.s}');
    } catch (e) {
      print(e);
      return null;
    }
    transaction.publicKeyRecovery();
    return transaction;
  }

  void publicKeyRecovery() {
    if (this.r == BigInt.zero || this.s == BigInt.zero) {
      this._signed = false;
      return;
    }
    List<int> chainIds = EthereumNetwork.values.map((e) => e.chainId).toList();
    int chainIdV = this.v;
    List<int> recIds = [0, 1, 2, 3];
    int recId;
    int chainId;
    if (chainIdV - 27 > recIds.last) {
      // chainIdV -35 = recId + chainId * 2
      for (int r in recIds) {
        for (int c in chainIds) {
          if (chainIdV - 35 == r + c * 2) {
            recId = r;
            chainId = c;
            this.chainId = chainId;
            this._signed = true;
            print('r: $r');
            print('c: $c');
            break;
          }
        }
        if (recId != null && chainId != null) break;
      }
    } else {
      recId = recIds.firstWhere((element) => element == chainIdV - 27);
      if (recId == null) {
        this._signed = false;
        return;
      }
    }
  }
}

enum EthereumNetwork { mainnet_eth, mainnet_etc, ropsten, rinkeby, mordor }

extension EthereumNetworkExt on EthereumNetwork {
  int get chainId {
    switch (this) {
      case EthereumNetwork.mainnet_eth:
        return 1;
        break;
      case EthereumNetwork.mainnet_etc:
        return 61;
        break;
      case EthereumNetwork.ropsten:
        return 3;
        break;
      case EthereumNetwork.rinkeby:
        return 4;
        break;
      case EthereumNetwork.mordor:
        return 63;
        break;
      default:
        return 0;
        break;
    }
  }

  String get name {
    switch (this) {
      case EthereumNetwork.mainnet_eth:
      case EthereumNetwork.mainnet_etc:
        return 'Mainnet';
        break;
      case EthereumNetwork.ropsten:
        return 'Ropsten';
        break;
      case EthereumNetwork.rinkeby:
        return 'Rinkeby';
        break;
      case EthereumNetwork.mordor:
        return 'Mordor';
        break;
      default:
        return 'Unknown';
        break;
    }
  }
}
