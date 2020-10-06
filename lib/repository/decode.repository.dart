import '../model/decode.transaction.model.dart';

class DecodeRepository {
  Future<List<String>> decodeTransaction(String hexData) async {
    print('repository: decode');
    List<String> decodedResult = await DecodeTransaction.decode(hexData);

    return decodedResult;
  }
}
