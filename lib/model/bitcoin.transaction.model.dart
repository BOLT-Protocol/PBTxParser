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

  void addInput(Input input) {
    if (this.inputs == null)
      inputs = [input];
    else
      inputs.add(input);
  }

  void addOutput(Output output) {
    if (this.outputs == null)
      outputs = [output];
    else
      outputs.add(output);
  }

  BitcoinTransaction();

  BitcoinTransaction decodeTransaction(String hexData) {
    BitcoinTransaction transaction = BitcoinTransaction();
    Uint8List data = toBuffer(hexData);
    int pointer = 0;

    // version
    int version = decodeBigIntL(data.sublist(pointer, VERSION_LENGTH)).toInt();
    if (version != 1 || version != 2) throw ErrorDescription('wrong version');
    transaction.version = version;
    Config().setTestnet(version == 2 ? true : false);
    pointer += VERSION_LENGTH;
    print(
        'pointer:$pointer, version:$version,  isTestnet: ${Config().isTestnet}');

    // isSewgit
    bool isSewgit = false;
    transaction.isSewgit = isSewgit;
    if (data.sublist(pointer, pointer + 2) ==
        [ADVANCED_TRANSACTION_MARKER, ADVANCED_TRANSACTION_FLAG]) {
      transaction.isSewgit = true;
      pointer += 2;
      print(
          'pointer:$pointer, sublist:${data.sublist(pointer, pointer + 2)},  advance: ${[
        ADVANCED_TRANSACTION_MARKER,
        ADVANCED_TRANSACTION_FLAG
      ]}');
    }

    // txins
    int txinCounts = data[pointer];
    pointer++;
    print('pointer:$pointer, txinCounts:$txinCounts}');
    for (int index = 0; index < txinCounts; index++) {
      String preTxid = hex.encode(
          data.sublist(pointer, pointer + TXID_LENGTH).reversed.toList());
      pointer += TXID_LENGTH;
      print('pointer:$pointer, preTxid:$preTxid');
      int vout =
          decodeBigIntL(data.sublist(pointer, pointer + VOUT_LENGTH)).toInt();
      pointer += VOUT_LENGTH;
      print('pointer:$pointer, vout:$vout');
      // script
      int scriptLength = data[pointer];
      List<int> script;

      pointer++;
      print('pointer:$pointer, scriptLength:$scriptLength');
      if (scriptLength == 0) {
        script = [0];
      } else if (scriptLength > 0 && scriptLength < 0xFD) {
        script = data.sublist(pointer, pointer + scriptLength);
        pointer += scriptLength;
        print('pointer:$pointer, script:${hex.encode(script)}');
      } else if (scriptLength == 0xFD) {
        scriptLength =
            decodeBigIntL(data.sublist(pointer, pointer + 2)).toInt();
        pointer += 2;
        print('pointer:$pointer, scriptLength:$scriptLength');
        script = data.sublist(pointer, pointer + scriptLength);
        pointer += scriptLength;
        print('pointer:$pointer, script:${hex.encode(script)}');
      } else {
        throw ErrorDescription('unsupported script length');
      }
      String address = script.scriptToAddress()["address"];
      ScriptType scriptType = script.scriptToAddress()["type"];
      print('pointer:$pointer, address:$address, scriptType:$scriptType');

      // sequence is also little-Endian
      int sequence =
          decodeBigIntL(data.sublist(pointer, pointer + SEQUENCE_LENGTH))
              .toInt();
      pointer += SEQUENCE_LENGTH;
      print('pointer:$pointer, sequence:$sequence');

      Input input = Input(
        txid: preTxid,
        vout: vout,
        script: hex.encode(script),
        sequence: sequence,
        addresses: address != null ? [address] : null,
        type: scriptType,
      );
      transaction.addInput(input);
    }
    // txouts
    int txoutCounts = data[pointer];
    pointer++;
    print('pointer:$pointer, txinCounts:$txinCounts}');
    for (int index = 0; index < txinCounts; index++) {
      BigInt value =
          decodeBigIntL(data.sublist(pointer, pointer + VALUE_LENGTH));
      pointer += VALUE_LENGTH;
      print('pointer:$pointer, preTxid:$value');
      // script
      int scriptLength = data[pointer];
      List<int> script;
      pointer++;
      print('pointer:$pointer, scriptLength:$scriptLength');
      if (scriptLength > 0 && scriptLength < 0xFD) {
        script = data.sublist(pointer, pointer + scriptLength);
        pointer += scriptLength;
        print('pointer:$pointer, script:${hex.encode(script)}');
      } else if (scriptLength == 0xFD) {
        scriptLength =
            decodeBigIntL(data.sublist(pointer, pointer + 2)).toInt();
        pointer += 2;
        print('pointer:$pointer, scriptLength:$scriptLength');
        script = data.sublist(pointer, pointer + scriptLength);
        pointer += scriptLength;
        print('pointer:$pointer, script:${hex.encode(script)}');
      } else {
        throw ErrorDescription('unsupported script length');
      }
      String address = script.scriptToAddress()["address"];
      ScriptType scriptType = script.scriptToAddress()["type"];
      print('pointer:$pointer, address:$address, scriptType:$scriptType');
      Output output = Output(
          value: value,
          script: hex.encode(script),
          type: scriptType,
          addresses: addresses != null ? [address] : null);
      transaction.addOutput(output);
    }
    if (isSewgit) {
      for (int index = 0; index < txinCounts; index++) {
        int starter = data[pointer];
        print('pointer:$pointer, starter:$starter');
        if (starter == 0 || starter != 2) continue;
        pointer++;
        print('pointer:$pointer, starter:$starter');
        int witnessLength = data[pointer];
        pointer++;
        print('pointer:$pointer, witnessLength:$witnessLength');
        List<int> witness = data.sublist(pointer, pointer + witnessLength);
        pointer += witnessLength;
        print('pointer:$pointer, witness:${hex.encode(witness)}');
        int pubkeyLength = data[pointer];
        pointer++;
        print('pointer:$pointer, pubkeyLength:$pubkeyLength');
        List<int> pubkey = data.sublist(pointer, pointer + pubkeyLength);
        pointer += pubkeyLength;
        print('pointer:$pointer, pubkey:${hex.encode(pubkey)}');
        transaction.inputs[index].witness = [
          hex.encode(witness),
          hex.encode(pubkey)
        ];
        transaction.inputs[index].addresses = [pubkeyToP2wphAddress(pubkey)];
        transaction.inputs[index].type = ScriptType.P2WPKH;
        print('pointer:$pointer, addresses:$addresses');
      }
    }
    transaction.lockTime = decodeBigIntL(data.sublist(pointer)).toInt();
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

  Input({
    List<String> addresses,
    int vout,
    BigInt value,
    String txid,
    ScriptType type,
    int sequence,
    String script,
    List<String> witness,
    String pubkey,
  })  : addresses = addresses,
        vout = vout,
        value = value,
        txid = txid,
        type = type,
        sequence = sequence,
        script = script,
        witness = witness,
        pubkey = pubkey;
}

class Output {
  List<String> addresses;
  String script;
  ScriptType type;
  BigInt value;
  String dataHex;

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
}
