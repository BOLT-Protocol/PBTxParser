import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart' show hex;

import '../model/pb.contract.model.dart';
import '../model/cointype.model.dart';

import '../constant/config.dart';

import '../utils/ecurve.dart' as ecdsa;

import '../utils/hash.dart';
import '../utils/http_agent.dart';
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
  String _type = Transaction.bitcoin.type;
  bool _signed;
  List<String> _signedPubkey;

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

  String get type => "Type: $_type";
  String get signed {
    //TODO Input is signed
    bool s = true;
    this.inputs.forEach((input) {
      if (input.signed == null || !input.signed) s = false;
    });
    this._signed = s;
    return "Signed: $_signed";
  }

  String get signedPubkey =>
      this._signedPubkey != null ? "Signed Pubkic Key: $_signedPubkey" : null;

  Uint8List get versionInBuffer => Uint8List(4)
    ..buffer.asByteData().setUint32(0, this.version, Endian.little);

  Uint8List get lockTimeInBuffer => Uint8List(4)
    ..buffer.asByteData().setUint32(0, this.lockTime, Endian.little);

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

  String get pbData => this.contractData != null
      ? """$FieldName_PocketBank: {
      ${this.contractData.text}
  }
  """
      : null;

  String get detail {
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
    return data;
  }

  Uint8List getRawDataToSign(int index) {
    List<int> data = [];
    Input selectedInput = this.inputs[index];
    if (selectedInput.type == ScriptType.P2WPKH) {
      //  nVersion
      //  hashPrevouts
      //  hashSequence
      //  outpoint:     (32-byte hash + 4-byte little endian vout)
      //  scriptCode:   For P2WPKH witness program, the scriptCode is 0x1976a914{20-byte-pubkey-hash}88ac. //only compressed public keys are accepted in P2WPKH and P2WSH.
      //  amount:       value of the output spent by this input (8-byte little endian)
      //  nSequence:    ffffffff
      //  hashOutputs
      //  nLockTime:    11000000
      //  nHashType:    01000000 // SIGHASH_ALL

      List<int> prevouts = [];
      List<int> sequences = [];
      List<int> outputs = [];
      for (Input input in this.inputs) {
        prevouts.addAll(input.reservedTxid + input.voutInBuffer);
        sequences.addAll(input.sequenceInBuffer);
      }

      if (selectedInput.hashType != HashType.SIGHASH_SINGLE ||
          selectedInput.hashType != HashType.SIGHASH_NONE)
        for (Output output in this.outputs) {
          outputs.addAll(output.valueInBuffer + toBuffer(output.script));
        }
      else if (selectedInput.hashType == HashType.SIGHASH_SINGLE &&
          index < this.outputs.length)
        outputs.addAll(this.outputs[index].valueInBuffer +
            toBuffer(this.outputs[index].script));

      List<int> hashPrevouts = doubleSHA256(prevouts);
      List<int> hashSequence = doubleSHA256(sequences);

      print('hashPrevouts: ${hex.encode(hashPrevouts)}');
      print('hashSequence: ${hex.encode(hashSequence)}');

      //  nVersion
      data.addAll(this.versionInBuffer);
      //  hashPrevouts
      /* 
      If the ANYONECANPAY flag is not set, hashPrevouts is the double SHA256 of the serialization of all input outpoints;
      Otherwise, hashPrevouts is a uint256 of 0x0000......0000.
      */
      if (selectedInput.hashType != HashType.SIGHASH_ANYONECANPAY)
        data.addAll(hashPrevouts);
      else
        data.addAll(
            Uint8List(32)..buffer.asByteData().setUint32(0, 0, Endian.little));

      //  hashSequence
      /* 
      If none of the ANYONECANPAY, SINGLE, NONE sighash type is set, hashSequence is the double SHA256 of the serialization of nSequence of all inputs;
      Otherwise, hashSequence is a uint256 of 0x0000......0000.
       */
      if (selectedInput.hashType == HashType.SIGHASH_ALL)
        data.addAll(hashSequence);
      else
        data.addAll(
            Uint8List(32)..buffer.asByteData().setUint32(0, 0, Endian.little));
      //  outpoint:
      data.addAll(selectedInput.reservedTxid + selectedInput.voutInBuffer);
      /*
      For P2WPKH witness program, the scriptCode is 0x1976a914{20-byte-pubkey-hash}88ac.
      For P2WSH witness program,
          if the witnessScript does not contain any OP_CODESEPARATOR, the scriptCode is the witnessScript serialized as scripts inside CTxOut.
          if the witnessScript contains any OP_CODESEPARATOR, the scriptCode is the witnessScript but removing everything up to and including 
          the last executed OP_CODESEPARATOR before the signature checking opcode being executed, serialized as scripts inside CTxOut. 
          (The exact semantics is demonstrated in the examples below)
       */
      //  scriptCode:
      Uint8List pubKeyHash = toHASH160(toBuffer(selectedInput.pubkey));
      List<int> scriptCode = pubKeyHash.toP2pkhScript();
      print('prevOutScript: ${hex.encode([scriptCode.length, ...scriptCode])}');
      data.addAll([scriptCode.length, ...scriptCode]);

      //  amount:
      data.addAll(selectedInput.valueInBuffer);
      //  nSequence:
      data.addAll(selectedInput.sequenceInBuffer);
      //  hashOutputs
      /*
      If the sighash type is neither SINGLE nor NONE, hashOutputs is the double SHA256 of the serialization of all output amount (8-byte little endian) with scriptPubKey (serialized as scripts inside CTxOuts);
      If sighash type is SINGLE and the input index??  is smaller than the number of outputs, hashOutputs is the double SHA256 of the output amount with scriptPubKey of the same index as the input;
      Otherwise, hashOutputs is a uint256 of 0x0000......0000.
      */
      if (outputs.isNotEmpty) {
        print('outputs: ${hex.encode(outputs)}');
        List<int> hashOutputs = doubleSHA256(outputs);
        data.addAll(hashOutputs);
        print('hashOutputs: ${hex.encode(hashOutputs)}');
      } else
        data.addAll(
            Uint8List(32)..buffer.asByteData().setUint32(0, 0, Endian.little));

      //  nLockTime:
      data.addAll(this.lockTimeInBuffer);
      //  nHashType:
      data.addAll(selectedInput.hashTypeInBuffer);
    } else {
      //  nVersion
      data.addAll(this.versionInBuffer);
      // Input count
      data.add(this.inputs.length);
      for (Input input in this.inputs) {
        //  outpoint:
        data.addAll(input.reservedTxid + input.voutInBuffer);
        if (input == selectedInput) {
          //  txin:
          List<int> script;
          if (input.type == ScriptType.P2PKH) {
            script = toHASH160(toBuffer(input.pubkey)).toP2pkhScript();
          } else if (input.type == ScriptType.P2PK) {
            script = toBuffer(input.pubkey).pubkeyToP2PKScript();
          } else if (input.type == ScriptType.P2SH) {
            script = toHASH160(toBuffer(input.pubkey)).toBIP49RedeemScript();
          } else if (input.type == ScriptType.P2WPKH) {
            // do nothing
          } else {
            print('Unusable utxo: ${input.txid}');
            return null;
          }
          data.addAll(script);
        } else {
          data.add(0);
        }
        //  nSequence:
        data.addAll(selectedInput.sequenceInBuffer);
      }
      // Output count
      data.add(this.outputs.length);
      print('transanction.outputs.length: ${this.outputs.length}');

      for (Output output in this.outputs) {
        print('output amountInBuffer: ${hex.encode(output.valueInBuffer)}');
        print('output script: ${output.script}');

        data.addAll(output.valueInBuffer + toBuffer(output.script));
      }
      //  nLockTime:
      data.addAll(this.lockTimeInBuffer);
    }
    return Uint8List.fromList(data);
  }

  static Future<BitcoinTransaction> decode(String hexData) async {
    BitcoinTransaction transaction = BitcoinTransaction();
    Uint8List data;
    int pointer;
    // TO Buffer
    try {
      data = toBuffer(hexData);
      pointer = 0;
      print('pointer:$pointer, dataLength: ${data.length}');
    } catch (e) {
      print(e);
      return null;
    }

    // version
    int version;
    try {
      version = decodeBigIntL(data.sublist(pointer, pointer + VERSION_LENGTH))
          .toInt();
      print(
          'pointer:$pointer, version:$version,  sublist: ${data.sublist(pointer, pointer + VERSION_LENGTH)}');
    } catch (e) {
      print(e);
      return null;
    }

    if (!(version == 1 || version == 2)) return null;
    // throw ErrorDescription('wrong version');
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

    try {
      if (data[pointer] == ADVANCED_TRANSACTION_MARKER &&
          data[pointer + 1] == ADVANCED_TRANSACTION_FLAG) {
        isSewgit = true;
        transaction.isSewgit = isSewgit;
        pointer += 2;
      }
    } catch (e) {
      print(e);
      return null;
    }

    // txins
    int txinCounts;
    try {
      txinCounts = data[pointer];
      pointer++;
      print('pointer:$pointer, txinCounts:$txinCounts');
    } catch (e) {
      print(e);
      return null;
    }

    for (int index = 0; index < txinCounts; index++) {
      String preTxid;
      try {
        preTxid = hex.encode(
            data.sublist(pointer, pointer + TXID_LENGTH).reversed.toList());
        pointer += TXID_LENGTH;
        print('pointer:$pointer, preTxid:$preTxid');
      } catch (e) {
        print(e);
        return null;
      }

      int vout;
      try {
        vout =
            decodeBigIntL(data.sublist(pointer, pointer + VOUT_LENGTH)).toInt();
        pointer += VOUT_LENGTH;
        print('pointer:$pointer, vout:$vout');
      } catch (e) {
        print(e);
        return null;
      }

      // script
      int scriptLength;
      try {
        scriptLength = data[pointer];
      } catch (e) {
        print(e);
        return null;
      }
      List<int> script;
      String address;
      ScriptType scriptType;
      pointer++;
      print('pointer:$pointer, scriptLength:$scriptLength');
      try {
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
          // throw ErrorDescription('unsupported script length');
          return null;
        }
      } catch (e) {
        print(e);
        return null;
      }
      if (scriptLength > 0) {
        Map<String, dynamic> result = script.decodeScript();
        address = result["address"];
        scriptType = result["type"];
        print('pointer:$pointer, address:$address, scriptType:$scriptType');
      }

      // sequence is also little-Endian
      int sequence;
      try {
        sequence =
            decodeBigIntL(data.sublist(pointer, pointer + SEQUENCE_LENGTH))
                .toInt();
        pointer += SEQUENCE_LENGTH;
        print('pointer:$pointer, sequence:$sequence');
      } catch (e) {
        print(e);
        return null;
      }

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
    int txoutCounts;
    try {
      txoutCounts = data[pointer];
      pointer++;
      print('pointer:$pointer, txoutCounts:$txoutCounts');
    } catch (e) {
      print(e);
      return null;
    }

    for (int index = 0; index < txoutCounts; index++) {
      BigInt value;
      try {
        value = decodeBigIntL(data.sublist(pointer, pointer + VALUE_LENGTH));
        pointer += VALUE_LENGTH;
        print('pointer:$pointer, value:$value');
      } catch (e) {
        print(e);
        return null;
      }
      // script
      int scriptLength = data[pointer];
      List<int> script;
      pointer++;
      print('pointer:$pointer, scriptLength:$scriptLength');
      try {
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
          // throw ErrorDescription('unsupported script length');
          return null;
        }
      } catch (e) {
        print(e);
        return null;
      }
      String address = script.decodeScript()["address"];
      ScriptType scriptType = script.decodeScript()["type"];
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
      List<int> buffer;
      try {
        buffer = [
          ...data.sublist(0, VERSION_LENGTH),
          ...data.sublist(VERSION_LENGTH + 2, pointer),
          ...data.sublist(data.length - LOCKTIME_LENGTH)
        ];
      } catch (e) {
        print(e);
        return null;
      }
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
        int witnessLength;
        try {
          witnessLength = data[pointer];
          pointer++;
          print('pointer:$pointer, witnessLength:$witnessLength');
        } catch (e) {
          print(e);
          return null;
        }
        List<int> witness;
        try {
          witness = data.sublist(pointer, pointer + witnessLength);
          pointer += witnessLength;
          print('pointer:$pointer, witness:${hex.encode(witness)}');
        } catch (e) {
          print(e);
          return null;
        }
        int pubkeyLength;
        try {
          pubkeyLength = data[pointer];
          pointer++;
          print('pointer:$pointer, pubkeyLength:$pubkeyLength');
        } catch (e) {
          print(e);
          return null;
        }
        List<int> pubkey;
        try {
          pubkey = data.sublist(pointer, pointer + pubkeyLength);
          pointer += pubkeyLength;
          print('pointer:$pointer, pubkey:${hex.encode(pubkey)}');
        } catch (e) {
          print(e);
          return null;
        }
        transaction.inputs[index].witness = [
          hex.encode(witness),
          hex.encode(pubkey)
        ];
        transaction.inputs[index].addresses = [pubkeyToP2wphAddress(pubkey)];
        transaction.inputs[index].type = ScriptType.P2WPKH;
        transaction.inputs[index].pubkey = hex.encode(pubkey);
        print('pointer:$pointer, address:${pubkeyToP2wphAddress(pubkey)}');
      }
    } else {
      transaction.txid = hex.encode(doubleSHA256(data));
    }
    try {
      transaction.lockTime =
          decodeBigIntL(data.sublist(data.length - LOCKTIME_LENGTH)).toInt();
    } catch (e) {
      print(e);
      return null;
    }

    print(
        'pointer:$pointer, dataLength: ${data.length}, lockTime:${transaction.lockTime}');

    // for (Input input in transaction.inputs) {
    transaction.inputs.asMap().forEach((index, input) async {
// TODO get input value
      // String urlString =
      //     "https://api.cryptoapis.io/v1/bc/btc/${CoinType.bitcoin.network}/txs/txid/${input.txid}";
      // print("_$urlString");

      // var res = await HTTPAgent().request(urlString,
      //     headers: {"X-API-Key": Config().cryptoApiKeyForBTC});

      // Map<String, dynamic> result;
      // print(res);

      // try {
      //   result = res[0];
      //   print(result);
      // } catch (e) {
      //   print('Error occur: _syncTransaction');
      // }
      // input.value = Converter.toSatoshi(
      //     Decimal.parse(result["txouts"][input.vout]["amount"]));

      print('input.pubkey: ${input.pubkey}');
      if (input.pubkey != null) {
        List<int> buffer;
        Uint8List signature;

        if (input.witness == null && input.script != null) {
          //TODO P2PKH || P2SH
          print('TODO P2PKH || P2SH');
          buffer = toBuffer(input.script);
          print('buffer: $buffer');
          print('script: ${input.script}');
        } else if (input.witness != null && input.script == null) {
          // TODO P2WPKH
          print('TODO P2WPKH');
          buffer = toBuffer(input.witness[0]);
          print('script: ${input.witness[0]}');
          print('buffer: $buffer');
        } else if (input.witness != null && input.script != null) {
          // TODO P2WPKH nested in P2SH
          print('TODO P2WPKH nested in P2SH');
          buffer = toBuffer(input.witness[0]);
          print('buffer: $buffer');
          print('script: ${input.witness[0]}');
        }
        input.hashType = HashType.values
            .firstWhere((element) => element.value == buffer.last);

        try {
          signature = decodeDER(buffer);
        } catch (e) {
          print(e);
          return null;
        }

        // Uint8List hash = doubleSHA256(transaction.getRawDataToSign(index));
        // print('hash: ${hex.encode(hash)}');
        // input.signed = ecdsa.verify(hash, toBuffer(input.pubkey), signature);
        print('input.signed: ${input.signed}');
      } else if (input.script != null) {
        // TODO P2PK
      }
    });
    return transaction;
  }
}
