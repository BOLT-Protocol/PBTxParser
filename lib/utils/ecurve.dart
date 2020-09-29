import 'dart:typed_data';

import 'utils.dart';
import 'package:hex/hex.dart';
import "package:pointycastle/ecc/curves/secp256k1.dart";
import "package:pointycastle/api.dart"
    show PrivateKeyParameter, PublicKeyParameter;
import 'package:pointycastle/ecc/api.dart'
    show ECPrivateKey, ECPublicKey, ECSignature, ECPoint;
import 'package:pointycastle/export.dart';
import "package:pointycastle/signers/ecdsa_signer.dart";
import 'package:pointycastle/macs/hmac.dart';
import "package:pointycastle/digests/sha256.dart";
// import 'package:pointycastle/src/utils.dart';

final ZERO32 = Uint8List.fromList(List.generate(32, (index) => 0));
final EC_GROUP_ORDER = HEX
    .decode("fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141");
final EC_P = HEX
    .decode("fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f");
final secp256k1 = new ECCurve_secp256k1();
final n = secp256k1.n;
final G = secp256k1.G;
BigInt nDiv2 = n >> 1;
const THROW_BAD_PRIVATE = 'Expected Private';
const THROW_BAD_POINT = 'Expected Point';
const THROW_BAD_TWEAK = 'Expected Tweak';
const THROW_BAD_HASH = 'Expected Hash';
const THROW_BAD_SIGNATURE = 'Expected Signature';

ECPoint _decompressKey(BigInt xBN, bool yBit, ECCurve c) {
  List<int> x9IntegerToBytes(BigInt s, int qLength) {
    //https://github.com/bcgit/bc-java/blob/master/core/src/main/java/org/bouncycastle/asn1/x9/X9IntegerConverter.java#L45
    final bytes = encodeBigInt(s);

    if (qLength < bytes.length) {
      return bytes.sublist(0, bytes.length - qLength);
    } else if (qLength > bytes.length) {
      final tmp = List<int>.filled(qLength, 0);

      final offset = qLength - bytes.length;
      for (var i = 0; i < bytes.length; i++) {
        tmp[i + offset] = bytes[i];
      }

      return tmp;
    }

    return bytes;
  }

  final compEnc = x9IntegerToBytes(xBN, 1 + ((c.fieldSize + 7) ~/ 8));
  compEnc[0] = yBit ? 0x03 : 0x02;
  return c.decodePoint(compEnc);
}

BigInt _recoverFromSignature(
    int recId, ECSignature sig, Uint8List msg, ECCurve_secp256k1 params) {
  final n = params.n;
  final i = BigInt.from(recId ~/ 2);
  final x = sig.r + (i * n);

  //Parameter q of curve
  final prime = decodeBigInt(EC_P);
  if (x.compareTo(prime) >= 0) return null;

  final R = _decompressKey(x, (recId & 1) == 1, params.curve);
  if (!(R * n).isInfinity) return null;

  final e = decodeBigInt(msg);

  final eInv = (BigInt.zero - e) % n;
  final rInv = sig.r.modInverse(n);
  final srInv = (rInv * sig.s) % n;
  final eInvrInv = (rInv * eInv) % n;

  final q = (params.G * eInvrInv) + (R * srInv);

  final bytes = q.getEncoded(false);
  return decodeBigInt(bytes.sublist(1));
}

bool isPrivate(Uint8List x) {
  if (!isScalar(x)) return false;
  return _compare(x, ZERO32) > 0 && // > 0
      _compare(x, EC_GROUP_ORDER) < 0; // < G
}

bool isPoint(Uint8List p) {
  if (p.length < 33) {
    return false;
  }
  var t = p[0];
  var x = p.sublist(1, 33);

  if (_compare(x, ZERO32) == 0) {
    return false;
  }
  if (_compare(x, EC_P) == 1) {
    return false;
  }
  try {
    decodeFrom(p);
  } catch (err) {
    return false;
  }
  if ((t == 0x02 || t == 0x03) && p.length == 33) {
    return true;
  }
  var y = p.sublist(33);
  if (_compare(y, ZERO32) == 0) {
    return false;
  }
  if (_compare(y, EC_P) == 1) {
    return false;
  }
  if (t == 0x04 && p.length == 65) {
    return true;
  }
  return false;
}

bool isScalar(Uint8List x) {
  return x.length == 32;
}

