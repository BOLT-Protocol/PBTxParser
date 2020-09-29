import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:convert/convert.dart' show hex;
import '../constant/config.dart';

import '../utils/utils.dart';

import '../utils/extensions.dart';

const ADVANCED_TRANSACTION_MARKER = 0x00;
const ADVANCED_TRANSACTION_FLAG = 0x01;
const VERSION_LENGTH = 4;
const VOUT_LENGTH = 4;
const SEQUENCE_LENGTH = 4;
const LOCKTIME_LENGTH = 4;
const VALUE_LENGTH = 8;
const TXID_LENGTH = 32;

class BitcoinTransaction {
  static const String FieldName_Addresses = "addresses";
  static const String FieldName_BlockHeight = "block_height";
  static const String FieldName_BlockIndex = "block_index";
  static const String FieldName_Confirmations = "confirmations";
  static const String FieldName_DataProtocol = "data_protocol";
  static const String FieldName_DoubleSpend = "double_spend";
  static const String FieldName_Fees = "fees";
  static const String FieldName_TxId = "txid";
  static const String FieldName_TxHash = "txhash";
  static const String FieldName_Inputs = "inputs";
  static const String FieldName_Age = "age";
  static const String FieldName_OutputIndex = "output_index";
  static const String FieldName_OutputValue = "output_value";
  static const String FieldName_PreTxid = "prev_txid";
  static const String FieldName_ScriptType = "script_type";
  static const String FieldName_Sequence = "sequence";
  static const String FieldName_Script = "script";
  static const String FieldName_Witness = "witness";
  static const String FieldName_Outputs = "outputs";
  static const String FieldName_Value = "value";
  static const String FieldName_Size = "size";
  static const String FieldName_TotalValue = "total";
  static const String FieldName_Version = "ver";
  static const String FieldName_VinSize = "vin_sz";
  static const String FieldName_VoutSize = "vout_sz";
  static const String FieldName_LockedTime = "lock_time";

  List<String> addresses;
  String txid; // hash
  List<Input> inputs;
  List<Output> outputs;
  BigInt fee;
  int size;
  BigInt total;
  int version;
  int lockTime;
  bool isSewgit;

  BitcoinTransaction();

  BitcoinTransaction decodeTransaction(String hexData) {
    BitcoinTransaction transaction = BitcoinTransaction();
    Uint8List data = toBuffer(hexData);
    int pointer = 0;

    // version
    int version = decodeBigIntL(data.sublist(pointer, VERSION_LENGTH)).toInt();
    if (version != 1 || version != 2) throw ErrorDescription('wrong version');
    Config().setTestnet(version == 2 ? true : false);
    pointer += VERSION_LENGTH;

    // isSewgit
    if (data.sublist(pointer, pointer + 2) ==
        [ADVANCED_TRANSACTION_MARKER, ADVANCED_TRANSACTION_FLAG]) {
      isSewgit = true;
      pointer += 2;
    }

    // txins
    int txinCounts = data[pointer];
    pointer++;
    for (int index = 0; index < txinCounts; index++) {
      String preTxid = hex.encode(
          data.sublist(pointer, pointer + TXID_LENGTH).reversed.toList());
      pointer += TXID_LENGTH;
      int vout =
          decodeBigIntL(data.sublist(pointer, pointer + VOUT_LENGTH)).toInt();
      pointer += VOUT_LENGTH;

      // TPDO FIXME: confrim the way of calculating SCRIPT LENGTH
      int scriptLength = data[pointer];
      pointer++;
      if (scriptLength > 0) {
        List<int> script = data.sublist(pointer, pointer + scriptLength);
      } else {}
    }
    return transaction;
  }
}

class Input {
  List<String> addresses;
  int vout; // output_index
  BigInt value; // output_value
  String txid; // pre_hash
  ScriptType type;
  int sequence;
  String script;
  List<String> witness;
  String pubkey;

  Input({String txid, int vout})
      : txid = txid,
        vout = vout;
}

class Output {
  List<String> addresses;
  String script;
  ScriptType type;
  BigInt value;
  String dataHex;

  Output({String script, BigInt value})
      : script = script,
        value = value;
}
