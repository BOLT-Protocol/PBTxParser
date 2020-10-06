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
    try {
      List<dynamic> rlpdecoded = rlp.decode(buffer);
      EthereumTransaction.decode(rlpdecoded);
      return [TransactionType.ethereum.type];
    } catch (e) {
      print(e);
      error = e;
    }
    BitcoinTransaction bitcoinTransaction;
    if (error != null) {
      bitcoinTransaction = await BitcoinTransaction.decode(hex);
    }
    if (bitcoinTransaction != null) {
      return [
        bitcoinTransaction.type,
        bitcoinTransaction.signed.toString(),
        bitcoinTransaction.signedPubkey,
        bitcoinTransaction.detail,
        bitcoinTransaction.pbData
      ];
    }
    // TODO RIPPLE Transaction decode
    return [TransactionType.unknown.type];
  }
}
