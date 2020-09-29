import 'dart:typed_data';
import 'dart:math';

import 'hash.dart';

import 'package:bs58check/src/utils/base.dart';

class Base58 {
  static const String Alphabet =
      '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  static const String XRPAlphabet =
      'rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz';

  Base base58;
  Base58.xrp() : base58 = new Base(XRPAlphabet);
  Base58() : base58 = new Base(Alphabet);

  String encode(Uint8List payload) {
    Uint8List hash = doubleSHA256(payload);
    Uint8List combine = Uint8List.fromList(
        [payload, hash.sublist(0, 4)].expand((i) => i).toList(growable: false));
    return base58.encode(combine);
  }

  Uint8List decodeRaw(Uint8List buffer) {
    Uint8List payload = buffer.sublist(0, buffer.length - 4);
    Uint8List checksum = buffer.sublist(buffer.length - 4);
    Uint8List newChecksum = doubleSHA256(payload);
    if (checksum[0] != newChecksum[0] ||
        checksum[1] != newChecksum[1] ||
        checksum[2] != newChecksum[2] ||
        checksum[3] != newChecksum[3]) {
      throw new ArgumentError("Invalid checksum");
    }
    return payload;
  }

  String getAddress(String inputString) {
    if (inputString.length > 27) {
      throw new ArgumentError("Can't create");
    }
    String string = '1' + inputString;
    for (var i = inputString.length; i < 34; i++) {
      final rng = Random.secure();
      string += (XRPAlphabet)[rng.nextInt(58)];
    }
    Uint8List buffer = base58.decode(string);
    Uint8List payload = buffer.sublist(0, buffer.length - 4);
    String address = encode(payload);
    return address;
  }

  Uint8List decode(String string) {
    Uint8List buffer = base58.decode(string);
    return decodeRaw(buffer);
  }
}
