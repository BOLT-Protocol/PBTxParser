import 'dart:typed_data';
import 'package:PBTxParser/constant/config.dart';
import 'package:PBTxParser/utils/hash.dart';
import 'package:convert/convert.dart' show hex;

import 'base58.dart';
import 'segwit.dart';
import 'utils.dart';

const int OP_0 = 0x00;
const int OP_PUSHDATA1 = 0x4c;
const int OP_PUSHDATA2 = 0x4d;
const int OP_PUSHDATA4 = 0x4e;
const int OP_1NEGATE = 0x4f;
const int OP_1 = 0x51;
const int OP_16 = 0x60;
const int OP_DUP = 0x76;
const int OP_EQUAL = 0x87;
const int OP_EQUALVERIFY = 0x88;
const int OP_HASH160 = 0xa9;
const int OP_CHECKSIG = 0xac;
const int OP_CODESEPARATOR = 0xab;

final Base58 base58 = Base58();
final Base58 base58Xrp = Base58.xrp();

enum ScriptType { P2PK, P2PKH, P2SH, P2WPKH, NULL }

extension ScriptTypeExt on ScriptType {
  String get name {
    switch (this) {
      case ScriptType.P2PK:
        return "pay-to-pubkey";
        break;
      case ScriptType.P2PKH:
        return "pay-to-pubkey-hash";
        break;
      case ScriptType.P2SH:
        return "pay-to-script-hash";
        break;
      case ScriptType.P2WPKH:
        return "pay-to-witness-pubkey-hash";
        break;
      case ScriptType.NULL:
        return "null-data";
        break;
      default:
        return null;
        break;
    }
  }

  int get prefix {
    // bitcoin only
    switch (this) {
      case ScriptType.P2PK:
      case ScriptType.P2PKH:
        return Config().isTestnet ? 0x6F : 0;
        break;
      case ScriptType.P2SH:
        return Config().isTestnet ? 0xC4 : 0x05;
        break;
      case ScriptType.P2WPKH:
      default:
        return null;
        break;
    }
  }

  String get bech32HRP {
    // bitcoin only
    switch (this) {
      case ScriptType.P2WPKH:
        return Config().isTestnet ? "tb" : "bc";
        break;
      case ScriptType.P2PK:
      case ScriptType.P2PKH:
      case ScriptType.P2SH:
      default:
        return null;
        break;
    }
  }

  String get bech32Separator {
    // bitcoin only
    switch (this) {
      case ScriptType.P2WPKH:
        return "1";
        break;
      case ScriptType.P2PK:
      case ScriptType.P2PKH:
      case ScriptType.P2SH:
      default:
        return null;
        break;
    }
  }
}

enum HashType {
  SIGHASH_ALL,
  SIGHASH_NONE,
  SIGHASH_SINGLE,
  SIGHASH_ANYONECANPAY
}

extension HashTypeExt on HashType {
  int get value {
    switch (this) {
      case HashType.SIGHASH_ALL:
        return 0x01;
        break;
      case HashType.SIGHASH_NONE:
        return 0x02;
        break;
      case HashType.SIGHASH_SINGLE:
        return 0x03;
        break;
      case HashType.SIGHASH_ANYONECANPAY:
        return 0x80;
        break;
      default:
        return null;
        break;
    }
  }
}

extension StringExt on String {
  List<int> extractScriptPubkey() {
    Segwit address = segwit.decode(this);
    List<int> scriptPubKey = hex.decode(address.scriptPubKey);
    return scriptPubKey;
  }
}

extension Uint8ListExt on Uint8List {
  bool isP2pkhScript() {
    if (this.length != 0x19)
      return false;
    else if (this[0] != OP_DUP)
      return false;
    else if (this[1] != OP_HASH160)
      return false;
    else if (this[this.length - 2] != OP_EQUALVERIFY)
      return false;
    else if (this[this.length - 1] != OP_CHECKSIG)
      return false;
    else
      return true;
  }

  bool isP2pkScript() {
    if (this.length != 34)
      return false;
    else if (this.last != OP_CHECKSIG)
      return false;
    else
      return true;
  }

  bool isP2wpkhScript() {
    if (this.length != 0x16)
      return false;
    else if (this.first != OP_0)
      return false;
    else
      return true;
  }