bool isOrderScalar(x) {
  if (!isScalar(x)) return false;
  return _compare(x, EC_GROUP_ORDER) < 0; // < G
}

bool isSignature(Uint8List value) {
  Uint8List r = value.sublist(0, 32);
  Uint8List s = value.sublist(32, 64);
  return value.length == 64 &&
      _compare(r, EC_GROUP_ORDER) < 0 &&
      _compare(s, EC_GROUP_ORDER) < 0;
}

bool _isPointCompressed(Uint8List p) {
  return p[0] != 0x04;
}

bool assumeCompression(bool value, Uint8List pubkey) {
  if (value == null && pubkey != null) return _isPointCompressed(pubkey);
  if (value == null) return true;
  return value;
}

Uint8List pointFromScalar(Uint8List d, bool _compressed) {
  if (!isPrivate(d)) throw new ArgumentError(THROW_BAD_PRIVATE);
  BigInt dd = fromBuffer(d);
  ECPoint pp = G * dd;
  if (pp.isInfinity) return null;
  return getEncoded(pp, _compressed);
}

Uint8List pointAddScalar(Uint8List p, Uint8List tweak, bool _compressed) {
  if (!isPoint(p)) throw new ArgumentError(THROW_BAD_POINT);
  if (!isOrderScalar(tweak)) throw new ArgumentError(THROW_BAD_TWEAK);
  bool compressed = assumeCompression(_compressed, p);
  ECPoint pp = decodeFrom(p);
  if (_compare(tweak, ZERO32) == 0) return getEncoded(pp, compressed);
  BigInt tt = fromBuffer(tweak);
  ECPoint qq = G * tt;
  ECPoint uu = pp + qq;
  if (uu.isInfinity) return null;
  return getEncoded(uu, compressed);
}

Uint8List privateAdd(Uint8List d, Uint8List tweak) {
  if (!isPrivate(d)) throw new ArgumentError(THROW_BAD_PRIVATE);
  if (!isOrderScalar(tweak)) throw new ArgumentError(THROW_BAD_TWEAK);
  BigInt dd = fromBuffer(d);
  BigInt tt = fromBuffer(tweak);
  Uint8List dt = toBuffer((dd + tt) % n);
  if (!isPrivate(dt)) return null;
  return dt;
}

// Uint8List sign(Uint8List sigHash, Uint8List privateKey) {
//   if (!isScalar(sigHash)) throw new ArgumentError(THROW_BAD_HASH);
//   if (!isPrivate(privateKey)) throw new ArgumentError(THROW_BAD_PRIVATE);
//   final signer = new ECDSASigner(null, new HMac(new SHA256Digest(), 64));
//   var pkp = new PrivateKeyParameter(
//       new ECPrivateKey(decodeBigInt(privateKey), secp256k1));
//   signer.init(true, pkp);
// //  signer.init(false, new PublicKeyParameter(new ECPublicKey(secp256k1.curve.decodePoint(x), secp256k1)));
//   ECSignature sig = signer.generateSignature(sigHash);
//   Uint8List buffer = new Uint8List(64);
//   buffer.setRange(0, 32, encodeBigInt(sig.r));
//   var s;
//   if (sig.s.compareTo(nDiv2) > 0) {
//     s = n - sig.s;
//   } else {
//     s = sig.s;
//   }
//   buffer.setRange(32, 64, encodeBigInt(s));
//   return buffer;
// }

ECSignature deterministicGenerateK(Uint8List hash, Uint8List x) {
  final signer = new ECDSASigner(null, new HMac(new SHA256Digest(), 64));
  var pkp =
      new PrivateKeyParameter(new ECPrivateKey(decodeBigInt(x), secp256k1));
  signer.init(true, pkp);
//  signer.init(false, new PublicKeyParameter(new ECPublicKey(secp256k1.curve.decodePoint(x), secp256k1)));
  return signer.generateSignature(hash);
}

/// Generates a public key for the given private key using the ecdsa curve which
/// Ethereum uses.
Uint8List privateKeyToPublic(BigInt privateKey) {
  final p = secp256k1.G * privateKey;

  //skip the type flag, https://github.com/ethereumjs/ethereumjs-util/blob/master/index.js#L319
  return Uint8List.view(p.getEncoded(false).buffer, 1);
}

class MsgSignature {
  final BigInt r;
  final BigInt s;
  final int v;

  MsgSignature(this.r, this.s, this.v);
}

