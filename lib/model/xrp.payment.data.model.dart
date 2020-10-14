import 'dart:typed_data';

import 'xrp.field.model.dart';
import 'xrp.memo.data.dart';
import 'xrp.transaction.type.model.dart';
import 'xrp.internal.type.model.dart';
import 'package:convert/convert.dart' show hex;
import '../utils/extensions.dart';
import '../utils/utils.dart';

class XrpPaymentData {
  String transactionType;
  String account;
  String destination;
  int destinationTag;
  String amount; // in drop
  String fee; // in drop
  int flags;
  int sequence;
  List<XrpMemoData> memos;
  String signingPubKey; // uppercase hex string
  String txnSignature; // uppercase hex string

  Map<String, dynamic> get map {
    Map<String, dynamic> map = {};
    (transactionType != null)
        ? map[XrpField.transactionType.name] = transactionType
        : null;
    (account != null) ? map[XrpField.account.name] = account : null;
    (destination != null) ? map[XrpField.destination.name] = destination : null;
    (destinationTag != null)
        ? map[XrpField.destinationTag.name] = destinationTag
        : null;
    (amount != null) ? map[XrpField.amount.name] = amount : null;
    (fee != null) ? map[XrpField.fee.name] = fee : null;
    (flags != null) ? map[XrpField.flags.name] = flags : null;
    (sequence != null) ? map[XrpField.sequence.name] = sequence : null;
    if (memos != null) {}
    List<Map<String, dynamic>> memoMaps = [];
    for (XrpMemoData memo in memos ?? []) {
      memoMaps.add(memo.map);
    }
    if (memoMaps.length > 0) map[XrpField.memos.name] = memoMaps;
    (signingPubKey != null)
        ? map[XrpField.signingPubKey.name] = signingPubKey
        : null;
    (txnSignature != null)
        ? map[XrpField.txnSignature.name] = txnSignature
        : null;
    return map;
  }

  List<int> get serializedData {
    List<int> data = [];
    // data.addAll(XrpField.memo.fieldId);
    // print('data $data');
    List<XrpField> fields = [
      XrpField.transactionType,
      XrpField.account,
      XrpField.destination,
      XrpField.destinationTag,
      XrpField.amount,
      XrpField.fee,
      XrpField.flags,
      XrpField.sequence,
      XrpField.memos,
      XrpField.signingPubKey,
      XrpField.txnSignature
    ];
    fields.sort((f1, f2) {
      // TODO: make sure the order is correct (TIDEiSun). All fields in a transaction are sorted in a specific order based first on the field's type (specifically, a numeric "type code" assigned to each type), then on the field itself (a "field code").
      if (f1.type.code < f2.type.code) {
        return -1;
      } else if (f1.type.code == f2.type.code && f1.code < f2.code) {
        return -1;
      } else {
        return 1;
      }
    });
    for (XrpField field in fields) {
      List<int> value = [];
      print('data ${hex.encode(data)}');
      switch (field) {
        case XrpField.transactionType:
          if (transactionType == null) continue;
          var txType = XrpTransactionType.values
              .firstWhere((element) => (element.name == transactionType));
          if (txType == null) {
            print("Transaction type not found");
            continue;
          }
          value = [(txType.code >> 8) & 0xFF, txType.code & 0xFF];
          print('serializedData txType: ${txType.name}');
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.account:
          if (account == null) continue;
          var accountId = account.toXrpAccountId();
          if (accountId.length == 0) {
            print("Invalid account");
            continue;
          }
          value = accountId;
          print('serializedData account: ${account}');
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.destination:
          if (destination == null) continue;
          var accountId = destination.toXrpAccountId();
          if (accountId.length == 0) {
            print("Invalid destination");
            continue;
          }
          value = accountId;
          print('serializedData destination: ${destination}');
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.destinationTag:
          if (destinationTag == null) continue;
          value = (Uint8List(4)
                ..buffer.asByteData().setUint32(0, destinationTag, Endian.big))
              .toList();
          print('serializedData destinationTag: ${destinationTag}');
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.amount:
          if (amount == null) continue;
          print('serializedData amount: $amount');
          var xrp = int.parse(amount) | 0x4000000000000000; // XRP and positive
          print('serializedData xrp: $xrp');
          value = (Uint8List(8)
                ..buffer.asByteData().setUint64(0, xrp, Endian.big))
              .toList();
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.fee:
          if (fee == null) continue;
          print('serializedData fee: $fee');
          var xrp = int.parse(fee) | 0x4000000000000000; // XRP and positive
          print('serializedData xrp: $xrp');
          value = (Uint8List(8)
                ..buffer.asByteData().setUint64(0, xrp, Endian.big))
              .toList();
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.flags:
          if (flags == null) continue;
          value = (Uint8List(4)
                ..buffer.asByteData().setUint32(0, flags, Endian.big))
              .toList();
          print('serializedData flags: $flags');
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.sequence:
          if (sequence == null) continue;
          value = (Uint8List(4)
                ..buffer.asByteData().setUint32(0, sequence, Endian.big))
              .toList();
          print('serializedData sequence: $sequence');
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.memos:
          if (memos == null) continue;
          value.addAll(XrpField.memos.fieldId);
          for (XrpMemoData memo in memos) {
            print('serializedData memo: $memo');
            value.addAll(memo.serializedData);
          }
          value.add(0xF1); // end array field id
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.signingPubKey:
          if (signingPubKey == null) continue;
          value = hex.decode(signingPubKey);
          print('serializedData signingPubKey: $signingPubKey');
          print('serializedData value: ${hex.encode(value)}');
          break;
        case XrpField.txnSignature:
          if (txnSignature == null) continue;
          value = hex.decode(txnSignature);
          print('serializedData txnSignature: $txnSignature');
          print('serializedData value: ${hex.encode(value)}');
          break;
        default:
          continue;
      }
      data.addAll(field.fieldId);
      if (field.type.isVLEncoded) data.addAll(value.xrpLengthPrefix());
      data.addAll(value);
    }

    /// workaround
    // return data.sublist(1);
    print('data ${hex.encode(data)}');
    return data;
  }

