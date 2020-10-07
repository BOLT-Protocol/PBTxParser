enum XrpTransactionType {
  accountSet,
  accountDelete,
  checkCancel,
  checkCash,
  checkCreate,
  depositPreauth,
  escrowCancel,
  escrowCreate,
  escrowFinish,
  offerCancel,
  offerCreate,
  payment,
  paymentChannelClaim,
  paymentChannelCreate,
  paymentChannelFund,
  setRegularKey,
  signerListSet,
  trustSet,
  nicknameSet,
  contract,
  ticketCreate,
  ticketCancel,
  enableAmendment,
  setFee
}

extension XrpTransactionTypeExt on XrpTransactionType {
  String get name {
    switch (this) {
      case XrpTransactionType.accountSet:
        return "AccountSet";
        break;
      case XrpTransactionType.accountDelete:
        return "AccountDelete";
        break;
      case XrpTransactionType.checkCancel:
        return "CheckCancel";
        break;
      case XrpTransactionType.checkCash:
        return "CheckCash";
        break;
      case XrpTransactionType.checkCreate:
        return "CheckCreate";
        break;
      case XrpTransactionType.depositPreauth:
        return "DepositPreauth";
        break;
      case XrpTransactionType.escrowCancel:
        return "EscrowCancel";
        break;
      case XrpTransactionType.escrowCreate:
        return "EscrowCreate";
        break;
      case XrpTransactionType.escrowFinish:
        return "EscrowFinish";
        break;
      case XrpTransactionType.offerCancel:
        return "OfferCancel";
        break;
      case XrpTransactionType.offerCreate:
        return "OfferCreate";
        break;
      case XrpTransactionType.payment:
        return "Payment";
        break;
      case XrpTransactionType.paymentChannelClaim:
        return "PaymentChannelClaim";
        break;
      case XrpTransactionType.paymentChannelCreate:
        return "PaymentChannelCreate";
        break;
      case XrpTransactionType.paymentChannelFund:
        return "PaymentChannelFund";
        break;
      case XrpTransactionType.setRegularKey:
        return "SetRegularKey";
        break;
      case XrpTransactionType.signerListSet:
        return "SignerListSet";
        break;
      case XrpTransactionType.trustSet:
        return "TrustSet";
        break;
      case XrpTransactionType.nicknameSet:
        return "NickNameSet";
        break;
      case XrpTransactionType.contract:
        return "Contract";
        break;
      case XrpTransactionType.ticketCreate:
        return "TicketCreate";
        break;
      case XrpTransactionType.ticketCancel:
        return "TicketCancel";
        break;
      case XrpTransactionType.enableAmendment:
        return "EnableAmendment";
        break;
      case XrpTransactionType.setFee:
        return "SetFee";
        break;
    }
  }

  int get code {
    switch (this) {
      case XrpTransactionType.accountSet:
        return 3;
        break;
      case XrpTransactionType.accountDelete:
        return 21;
        break;
      case XrpTransactionType.checkCancel:
        return 18;
        break;
      case XrpTransactionType.checkCash:
        return 17;
        break;
      case XrpTransactionType.checkCreate:
        return 16;
        break;
      case XrpTransactionType.depositPreauth:
        return 19;
        break;
      case XrpTransactionType.escrowCancel:
        return 4;
        break;
      case XrpTransactionType.escrowCreate:
        return 1;
        break;
      case XrpTransactionType.escrowFinish:
        return 2;
        break;
      case XrpTransactionType.offerCancel:
        return 8;
        break;
      case XrpTransactionType.offerCreate:
        return 7;
        break;
      case XrpTransactionType.payment:
        return 0;
        break;
      case XrpTransactionType.paymentChannelClaim:
        return 15;
        break;
      case XrpTransactionType.paymentChannelCreate:
        return 13;
        break;
      case XrpTransactionType.paymentChannelFund:
        return 14;
        break;
      case XrpTransactionType.setRegularKey:
        return 5;
        break;
      case XrpTransactionType.signerListSet:
        return 12;
        break;
      case XrpTransactionType.trustSet:
        return 20;
        break;
      case XrpTransactionType.nicknameSet:
        return 6;
        break;
      case XrpTransactionType.contract:
        return 9;
        break;
      case XrpTransactionType.ticketCreate:
        return 10;
        break;
      case XrpTransactionType.ticketCancel:
        return 11;
        break;
      case XrpTransactionType.enableAmendment:
        return 100;
        break;
      case XrpTransactionType.setFee:
        return 101;
        break;
    }
  }
}
