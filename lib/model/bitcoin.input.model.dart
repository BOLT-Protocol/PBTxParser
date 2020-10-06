import 'dart:typed_data';

import 'package:decimal/decimal.dart';

import '../utils/extensions.dart';
import 'package:convert/convert.dart' show hex;

class Input {
  static const String FieldName_Addresses = "addresses";
  static const String FieldName_Age = "age";
  static const String FieldName_OutputIndex = "output_index";
  static const String FieldName_OutputValue = "output_value";
  static const String FieldName_PreTxid = "prev_txid";
  static const String FieldName_ScriptType = "script_type";
  static const String FieldName_Sequence = "sequence";
  static const String FieldName_Script = "script";
  static const String FieldName_Witness = "witness";
  List<String> addresses;
  int vout; // output_index
  BigInt value; // output_value
  String txid; // pre_hash
  ScriptType type;
  int sequence;
  String script;
  List<String> witness;
  String pubkey;
  HashType hashType;
  bool signed;

  Input(
      {List<String> addresses,
      int vout,
      BigInt value,
      String txid,
      ScriptType type,
      int sequence,
      String script,
      List<String> witness,
      String pubkey,
      HashType hashType,
      bool signed})
      : addresses = addresses,
        vout = vout,
        value = value,
        txid = txid,
        type = type,
        sequence = sequence,
        script = script,
        witness = witness,
        pubkey = pubkey,
        hashType = hashType,
        signed = signed;

  Uint8List get reservedTxid =>
      Uint8List.fromList(hex.decode(this.txid).reversed.toList());
  Uint8List get voutInBuffer =>
      Uint8List(4)..buffer.asByteData().setUint32(0, this.vout, Endian.little);
  Uint8List get sequenceInBuffer => Uint8List(4)
    ..buffer.asByteData().setUint32(0, this.sequence, Endian.little);
  Uint8List get valueInBuffer => Uint8List(8)
    ..buffer.asByteData().setUint64(0, this.value.toInt(), Endian.little);
  Uint8List get hashTypeInBuffer => Uint8List(4)
    ..buffer.asByteData().setUint32(0, hashType.value, Endian.little);

  String get text {
    if (this.addresses != null) {
      String addresses = "";
      this.addresses.asMap().forEach((index, address) {
        addresses += """
          $address${index != this.addresses.length - 1 ? "," : ""}""";
      });
      addresses = """[
            $addresses
            ]""";
    }
    if (this.witness != null) {
      String witness = "";
      this.witness.asMap().forEach((index, wit) {
        witness += """
          ${index != 0 ? '            ' : ''}$wit${index != this.witness.length - 1 ? ",\n" : ""}""";
      });
      witness = """[
            $witness
            ]""";
    }
    String data;
    print('WARNING: ${this.script}');
    if (this.script != null && this.witness != null)
      data = """
          {
              $FieldName_Addresses: $addresses,
              $FieldName_OutputIndex: ${this.vout},
              $FieldName_OutputValue: ${this.value},
              $FieldName_PreTxid: ${this.txid},
              $FieldName_ScriptType: ${this.type.name},
              $FieldName_Script: ${this.script},
              $FieldName_Witness: $witness,
              $FieldName_Sequence: ${this.sequence}
          },""";
    else if (this.script != null || this.witness != null)
      data = """
          {
              $FieldName_Addresses: $addresses,
              $FieldName_OutputIndex: ${this.vout},
              $FieldName_OutputValue: ${this.value},
              $FieldName_PreTxid: ${this.txid},
              $FieldName_ScriptType: ${this.type.name},
              ${this.script != null ? FieldName_Script : FieldName_Witness}: ${this.script != null ? this.script : witness},
              $FieldName_Sequence: ${this.sequence}
          },""";
    else
      data = """
          {
            $FieldName_Addresses: $addresses,
            $FieldName_OutputIndex: ${this.vout},
            $FieldName_OutputValue: ${this.value},
            $FieldName_PreTxid: ${this.txid},
            $FieldName_ScriptType: ${this.type.name},
            $FieldName_Sequence: ${this.sequence}
          },""";
    return data;
  }

  Map<String, dynamic> get map {
    Map<String, dynamic> data = {
      FieldName_Addresses: this.addresses,
      FieldName_OutputIndex: this.vout,
      FieldName_OutputValue: this.value,
      FieldName_PreTxid: this.txid,
      FieldName_ScriptType: this.type.name,
      FieldName_Sequence: this.sequence
    };
    if (this.script != null && this.witness != null)
      data = {
        ...data,
        FieldName_Script: this.script,
        FieldName_Witness: this.witness
      };
    if (this.script != null || this.witness != null)
      data = {
        ...data,
        this.script != null ? FieldName_Script : FieldName_Witness:
            this.script != null ? this.script : this.witness
      };
    return data;
  }
}

class Converter {
  // NOTE: calculate wei by 10^18
  static BigInt btcInSatoshi = BigInt.from(1e8);

  //1 BTC == 100,000,000 satoshi
  static double toBtc(BigInt value) {
    return value / btcInSatoshi;
  }

  static BigInt toSatoshi(Decimal btc) {
    return BigInt.from((btc * Decimal.parse('100000000')).toDouble());
  }
}