  bool isP2shScript() {
    if (this.length != 0x16)
      return false;
    else if (this.first != OP_HASH160)
      return false;
    else
      return true;
  }
}

extension ListExt<T> on List<int> {
  Map<String, dynamic> scriptToPubkeyHash() {
    Uint8List buffer = toBuffer(this);
    Uint8List pubkeyHash;
    ScriptType scriptType;
    if (buffer.isP2pkhScript()) {
      /**
    pay-to-pubkey-hash
    scriptPubKey: OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
    (76 a9 14 <pubkeyHash> 88 ac)
    scriptSig: <sig> <pubKey>
  */
      scriptType = ScriptType.P2PKH;
      pubkeyHash = toBuffer(buffer.sublist(3, buffer.length - 2));
    } else if (buffer.isP2pkScript()) {
      /**
    pay-to-pubkey
    scriptPubKey: <pubKey> OP_CHECKSIG
    (<pubkey> ac)
    scriptSig: <sig>
    */
      Uint8List pubkey =
          compressedPubKey(toBuffer(buffer.sublist(0, buffer.length - 1)));
      scriptType = ScriptType.P2PK;
      pubkeyHash = toHASH160(pubkey);
    } else if (buffer.isP2shScript()) {
      /**
    pay-to-script-hash
    scriptPubKey: OP_HASH160 <20-byte-hash-value> OP_EQUAL
    scriptSig: <sig> <20-byte-hash-value>
               (0xa914{20-byte-script-hash}87)
    */
      scriptType = ScriptType.P2SH;
      pubkeyHash = toBuffer(buffer.sublist(2, buffer.length - 1));
    } else if (buffer.isP2wpkhScript()) {
      /**
    pay-to-witness-pubkey-hash
    witness: <signature> <pubkey>
    scriptSig: (empty)
    scriptPubKey: 0 <20-byte-key-hash>
                  (0x0014{20-byte-key-hash})
    */
      scriptType = ScriptType.P2WPKH;
      pubkeyHash = toBuffer(buffer.sublist(2));
    } else {
      pubkeyHash = null;
    }
    return {'type': scriptType, 'data': pubkeyHash};
  }

  String scriptToAddress() {
    Map<String, dynamic> hash = this.scriptToPubkeyHash();
    ScriptType type = hash["type"];
    String address;
    switch (type) {
      case ScriptType.P2PK:
      case ScriptType.P2PKH:
      case ScriptType.P2SH:
        address = base58.encode(toBuffer([type.prefix] + hash["data"]));
        break;
      case ScriptType.P2WPKH:
        address = segwit.encode(
            Segwit(type.bech32HRP, 0, hash["data"])); // witness_v0_keyhash
        break;
      default:
    }

    return address;
  }
}

String pubkeyToP2wphAddress(dynamic pubkey) {
  Uint8List buffer = compressedPubKey(toBuffer(pubkey));
  Uint8List hash = toHASH160(buffer);
  String address = segwit.encode(
      Segwit(ScriptType.P2WPKH.bech32HRP, 0, hash)); // witness_v0_keyhash
  return address;
}

Uint8List compressedPubKey(List<int> uncompressedPubKey) {
  //**https://bitcoin.stackexchange.com/questions/69315/how-are-compressed-pubkeys-generated
  //https://bitcointalk.org/index.php?topic=644919.0
  if (uncompressedPubKey.length == 33) return toBuffer(uncompressedPubKey);
  if (uncompressedPubKey.length % 2 == 1) {
    uncompressedPubKey =
        uncompressedPubKey.sublist(1, uncompressedPubKey.length);
  }
  List<int> x = uncompressedPubKey.sublist(0, 32);
  List<int> y = uncompressedPubKey.sublist(32, 64);
  BigInt p = BigInt.parse(
      'fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f',
      radix: 16);
  BigInt xInt = BigInt.parse(hex.encode(x), radix: 16);
  BigInt yInt = BigInt.parse(hex.encode(y), radix: 16);
  BigInt check = (xInt.pow(3) + BigInt.from(7) - yInt.pow(2)) % p;

  if (check == BigInt.zero) {
    List<int> prefix =
        BigInt.parse(hex.encode(y), radix: 16).isEven ? [0x02] : [0x03];
    return toBuffer(prefix + x);
  }
}
