enum XrpTxResult {
  tecNO_DST_INSUF_XRP,
  tesSUCCESS
  // too many, ...
}

extension XrpTxResultExt on XrpTxResult {
  String get name {
    switch (this) {
      case XrpTxResult.tecNO_DST_INSUF_XRP:
        return "tecNO_DST_INSUF_XRP";
        break;
      case XrpTxResult.tesSUCCESS:
        return "tesSUCCESS";
        break;
    }
  }
}
