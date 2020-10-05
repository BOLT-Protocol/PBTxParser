import 'dart:typed_data';

import 'package:PBTxParser/model/pb.contract.model.dart';
import 'package:PBTxParser/utils/hash.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart' show hex;
import '../constant/config.dart';

import '../utils/utils.dart';
import '../utils/extensions.dart';

import 'bitcoin.input.model.dart';
import 'bitcoin.output.model.dart';
import 'transaction.type.model.dart';

const ADVANCED_TRANSACTION_MARKER = 0x00;
const ADVANCED_TRANSACTION_FLAG = 0x01;
const VERSION_LENGTH = 4;
const VOUT_LENGTH = 4;
const SEQUENCE_LENGTH = 4;
const LOCKTIME_LENGTH = 4;
const VALUE_LENGTH = 8;
const TXID_LENGTH = 32;

class BitcoinTransaction {
  static const String FieldName_Type = "type";
  static const String FieldName_Detail = "detail";
  static const String FieldName_Signed = "signed";
  static const String FieldName_PocketBank = "pocket_bank";
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
  static const String FieldName_Outputs = "outputs";
  static const String FieldName_Size = "size";
  static const String FieldName_TotalValue = "total";
  static const String FieldName_Version = "ver";
  static const String FieldName_VinSize = "vin_sz";
  static const String FieldName_VoutSize = "vout_sz";
  static const String FieldName_LockedTime = "lock_time";

  List<String> addresses;
  bool signed;
  String txid; // hash
  List<Input> inputs;
  List<Output> outputs;
  BigInt fee;
  int size;
  BigInt total;
  int version;
  int lockTime;
  bool isSewgit;
  PBContractData contractData;

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

  Map<String, dynamic> get map {
    this.addresses = [];
    for (Input input in this.inputs) {
      if (input.addresses != null) this.addresses.addAll(input.addresses);
    }
    for (Output output in this.outputs) {
      if (output.addresses != null) this.addresses.addAll(output.addresses);
    }
    Map<String, dynamic> data = {
      FieldName_Addresses: this.addresses,
      FieldName_Fees: this.fee,
      FieldName_TxId: this.txid,
      FieldName_Inputs: [
        for (Input input in this.inputs) {input.map}
      ],
      FieldName_Outputs: [
        for (Output output in this.outputs) {output.map}
      ],
      FieldName_TotalValue: this.total,
      FieldName_Version: this.version,
      FieldName_VinSize: this.inputs.length,
      FieldName_VoutSize: this.outputs.length,
      FieldName_LockedTime: this.lockTime
    };
    return data;
  }

  String get text {
    this.addresses = [];
    for (Input input in this.inputs) {
      if (input.addresses != null) this.addresses.addAll(input.addresses);
    }
    for (Output output in this.outputs) {
      if (output.addresses != null) this.addresses.addAll(output.addresses);
    }
    String addresses = "";
    this.addresses.asMap().forEach((index, address) {
      addresses += """
          $address${index != this.addresses.length - 1 ? "," : ""}
        """;
    });
    String inputs = "";
    this.inputs.asMap().forEach((index, input) {
      inputs +=
          "${index == 0 ? '\n' : ''}${input.text}${index == this.inputs.length - 1 ? '' : '\n'}";
    });
    String outputs = "";
    this.outputs.asMap().forEach((index, output) {
      outputs +=
          "${index == 0 ? '\n' : ''}${output.text}${index == this.outputs.length - 1 ? '' : '\n'}";
    });

    String data = """
$FieldName_Type: ${Transaction.BITCOIN.type},
$FieldName_Signed: ${this.signed},
$FieldName_Detail: {
      $FieldName_Addresses: [
        $addresses],
      $FieldName_Fees: ${this.fee},
      $FieldName_TxId: ${this.txid},
      $FieldName_Inputs: [$inputs
      ],
      $FieldName_Outputs: [$outputs
      ],
      $FieldName_TotalValue: ${this.total},
      $FieldName_Version: ${this.version},
      $FieldName_VinSize: ${this.inputs.length},
      $FieldName_VoutSize: ${this.outputs.length},
      $FieldName_LockedTime: ${this.lockTime}
}""";
    if (this.contractData != null) {
      data = """
$FieldName_Type: ${Transaction.BITCOIN.type},
$FieldName_Signed: ${this.signed},
$FieldName_Detail: {
      $FieldName_Addresses: [
        $addresses],
      $FieldName_Fees: ${this.fee},
      $FieldName_TxId: ${this.txid},
      $FieldName_Inputs: [$inputs
      ],
      $FieldName_Outputs: [$outputs
      ],
      $FieldName_TotalValue: ${this.total},
      $FieldName_Version: ${this.version},
      $FieldName_VinSize: ${this.inputs.length},
      $FieldName_VoutSize: ${this.outputs.length},
      $FieldName_LockedTime: ${this.lockTime}
  }
$FieldName_PocketBank: {
      ${this.contractData.text}
  }
}""";
    }
    return data;
  }

