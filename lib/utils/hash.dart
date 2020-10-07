import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:bird_cryptography/bird_cryptography.dart' as bird;

Uint8List doubleSHA256(Uint8List data) {
  Uint8List buffer = SHA256Digest().process(SHA256Digest().process(data));
  return buffer;
}

Uint8List toHASH160(Uint8List data) {
  Uint8List buffer = RIPEMD160Digest().process(SHA256Digest().process(data));
  return buffer;
}

Uint8List keccak256(Uint8List data) {
  Uint8List buffer = SHA3Digest(256).process(data);
  return buffer;
}

List<int> keccak256Bird(List<int> data) {
  final bird.CryptographyHashes dartHashes = bird.CryptographyHashes.dart;
  final bird.CryptographyHash keccak256 = dartHashes.keccak256();
  List<int> keccak256Data = keccak256
      .digestRaw((data is Uint8List) ? data : Uint8List.fromList(data));
  return keccak256Data;
}
