import 'pb.contract.model.dart';

class EthereumTransaction {
  static const String FieldName_Type = "type";
  static const String FieldName_GasPrice = "gas_price"; // Eth
  static const String FieldName_GasLimit = "gas_limit"; // Eth
  static const String FieldName_Nonce = "nonce"; // Eth

  int nonce;
  BigInt gasPrice;
  BigInt gasLimit;
  String to;
  BigInt value;
  PBContractData contractData;
  String s;
  String r;
  int v;

  // TODO ETHEREUM Transaction decode
  static EthereumTransaction decode(List<dynamic> rlpdecoded) {
    print('rlpdecoded: $rlpdecoded');
  }
}
