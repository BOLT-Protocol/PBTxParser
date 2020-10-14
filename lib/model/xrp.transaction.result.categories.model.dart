enum XrpTxResultsCategorie {
  claimedCostOnly,
  failure,
  localError,
  malformedTransaction,
  retry,
  success
}

extension XrpTxResultsCategorieExt on XrpTxResultsCategorie {
  String get prefix {
    switch (this) {
      case XrpTxResultsCategorie.claimedCostOnly:
        return "tec";
        break;
      case XrpTxResultsCategorie.failure:
        return "tef";
        break;
      case XrpTxResultsCategorie.localError:
        return "tel";
        break;
      case XrpTxResultsCategorie.malformedTransaction:
        return "tem";
        break;
      case XrpTxResultsCategorie.retry:
        return "ter";
        break;
      case XrpTxResultsCategorie.success:
        return "tes";
        break;
    }
  }

  bool get isInvalid {
    switch (this) {
      case XrpTxResultsCategorie.claimedCostOnly:
        return false;
        break;
      case XrpTxResultsCategorie.failure:
        return true;
        break;
      case XrpTxResultsCategorie.localError:
        return true;
        break;
      case XrpTxResultsCategorie.malformedTransaction:
        return true;
        break;
      case XrpTxResultsCategorie.retry:
        return false;
        break;
      case XrpTxResultsCategorie.success:
        return false;
        break;
    }
  }
}
