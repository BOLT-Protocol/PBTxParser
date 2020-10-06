import 'dart:convert' show utf8;
import 'dart:typed_data';

import 'package:convert/convert.dart' show hex;
import 'package:quiver/check.dart';

bool isHexPrefixed(String str) {
  checkNotNull(str);

  return str.substring(0, 2) == '0x';
}

String stripHexPrefix(String str) {
  checkNotNull(str);

  return isHexPrefixed(str) ? str.substring(2) : str;
}

/// Pads a [String] to have an even length
String padToEven(String value) {
  checkNotNull(value);

  var a = "$value";

  if (a.length % 2 == 1) {
    a = "0$a";
  }

  return a;
}

/// Converts a [int] into a hex [String]
String intToHex(int i) {
  checkNotNull(i);

  return "0x${i.toRadixString(16)}";
}

/// Converts an [int] to a [Uint8List]
Uint8List intToBuffer(int i) {
  checkNotNull(i);

  return Uint8List.fromList(hex.decode(padToEven(intToHex(i).substring(2))));
}

/// Get the binary size of a string
int getBinarySize(String str) {
  checkNotNull(str);

  return utf8.encode(str).length;
}

/// Returns TRUE if the first specified array contains all elements
/// from the second one. FALSE otherwise.
bool arrayContainsArray(List superset, List subset, {bool some: false}) {
  checkNotNull(superset);
  checkNotNull(subset);

  if (some) {
    return Set.from(superset).intersection(Set.from(subset)).length > 0;
  } else {
    return Set.from(superset).containsAll(subset);
  }
}

/// Should be called to get utf8 from it's hex representation
String toUtf8(String hexString) {
  checkNotNull(hexString);

  var bufferValue = hex.decode(
      padToEven(stripHexPrefix(hexString).replaceAll(RegExp('^0+|0+\$'), '')));

  return utf8.decode(bufferValue);
}

/// Should be called to get ascii from it's hex representation
String toAscii(String hexString) {
  checkNotNull(hexString);

  var start = hexString.startsWith(RegExp('^0x')) ? 2 : 0;
  return String.fromCharCodes(hex.decode(hexString.substring(start)));
}

/// Should be called to get hex representation (prefixed by 0x) of utf8 string
String fromUtf8(String stringValue) {
  checkNotNull(stringValue);

  var stringBuffer = utf8.encode(stringValue);

  return "0x${padToEven(hex.encode(stringBuffer)).replaceAll(RegExp('^0+|0+\$'), '')}";
}

/// Should be called to get hex representation (prefixed by 0x) of ascii string
String fromAscii(String stringValue) {
  checkNotNull(stringValue);

  var hexString = ''; // eslint-disable-line
  for (var i = 0; i < stringValue.length; i++) {
    // eslint-disable-line
    var code = stringValue.codeUnitAt(i);
    var n = hex.encode([code]);
    hexString += n.length < 2 ? "0$n" : n;
  }

  return "0x$hexString";
}

/// Is the string a hex string.
bool isHexString(String value, {int length = 0}) {
  checkNotNull(value);
  print(RegExp('^[0-9A-Fa-f]*\$').hasMatch(value));

  if (!RegExp('^0x[0-9A-Fa-f]*\$').hasMatch(value) &&
      !RegExp('^[0-9A-Fa-f]*\$').hasMatch(value)) {
    return false;
  }

  if (length > 0 && value.length != 2 + 2 * length) {
    return false;
  }

  // if (!value.length.isEven) {
  //   return false;
  // }

  return true;
}

/// Decode a BigInt from bytes in big-endian encoding.
BigInt decodeBigInt(List<int> bytes) {
  BigInt result = new BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    result += new BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }
  return result;
}

/// Decode a BigInt from bytes in little-endian encoding.
BigInt decodeBigIntL(List<int> bytes) {
  List<int> revertedBytes = bytes.reversed.toList();
  BigInt result = new BigInt.from(0);
  for (int i = 0; i < revertedBytes.length; i++) {
    result +=
        new BigInt.from(revertedBytes[revertedBytes.length - i - 1]) << (8 * i);
  }
  return result;
}

/// Encode a BigInt into bytes using big-endian encoding.
Uint8List encodeBigInt(BigInt number) {
  var _byteMask = new BigInt.from(0xff);
  // Not handling negative numbers. Decide how you want to do that.
  int size = (number.bitLength + 7) >> 3;
  var result = new Uint8List(size);
  for (int i = 0; i < size; i++) {
    result[size - i - 1] = (number & _byteMask).toInt();
    number = number >> 8;
  }
  return result;
}

Uint8List toBuffer(dynamic data) {
  if (data is Uint8List) return data;

  if (data is String) {
    if (isHexString(data)) {
      return Uint8List.fromList(hex.decode(padToEven(stripHexPrefix(data))));
    } else {
      return Uint8List.fromList(utf8.encode(data));
    }
  } else if (data is int) {
    // if (data == 0) return Uint8List(0);

    return Uint8List.fromList(intToBuffer(data));
  } else if (data is BigInt) {
    // if (data == BigInt.zero) return Uint8List(0);

    return Uint8List.fromList(encodeBigInt(data));
  } else if (data is List<int>) {
    return Uint8List.fromList(data);
  }

  throw TypeError();
}

Uint8List decodeDER(Uint8List buffer) {
  // Uint8List buffer = toBuffer(der);
  Uint8List signature;
  List<int> r;
  List<int> s;
  int index = buffer.indexWhere((element) => element == 0x30);
  print('index: $index');
  index++;
  int totalLength = buffer[index];
  index++;
  print('totalLength: $totalLength');
  if (totalLength == buffer.sublist(index, buffer.length - 1).length) {
    index++;
    int rL = buffer[index];
    index++;
    print('rL: $rL');
    r = buffer.sublist(index, index + rL);
    index += rL;
    print('r[${hex.encode(r)}]: $r');
    index++;
    int sL = buffer[index];
    print('sL: $sL');
    index++;
    s = buffer.sublist(index, index + sL);
    print('s[${hex.encode(s)}]: $s');
    signature = toBuffer(r + s);
  } else {
    return null;
  }
  return signature;
}
