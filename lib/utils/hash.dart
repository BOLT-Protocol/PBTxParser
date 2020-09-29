import 'dart:typed_data';

import 'package:pointycastle/export.dart';

Uint8List doubleSHA256(Uint8List data) {
  Uint8List buffer = SHA256Digest().process(SHA256Digest().process(data));
  return buffer;
}

Uint8List toHASH160(Uint8List data) {
  Uint8List buffer = RIPEMD160Digest().process(SHA256Digest().process(data));
  return buffer;
}
