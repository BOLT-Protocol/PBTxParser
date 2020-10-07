enum XrpFlag { tfFullyCanonicalSig }

extension XrpFlagExt on XrpFlag {
  int get value {
    switch (this) {
      case XrpFlag.tfFullyCanonicalSig:
        return 0x80000000;
    }
  }
}
