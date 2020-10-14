enum XrpInternalType {
  validation,
  done,
  hash128,
  blob,
  accountId,
  amount,
  hash256,
  uint8,
  vector256,
  stObject,
  unknown,
  transaction,
  hash160,
  pathSet,
  ledgerEntry,
  uint16,
  notPresent,
  uint64,
  uint32,
  stArray,
  metadata
}

extension XrpInternalTypeExt on XrpInternalType {
  String get name {
    switch (this) {
      case XrpInternalType.validation:
        return "Validation";
        break;
      case XrpInternalType.hash128:
        return "Hash128";
        break;
      case XrpInternalType.blob:
        return "Blob";
        break;
      case XrpInternalType.accountId:
        return "AccountID";
        break;
      case XrpInternalType.amount:
        return "Amount";
        break;
      case XrpInternalType.hash256:
        return "Hash256";
        break;
      case XrpInternalType.uint8:
        return "UInt8";
        break;
      case XrpInternalType.vector256:
        return "Vector256";
        break;
      case XrpInternalType.stObject:
        return "STObject";
        break;
      case XrpInternalType.transaction:
        return "Transaction";
        break;
      case XrpInternalType.hash160:
        return "Hash160";
        break;
      case XrpInternalType.pathSet:
        return "PathSet";
        break;
      case XrpInternalType.ledgerEntry:
        return "LedgerEntry";
        break;
      case XrpInternalType.uint16:
        return "UInt16";
        break;
      case XrpInternalType.notPresent:
        return "NotPresent";
        break;
      case XrpInternalType.uint64:
        return "UInt64";
        break;
      case XrpInternalType.uint32:
        return "UInt32";
        break;
      case XrpInternalType.stArray:
        return "STArray";
        break;
      case XrpInternalType.metadata:
        return "Metadata";
        break;
      case XrpInternalType.done:
        return "Done";
        break;
      case XrpInternalType.unknown:
        return "Unknown";
        break;
    }
  }

  int get code {
    switch (this) {
      case XrpInternalType.validation:
        return 10003;
        break;
      case XrpInternalType.hash128:
        return 4;
        break;
      case XrpInternalType.blob:
        return 7;
        break;
      case XrpInternalType.accountId:
        return 8;
        break;
      case XrpInternalType.amount:
        return 6;
        break;
      case XrpInternalType.hash256:
        return 5;
        break;
      case XrpInternalType.uint8:
        return 16;
        break;
      case XrpInternalType.vector256:
        return 19;
        break;
      case XrpInternalType.stObject:
        return 14;
        break;
      case XrpInternalType.transaction:
        return 10001;
        break;
      case XrpInternalType.hash160:
        return 17;
        break;
      case XrpInternalType.pathSet:
        return 18;
        break;
      case XrpInternalType.ledgerEntry:
        return 10002;
        break;
      case XrpInternalType.uint16:
        return 1;
        break;
      case XrpInternalType.notPresent:
        return 0;
        break;
      case XrpInternalType.uint64:
        return 3;
        break;
      case XrpInternalType.uint32:
        return 2;
        break;
      case XrpInternalType.stArray:
        return 15;
        break;
      case XrpInternalType.metadata:
        return 10004;
        break;
      case XrpInternalType.unknown:
        return -2;
        break;
      case XrpInternalType.done:
        return -1;
        break;
    }
  }

  bool get isVLEncoded {
    switch (this) {
      case XrpInternalType.blob:
      case XrpInternalType.accountId:
      case XrpInternalType.vector256:
        return true;
        break;
      default:
        return false;
        break;
    }
  }
}
