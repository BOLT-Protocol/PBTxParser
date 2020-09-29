import 'dart:typed_data';

class Output {
  /* value in bitcoins of the output (inSatoshi)*/
  BigInt amount; // only accept bigInt or Uint8List
  /* the address or public key of the recipient */
  Uint8List script;

  Output(this.amount, this.script);

  Uint8List get amountInBuffer => Uint8List(8)
    ..buffer.asByteData().setUint64(0, this.amount.toInt(), Endian.little);

  //TODO bufferToAmount
}