  static BitcoinTransaction decode(String hexData) {
    print('model: decode');
    BitcoinTransaction transaction = BitcoinTransaction();
    Uint8List data = toBuffer(hexData);
    int pointer = 0;
    print('pointer:$pointer, dataLength: ${data.length}');

    // version
    int version =
        decodeBigIntL(data.sublist(pointer, pointer + VERSION_LENGTH)).toInt();
    print(
        'pointer:$pointer, version:$version,  sublist: ${data.sublist(pointer, pointer + VERSION_LENGTH)}');
    if (!(version == 1 || version == 2))
      throw ErrorDescription('wrong version');
    transaction.version = version;
    Config().setTestnet(version == 2 ? true : false);
    pointer += VERSION_LENGTH;
    print(
        'pointer:$pointer, version:$version,  isTestnet: ${Config().isTestnet}');

    // isSewgit
    bool isSewgit = false;
    transaction.isSewgit = isSewgit;
    print(
        'pointer:$pointer, data[pointer] :${data[pointer]},  data[pointer+1] :${data[pointer + 1]},advance: ${[
      ADVANCED_TRANSACTION_MARKER,
      ADVANCED_TRANSACTION_FLAG
    ]}');

    if (data[pointer] == ADVANCED_TRANSACTION_MARKER &&
        data[pointer + 1] == ADVANCED_TRANSACTION_FLAG) {
      isSewgit = true;
      transaction.isSewgit = isSewgit;
      pointer += 2;
    }

    // txins
    int txinCounts = data[pointer];
    pointer++;
    print('pointer:$pointer, txinCounts:$txinCounts');
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
        script:
            script.length == 1 && script.first == 0 ? null : hex.encode(script),
        sequence: sequence,
        addresses: address != null ? [address] : null,
        type: scriptType,
      );
      transaction.addInput(input);
    }
    // txouts
    int txoutCounts = data[pointer];
    pointer++;
    print('pointer:$pointer, txinCounts:$txoutCounts}');
    for (int index = 0; index < txoutCounts; index++) {
      BigInt value =
          decodeBigIntL(data.sublist(pointer, pointer + VALUE_LENGTH));
      pointer += VALUE_LENGTH;
      print('pointer:$pointer, value:$value');
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
          type: address == null ? ScriptType.NULL : scriptType,
          addresses: address != null ? [address] : null,
          dataHex: address == null ? hex.encode(script.sublist(2)) : null);
      print(
          'WARNING PBContractData: ${address == null && value == BigInt.zero}');
      if (address == null && value == BigInt.zero) {
        print('WARNING RUN PBContractData');
        transaction.contractData = PBContractData(
            transaction.outputs.first.addresses.first,
            toBuffer(script.sublist(2)));
      }
      transaction.addOutput(output);
    }
    print('pointer:$pointer, isSewgit:$isSewgit');
    if (isSewgit) {
      List<int> buffer = [
        ...data.sublist(0, VERSION_LENGTH),
        ...data.sublist(VERSION_LENGTH + 2, pointer),
        ...data.sublist(data.length - LOCKTIME_LENGTH)
      ];
      transaction.txid = hex.encode(doubleSHA256(toBuffer(buffer)));
      for (int index = 0; index < txinCounts; index++) {
        int starter = data[pointer];
        print('pointer:$pointer, starter:$starter');
        if (starter == 0 || starter != 2) {
          pointer++;
          continue;
        }
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
        print('pointer:$pointer, address:${pubkeyToP2wphAddress(pubkey)}');
      }
    } else {
      transaction.txid = hex.encode(doubleSHA256(data));
    }
    transaction.lockTime =
        decodeBigIntL(data.sublist(data.length - LOCKTIME_LENGTH)).toInt();
    print(
        'pointer:$pointer, dataLength: ${data.length}, lockTime:${transaction.lockTime}');
    return transaction;
  }
}