MsgSignature sign(Uint8List hash, Uint8List x) {
  if (!isScalar(hash)) throw new ArgumentError(THROW_BAD_HASH);
  if (!isPrivate(x)) throw new ArgumentError(THROW_BAD_PRIVATE);
  ECSignature sig = deterministicGenerateK(hash, x);
  // Uint8List buffer = new Uint8List(64);
  // buffer.setRange(0, 32, encodeBigInt(sig.r));
  /*
	This is necessary because if a message can be signed by (r, s), it can also
	be signed by (r, -s (mod N)) which N being the order of the elliptic function
	used. In order to ensure transactions can't be tampered with (even though it
	would be harmless), Ethereum only accepts the signature with the lower value
	of s to make the signature for the message unique.
	More details at
	https://github.com/web3j/web3j/blob/master/crypto/src/main/java/org/web3j/crypto/ECDSASignature.java#L27
	 */
  if (sig.s.compareTo(secp256k1.n >> 1) > 0) {
    final canonicalisedS = secp256k1.n - sig.s;
    sig = ECSignature(sig.r, canonicalisedS);
  }
// buffer.setRange(32, 64, encodeBigInt(s));

  //https://github.com/web3j/web3j/blob/master/crypto/src/main/java/org/web3j/crypto/Sign.java
  final publicKey = decodeBigInt(privateKeyToPublic(decodeBigInt(x)));
  var recId = -1;
  for (var i = 0; i < 4; i++) {
    final k = _recoverFromSignature(i, sig, hash, secp256k1);
    if (k == publicKey) {
      recId = i;
      break;
    }
  }

  if (recId == -1) {
    throw Exception(
        'Could not construct a recoverable key. This should never happen');
  }
  return MsgSignature(sig.r, sig.s, recId + 27);
}

bool verify(Uint8List hash, Uint8List q, Uint8List signature) {
  if (!isScalar(hash)) throw new ArgumentError(THROW_BAD_HASH);
  if (!isPoint(q)) throw new ArgumentError(THROW_BAD_POINT);
  // 1.4.1 Enforce r and s are both integers in the interval [1, n − 1] (1, isSignature enforces '< n - 1')
  if (!isSignature(signature)) throw new ArgumentError(THROW_BAD_SIGNATURE);

  ECPoint Q = decodeFrom(q);
  BigInt r = fromBuffer(signature.sublist(0, 32));
  BigInt s = fromBuffer(signature.sublist(32, 64));

  final signer = new ECDSASigner(null, new HMac(new SHA256Digest(), 64));
  signer.init(false, new PublicKeyParameter(new ECPublicKey(Q, secp256k1)));
  return signer.verifySignature(hash, new ECSignature(r, s));
  /* STEP BY STEP
  // 1.4.1 Enforce r and s are both integers in the interval [1, n − 1] (2, enforces '> 0')
  if (r.compareTo(n) >= 0) return false;
  if (s.compareTo(n) >= 0) return false;

  // 1.4.2 H = Hash(M), already done by the user
  // 1.4.3 e = H
  BigInt e = fromBuffer(hash);

  BigInt sInv = s.modInverse(n);
  BigInt u1 = (e * sInv) % n;
  BigInt u2 = (r * sInv) % n;

  // 1.4.5 Compute R = (xR, yR)
  //               R = u1G + u2Q
  ECPoint R = G * u1 + Q * u2;

  // 1.4.5 (cont.) Enforce R is not at infinity
  if (R.isInfinity) return false;

  // 1.4.6 Convert the field element R.x to an integer
  BigInt xR = R.x.toBigInteger();

  // 1.4.7 Set v = xR mod n
  BigInt v = xR % n;

  // 1.4.8 If v = r, output "valid", and if v != r, output "invalid"
  return v.compareTo(r) == 0;
  */
}

BigInt fromBuffer(Uint8List d) {
  return decodeBigInt(d);
}

Uint8List toBuffer(BigInt d) {
  return encodeBigInt(d);
}

ECPoint decodeFrom(Uint8List P) {
  return secp256k1.curve.decodePoint(P);
}

Uint8List getEncoded(ECPoint P, compressed) {
  return P.getEncoded(compressed);
}

int _compare(Uint8List a, Uint8List b) {
  BigInt aa = fromBuffer(a);
  BigInt bb = fromBuffer(b);
  if (aa == bb) return 0;
  if (aa > bb) return 1;
  return -1;
}
