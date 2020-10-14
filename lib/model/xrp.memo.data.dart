import 'xrp.field.model.dart';
import 'xrp.internal.type.model.dart';
import 'package:convert/convert.dart' show hex;
import '../utils/extensions.dart';

class XrpMemoData {
  String memoType; // uppercase hex string
  String memoData; // uppercase hex string
  String memoFormat; // uppercase hex string

  Map<String, dynamic> get map {
    Map<String, dynamic> map = {};
    (memoType != null) ? map[XrpField.memoType.name] = memoType : null;
    (memoData != null) ? map[XrpField.memoData.name] = memoData : null;
    (memoFormat != null) ? map[XrpField.memoFormat.name] = memoFormat : null;
    return map;
  }

  List<int> get serializedData {
    List<int> data = [];
    data.addAll(XrpField.memo.fieldId);
    List fields = [XrpField.memoType, XrpField.memoData, XrpField.memoFormat];
    for (XrpField field in fields) {
      List<int> value = [];
      switch (field) {
        case XrpField.memoType:
          if (memoType == null) continue;
          value = hex.decode(memoType);
          break;
        case XrpField.memoData:
          if (memoData == null) continue;
          value = hex.decode(memoData);
          break;
        case XrpField.memoFormat:
          if (memoFormat == null) continue;
          value = hex.decode(memoFormat);
          break;
        default:
          continue;
      }
      data.addAll(field.fieldId);
      if (field.type.isVLEncoded) data.addAll(value.xrpLengthPrefix());
      data.addAll(value);
    }
    data.add(0xE1); // object end field id
    return data;
  }

  XrpMemoData(this.memoType, this.memoData, this.memoFormat);

  XrpMemoData.fromSerializedData(List<dynamic> list) {
    List data = list;
    if (data.sublist(0, XrpField.memo.fieldId.length) !=
            XrpField.memo.fieldId ||
        data.last != 0xE1) {
      // 0xE1: end object field id
      print("Invalid data");
      return;
    }
    int offset = XrpField.memo.fieldId.length;
    while (data[offset] != 0xE1) {
      var field = XrpField.values.firstWhere((element) {
        return data.sublist(offset, element.fieldId.length) != element.fieldId;
      });
      if (field == null) {
        print("Invalid data");
        return;
      }
      offset += field.fieldId.length;
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
      switch (field) {
        case XrpField.memoType:
          memoType = hex
              .encode(data.sublist(offset, offset + variableLength))
              .toUpperCase();
          offset += variableLength;
          break;
        case XrpField.memoData:
          memoData = hex
              .encode(data.sublist(offset, offset + variableLength))
              .toUpperCase();
          offset += variableLength;
          break;
        case XrpField.memoFormat:
          memoFormat = hex
              .encode(data.sublist(offset, offset + variableLength))
              .toUpperCase();
          offset += variableLength;
          break;
        default:
          print("Invalid data");
          return;
      }
    }
  }
}