  XrpPaymentData(
      this.transactionType,
      this.account,
      this.destination,
      this.destinationTag,
      this.amount,
      this.fee,
      this.flags,
      this.sequence,
      this.memos,
      this.signingPubKey,
      this.txnSignature);

  XrpPaymentData.fromSerializedData(List<dynamic> list) {
    print('list: $list');
    print('list: ${hex.encode(list)}');
    List data = list;
    int offset = 0;
    // int offset = XrpField.memo.fieldId.length;
    while (data.length > offset) {
      int index = XrpField.values.indexWhere((element) {
        return areListsEqual(
            data.sublist(offset, offset + element.fieldId.length),
            element.fieldId);
      });
      print('index: ${index}');
      var field = index != -1 ? XrpField.values[index] : null;
      print('field: ${field}');
      if (field == null) {
        print("Invalid data");
        return;
      }
      offset += field.fieldId.length;
      print('offset: $offset');
      int variableLength = 0;
      if (field.type.isVLEncoded) {
        if (data[offset] < 193) {
          variableLength = data[offset];
          offset += 1;
        } else if (data[offset] < 241) {
          variableLength = data[offset] << 8 | data[offset + 1];
          offset += 2;
        } else if (data[offset] <= 254) {
          variableLength =
              data[offset] << 16 | data[offset + 1] << 8 | data[offset + 2];
          offset += 3;
        } else {
          print("Invalid data");
          return;
        }
      }
      print('offset: $offset');
      switch (field) {
        case XrpField.transactionType:
          int txTypeCode = ((data[offset]) << 8) | (data[offset + 1]);
          var xrpTransactionType = XrpTransactionType.values
              .firstWhere((element) => element.code == txTypeCode);
          var txType = xrpTransactionType;
          transactionType = txType.name;
          offset += 2;
          print('deserialize transactionType: ${transactionType}');
          break;
        case XrpField.account:
          List<int> accountId = data.sublist(offset, offset + variableLength);
          var address = accountId.xrpAccountIdToAddress();
          account = address;
          print('deserialize account: ${account}');
          print('deserialize accountId: ${accountId}');
          offset += variableLength;
          break;
        case XrpField.destination:
          List<int> accountId = data.sublist(offset, offset + variableLength);
          var address = accountId.xrpAccountIdToAddress();
          destination = address;
          offset += variableLength;
          print('deserialize destination: ${destination}');
          print('deserialize accountId: ${accountId}');
          break;
        case XrpField.destinationTag:
          destinationTag = ((data[offset]) << 24) |
              ((data[offset + 1]) << 16) |
              ((data[offset + 2]) << 8) |
              (data[offset + 3]);
          offset += 4;
          print('deserialize destinationTag: ${destinationTag}');
          break;
        case XrpField.amount:
          var isXRP = ((data[offset] & 0x80) == 0);
          if (isXRP) {
            var _amount = BigInt.parse(
                    "${hex.encode(data.sublist(offset, (offset + 8)).reversed.toList())}",
                    radix: 16)
                .toInt();
            print(
                'amount in hex : ${hex.encode(data.sublist(offset, (offset + 8)))}');
            print(
                'amount in hex reversed: ${hex.encode(data.sublist(offset, (offset + 8)).reversed.toList())}');
            print(
                'amount in BigInt: ${BigInt.parse(hex.encode(data.sublist(offset, (offset + 8)).reversed.toList()), radix: 16)}');
            _amount &= 0x3FFFFFFFFFFFFFFF;
            amount = "$_amount";
            print('deserialize amount: $amount');
            offset += 8;
          } else {
            continue;
          } // supports XRP only
          break;
        case XrpField.fee:
          var isXRP = ((data[offset] & 0x80) == 0);
          if (isXRP) {
            var _fee = decodeBigInt(
                    data.sublist(offset, (offset + 8)).reversed.toList())
                .toInt();
            _fee &= 0x3FFFFFFFFFFFFFFF;
            fee = "$_fee";
            print(
                'fee in hex : ${hex.encode(data.sublist(offset, (offset + 8)))}');
            print(
                'fee in hex reversed: ${hex.encode(data.sublist(offset, (offset + 8)).reversed.toList())}');
            print(
                'fee in BigInt: ${BigInt.parse(hex.encode(data.sublist(offset, (offset + 8)).reversed.toList()), radix: 16)}');
            print('deserialize fee: $fee');
            offset += 8;
          } else {
            continue;
          } // supports XRP only
          break;
        case XrpField.flags:
          flags = ((data[offset]) << 24) |
              ((data[offset + 1]) << 16) |
              ((data[offset + 2]) << 8) |
              (data[offset + 3]);
          offset += 4;
          print('deserialize flags: $flags');
          break;
        case XrpField.sequence:
          sequence = ((data[offset]) << 24) |
              ((data[offset + 1]) << 16) |
              ((data[offset + 2]) << 8) |
              (data[offset + 3]);
          offset += 4;
          print('deserialize sequence: $sequence');
          break;
        case XrpField.memos:
          List<XrpMemoData> _memos = [];
          while (data[offset] != 0xF1) {
            print('${data.sublist(offset).first}');
            print('${XrpField.memo.fieldId}');
            if (data.sublist(offset).first == XrpField.memo.fieldId) {
              offset += XrpField.memo.fieldId.length;
              String memoType = "";
              String memoData = "";
              String memoFormat;
              while (data[offset] != 0xE1) {
                var xrpField = XrpField.values.firstWhere(
                    (element) => data.sublist(offset).first == element.fieldId);
                var field = xrpField;
                offset += field.fieldId.length;
                var variableLength = 0;
                if (field.type.isVLEncoded) {
                  if (data[offset] < 193) {
                    variableLength = data[offset];
                    offset += 1;
                  } else if (data[offset] < 241) {
                    variableLength = data[offset] << 8 | data[offset + 1];
                    offset += 2;
                  } else if (data[offset] <= 254) {
                    variableLength = data[offset] << 16 |
                        data[offset + 1] << 8 |
                        data[offset + 2];
                    offset += 3;
                  } else {
                    print("Invalid data");
                    return;
                  }
                }
                if (field == XrpField.memoType) {
                  memoType = hex
                      .encode(data.sublist(offset, (offset + variableLength)));
                  offset += variableLength;
                } else if (field == XrpField.memoData) {
                  memoData = hex
                      .encode(data.sublist(offset, (offset + variableLength)));
                  offset += variableLength;
                } else if (field == XrpField.memoFormat) {
                  memoFormat = hex
                      .encode(data.sublist(offset, (offset + variableLength)));
                  offset += variableLength;
                } else {
                  print("Invalid data");
                  return;
                }
              }
              offset += 1;
              var _memo = XrpMemoData(memoType, memoData, memoFormat);
              print('deserialize memo: $_memo');
              _memos.add(_memo);
            } else {
              continue;
            }
          }
          offset += 1;
          memos = _memos;
          break;
        case XrpField.signingPubKey:
          List<int> pubkey = data.sublist(offset, offset + variableLength);
          signingPubKey = hex.encode(pubkey);
          offset += variableLength;
          print('deserialize signingPubKey: $signingPubKey');
          break;
        case XrpField.txnSignature:
          List<int> signature = data.sublist(offset, offset + variableLength);
          txnSignature = hex.encode(signature);
          offset += variableLength;
          print('deserialize txnSignature: $txnSignature');
          break;
        default:
          print("Invalid data");
          return;
      }
    }
  }
}
