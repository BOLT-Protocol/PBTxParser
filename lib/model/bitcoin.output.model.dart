import 'dart:typed_data';

import '../utils/extensions.dart';

class Output {
  static const String FieldName_Addresses = "addresses";
  static const String FieldName_DataHex = "data_hex";
  static const String FieldName_Script = "script";
  static const String FieldName_ScriptType = "script_type";
  static const String FieldName_Value = "value";

  List<String> addresses;
  String script;
  ScriptType type;
  BigInt value;
  String dataHex;

  Uint8List get valueInBuffer => Uint8List(8)
    ..buffer.asByteData().setUint64(0, this.value.toInt(), Endian.little);

  Output({
    List<String> addresses,
    String script,
    ScriptType type,
    BigInt value,
    String dataHex,
  })  : addresses = addresses,
        script = script,
        type = type,
        value = value,
        dataHex = dataHex;

  Map<String, dynamic> get map {
    Map<String, dynamic> data = {
      FieldName_Addresses: this.addresses,
      FieldName_Script: this.script,
      FieldName_ScriptType: this.type.name,
      FieldName_Value: this.value
    };
    if (this.addresses == null && this.dataHex != null)
      data = data = {
        FieldName_Addresses: this.addresses,
        FieldName_DataHex: this.dataHex,
        FieldName_Script: this.script,
        FieldName_ScriptType: this.type.name,
        FieldName_Value: this.value
      };
    return data;
  }

  String get text {
    String addresses = "";
    String data;
    if (this.addresses != null) {
      this.addresses.asMap().forEach((index, address) {
        addresses += """
          $address${index != this.addresses.length - 1 ? "," : ""}""";
      });
      addresses = """[
            $addresses
            ]""";
      data = """
          {
              $FieldName_Addresses: $addresses,
              $FieldName_ScriptType: ${this.type.name},
              $FieldName_Script: ${this.script},
              $FieldName_Value: ${this.value}
          },""";
    } else if (this.addresses == null)
      data = """
          {
              $FieldName_Addresses: null,
              $FieldName_DataHex: ${this.dataHex},
              $FieldName_ScriptType: ${this.type.name},
              $FieldName_Script: ${this.script},
              $FieldName_Value: ${this.value}
          },""";
    return data;
  }
}
