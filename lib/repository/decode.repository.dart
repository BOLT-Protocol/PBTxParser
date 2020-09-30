import 'package:PBTxParser/model/bitcoin.transaction.model.dart';

class DecodeRepository {
  BitcoinTransaction decodeBtcTransaction(String hexData) {
    print('repository: decode');
    BitcoinTransaction btcTx = BitcoinTransaction.decode(hexData);
    return btcTx;
  }
}
