import 'dart:typed_data';

import 'transaction.type.model.dart';
import 'bitcoin.transaction.model.dart';
import 'ethereum.transaction.model.dart';
import '../utils/rlp.dart' as rlp;
import '../utils/utils.dart';

class DecodeTransaction {
  static Future<List<String>> decode(String hex) async {
    Uint8List buffer;
    if (isHexPrefixed(hex)) {
      try {
        buffer = toBuffer(stripHexPrefix(hex));
      } catch (e) {
        print(e);
        return [TransactionType.unknown.type];
      }
    } else {
      try {
        buffer = toBuffer(hex);
      } catch (e) {
        print(e);
        return [TransactionType.unknown.type];
      }
    }
    var error;
    List<dynamic> rlpdecoded;
    try {
      rlpdecoded = rlp.decode(buffer);
    } catch (e) {
      print(e);
      error = e;
    }
    if (error == null) {
      EthereumTransaction ethereumTransaction =
          EthereumTransaction.decode(rlpdecoded);
      if (ethereumTransaction != null) {
        return [
          ethereumTransaction.type,
          ethereumTransaction.signed,
          ethereumTransaction.signedPubkey,
          ethereumTransaction.detail,
          ethereumTransaction.pbData
        ];
      }
      return ["Type: ${TransactionType.unknown.type}"];
    } else {
      BitcoinTransaction bitcoinTransaction;
      bitcoinTransaction = await BitcoinTransaction.decode(hex);
      if (bitcoinTransaction != null) {
        return [
          bitcoinTransaction.type,
          bitcoinTransaction.signed,
          bitcoinTransaction.signedPubkey,
          bitcoinTransaction.detail,
          bitcoinTransaction.pbData
        ];
      } else {
        // TODO RIPPLE Transaction decode
        return ["Type: ${TransactionType.unknown.type}"];
      }
    }
  }
}
