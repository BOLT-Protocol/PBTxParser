import '../model/bitcoin.transaction.model.dart';
import '../model/transaction.type.model.dart';

class DecodeRepository {
  Future<List<String>> decodeBtcTransaction(String hexData) async {
    print('repository: decode');
    BitcoinTransaction bitcoinTransaction =
        await BitcoinTransaction.decode(hexData);

    return bitcoinTransaction == null
        ? [Transaction.unknown.type]
        : [
            bitcoinTransaction.type,
            bitcoinTransaction.signed.toString(),
            bitcoinTransaction.detail,
            bitcoinTransaction.pbData
          ];
  }
}
