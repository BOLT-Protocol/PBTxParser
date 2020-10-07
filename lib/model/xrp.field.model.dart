import 'xrp.internal.type.model.dart';

enum XrpField {
  generic,
  ledgerEntry,
  transaction,
  validation,
  metadata,
  hash,
  index_,
  closeResolution,
  method,
  transactionResult,
  tickSize,
  ledgerEntryType,
  transactionType,
  signerWeight,
  version,
  flags,
  sourceTag,
  sequence,
  previousTxnLgrSeq,
  ledgerSequence,
  closeTime,
  parentCloseTime,
  signingTime,
  expiration,
  transferRate,
  walletSize,
  ownerCount,
  destinationTag,
  highQualityIn,
  highQualityOut,
  lowQualityIn,
  lowQualityOut,
  qualityIn,
  qualityOut,
  stampEscrow,
  bondAmount,
  loadFee,
  offerSequence,
  firstLedgerSequence,
  lastLedgerSequence,
  transactionIndex,
  operationLimit,
  referenceFeeUnits,
  reserveBase,
  reserveIncrement,
  setFlag,
  clearFlag,
  signerQuorum,
  cancelAfetr,
  finishAfter,
  signerListId,
  settleDelay,
  indexNext,
  indexPrevious,
  bookNode,
  ownerNode,
  baseFee,
  exchangeRate,
  lowNode,
  highNode,
  destinationNode,
  cookie,
  emailHash,
  takerPaysCurrency,
  takerPaysIssuer,
  takerGetCurrency,
  takerGetsIssuer,
  ledgerHash,
  parentHash,
  transactionHash,
  accountHash,
  previousTxnId,
  ledgerIndex,
  walletLocator,
  rootIndex,
  accountTxnId,
  bookDirectory,
  invoiceId,
  nickname,
  amendment,
  ticketId,
  digest,
  payChannel,
  consensusHash,
  checkId,
  amount,
  balance,
  limitAmount,
  takerPays,
  takerGets,
  lowLimit,
  highLimit,
  fee,
  sendMax,
  deliverMin,
  minimumOffer,
  rippleEscrow,
  deliveredAmount,
  publicKey,
  messageKey,
  signingPubKey,
  txnSignature,
  signature,
  domain,
  fundCode,
  removeCode,
  expireCode,
  createCode,
  memoType,
  memoData,
  memoFormat,
  fulfillment,
  condition,
  masterSignature,
  account,
  owner,
  destination,
  issuer,
  authorize,
  unauthorize,
  target,
  regularKey,
  paths,
  indexes,
  hashes,
  amendments,
  transactionMetaData,
  createdNode,
  deletedNode,
  modifiedNode,
  previousFields,
  finalFields,
  newFields,
  templateEntry,
  memo,
  signerEntry,
  signer,
  majority,
  signingAccounts,
  signers,
  signerEntries,
  template,
  necessary,
  sufficient,
  affectedNodes,
  memos,
  majorities
}

extension XrpFieldExt on XrpField {
  String get name {
    switch (this) {
      case XrpField.generic:
        return "Generic";
        break;
      case XrpField.ledgerEntry:
        return "LedgerEntry";
        break;
      case XrpField.transaction:
        return "Transaction";
        break;
      case XrpField.validation:
        return "Validation";
        break;
      case XrpField.metadata:
        return "Metadata";
        break;
      case XrpField.hash:
        return "hash";
        break;
      case XrpField.index_:
        return "index";
        break;
      case XrpField.closeResolution:
        return "CloseResolution";
        break;
      case XrpField.method:
        return "Method";
        break;
      case XrpField.transactionResult:
        return "TransactionResult";
        break;
      case XrpField.tickSize:
        return "TickSize";
        break;
      case XrpField.ledgerEntryType:
        return "LedgerEntryType";
        break;
      case XrpField.transactionType:
        return "TransactionType";
        break;
      case XrpField.signerWeight:
        return "SignerWeight";
        break;
      case XrpField.version:
        return "Version";
        break;
      case XrpField.flags:
        return "Flags";
        break;
      case XrpField.sourceTag:
        return "SourceTag";
        break;
      case XrpField.sequence:
        return "Sequence";
        break;
      case XrpField.previousTxnLgrSeq:
        return "PreviousTxnLgrSeq";
        break;
      case XrpField.ledgerSequence:
        return "LedgerSequence";
        break;
      case XrpField.closeTime:
        return "CloseTime";
        break;
      case XrpField.parentCloseTime:
        return "ParentCloseTime";
        break;
      case XrpField.signingTime:
        return "SigningTime";
        break;
      case XrpField.expiration:
        return "Expiration";
        break;
      case XrpField.transferRate:
        return "TransferRate";
        break;
      case XrpField.walletSize:
        return "WalletSize";
        break;
      case XrpField.ownerCount:
        return "OwnerCount";
        break;
      case XrpField.destinationTag:
        return "DestinationTag";
        break;
      case XrpField.highQualityIn:
        return "HighQualityIn";
        break;
      case XrpField.highQualityOut:
        return "HighQualityOut";
        break;
      case XrpField.lowQualityIn:
        return "LowQualityIn";
        break;
      case XrpField.lowQualityOut:
        return "LowQualityOut";
        break;
      case XrpField.qualityIn:
        return "QualityIn";
        break;
      case XrpField.qualityOut:
        return "QualityOut";
        break;
      case XrpField.stampEscrow:
        return "StampEscrow";
        break;
      case XrpField.bondAmount:
        return "BondAmount";
        break;
      case XrpField.loadFee:
        return "LoadFee";
        break;
      case XrpField.offerSequence:
        return "OfferSequence";
        break;
      case XrpField.firstLedgerSequence:
        return "FirstLedgerSequence";
        break;
      case XrpField.lastLedgerSequence:
        return "LastLedgerSequence";
        break;
      case XrpField.transactionIndex:
        return "TransactionIndex";
        break;
      case XrpField.operationLimit:
        return "OperationLimit";
        break;
      case XrpField.referenceFeeUnits:
        return "ReferenceFeeUnits";
        break;
      case XrpField.reserveBase:
        return "ReserveBase";
        break;
      case XrpField.reserveIncrement:
        return "ReserveIncrement";
        break;
      case XrpField.setFlag:
        return "SetFlag";
        break;
      case XrpField.clearFlag:
        return "ClearFlag";
        break;
      case XrpField.signerQuorum:
        return "SignerQuorum";
        break;
      case XrpField.cancelAfetr:
        return "CancelAfter";
        break;
      case XrpField.finishAfter:
        return "FinishAfter";
        break;
      case XrpField.signerListId:
        return "SignerListID";
        break;
      case XrpField.settleDelay:
        return "SettleDelay";
        break;
      case XrpField.indexNext:
        return "IndexNext";
        break;
      case XrpField.indexPrevious:
        return "IndexPrevious";
        break;
      case XrpField.bookNode:
        return "BookNode";
        break;
      case XrpField.ownerNode:
        return "OwnerNode";
        break;
      case XrpField.baseFee:
        return "BaseFee";
        break;
      case XrpField.exchangeRate:
        return "ExchangeRate";
        break;
      case XrpField.lowNode:
        return "LowNode";
        break;
      case XrpField.highNode:
        return "HighNode";
        break;
      case XrpField.destinationNode:
        return "DestinationNode";
        break;
      case XrpField.cookie:
        return "Cookie";
        break;
      case XrpField.emailHash:
        return "EmailHash";
        break;
      case XrpField.takerPaysCurrency:
        return "TakerPaysCurrency";
        break;
      case XrpField.takerPaysIssuer:
        return "TakerPaysIssuer";
        break;
      case XrpField.takerGetCurrency:
        return "TakerGetsCurrency";
        break;
      case XrpField.takerGetsIssuer:
        return "TakerGetsIssuer";
        break;
      case XrpField.ledgerHash:
        return "LedgerHash";
        break;
      case XrpField.parentHash:
        return "ParentHash";
        break;
      case XrpField.transactionHash:
        return "TransactionHash";
        break;
      case XrpField.accountHash:
        return "AccountHash";
        break;
      case XrpField.previousTxnId:
        return "PreviousTxnID";
        break;
      case XrpField.ledgerIndex:
        return "LedgerIndex";
        break;
      case XrpField.walletLocator:
        return "WalletLocator";
        break;
      case XrpField.rootIndex:
        return "RootIndex";
        break;
      case XrpField.accountTxnId:
        return "AccountTxnID";
        break;
      case XrpField.bookDirectory:
        return "BookDirectory";
        break;
      case XrpField.invoiceId:
        return "InvoiceID";
        break;
      case XrpField.nickname:
        return "Nickname";
        break;
      case XrpField.amendment:
        return "Amendment";
        break;
      case XrpField.ticketId:
        return "TicketID";
        break;
      case XrpField.digest:
        return "Digest";
        break;
      case XrpField.payChannel:
        return "Channel";
        break;
      case XrpField.consensusHash:
        return "ConsensusHash";
        break;
      case XrpField.checkId:
        return "CheckID";
        break;
      case XrpField.amount:
        return "Amount";
        break;
      case XrpField.balance:
        return "Balance";
        break;
      case XrpField.limitAmount:
        return "LimitAmount";
        break;
      case XrpField.takerPays:
        return "TakerPays";
        break;
      case XrpField.takerGets:
        return "TakerGets";
        break;
      case XrpField.lowLimit:
        return "LowLimit";
        break;
      case XrpField.highLimit:
        return "HighLimit";
        break;
      case XrpField.fee:
        return "Fee";
        break;
      case XrpField.sendMax:
        return "SendMax";
        break;
      case XrpField.deliverMin:
        return "DeliverMin";
        break;
      case XrpField.minimumOffer:
        return "MinimumOffer";
        break;
      case XrpField.rippleEscrow:
        return "RippleEscrow";
        break;
      case XrpField.deliveredAmount:
        return "DeliveredAmount";
        break;
      case XrpField.publicKey:
        return "PublicKey";
        break;
      case XrpField.messageKey:
        return "MessageKey";
        break;
      case XrpField.signingPubKey:
        return "SigningPubKey";
        break;
      case XrpField.txnSignature:
        return "TxnSignature";
        break;
      case XrpField.signature:
        return "Signature";
        break;
      case XrpField.domain:
        return "Domain";
        break;
      case XrpField.fundCode:
        return "FundCode";
        break;
      case XrpField.removeCode:
        return "RemoveCode";
        break;
      case XrpField.expireCode:
        return "ExpireCode";
        break;
      case XrpField.createCode:
        return "CreateCode";
        break;
      case XrpField.memoType:
        return "MemoType";
        break;
      case XrpField.memoData:
        return "MemoData";
        break;
      case XrpField.memoFormat:
        return "MemoFormat";
        break;
      case XrpField.fulfillment:
        return "Fulfillment";
        break;
      case XrpField.condition:
        return "Condition";
        break;
      case XrpField.masterSignature:
        return "MasterSignature";
        break;
      case XrpField.account:
        return "Account";
        break;
      case XrpField.owner:
        return "Owner";
        break;
      case XrpField.destination:
        return "Destination";
        break;
      case XrpField.issuer:
        return "Issuer";
        break;
      case XrpField.authorize:
        return "Authorize";
        break;
      case XrpField.unauthorize:
        return "Unauthorize";
        break;
      case XrpField.target:
        return "Target";
        break;
      case XrpField.regularKey:
        return "RegularKey";
        break;
      case XrpField.paths:
        return "Paths";
        break;
      case XrpField.indexes:
        return "Indexes";
        break;
      case XrpField.hashes:
        return "Hashes";
        break;
      case XrpField.amendments:
        return "Amendments";
        break;
      case XrpField.transactionMetaData:
        return "TransactionMetaData";
        break;
      case XrpField.createdNode:
        return "CreatedNode";
        break;
      case XrpField.deletedNode:
        return "DeletedNode";
        break;
      case XrpField.modifiedNode:
        return "ModifiedNode";
        break;
      case XrpField.previousFields:
        return "PreviousFields";
        break;
      case XrpField.finalFields:
        return "FinalFields";
        break;
      case XrpField.newFields:
        return "NewFields";
        break;
      case XrpField.templateEntry:
        return "TemplateEntry";
        break;
      case XrpField.memo:
        return "Memo";
        break;
      case XrpField.signerEntry:
        return "SignerEntry";
        break;
      case XrpField.signer:
        return "Signer";
        break;
      case XrpField.majority:
        return "Majority";
        break;
      case XrpField.signingAccounts:
        return "SigningAccounts";
        break;
      case XrpField.signers:
        return "Signers";
        break;
      case XrpField.signerEntries:
        return "SignerEntries";
        break;
      case XrpField.template:
        return "Template";
        break;
      case XrpField.necessary:
        return "Necessary";
        break;
      case XrpField.sufficient:
        return "Sufficient";
        break;
      case XrpField.affectedNodes:
        return "AffectedNodes";
        break;
      case XrpField.memos:
        return "Memos";
        break;
      case XrpField.majorities:
        return "Majorities";
        break;
    }
  }

  int get code {
    switch (this) {
      case XrpField.generic:
        return 0;
        break;
      case XrpField.ledgerEntry:
      case XrpField.transaction:
      case XrpField.validation:
      case XrpField.metadata:
      case XrpField.hash:
        return 257;
        break;
      case XrpField.index_:
        return 258;
        break;
      case XrpField.closeResolution:
        return 1;
        break;
      case XrpField.method:
        return 2;
        break;
      case XrpField.transactionResult:
        return 3;
        break;
      case XrpField.tickSize:
        return 16;
        break;
      case XrpField.ledgerEntryType:
        return 1;
        break;
      case XrpField.transactionType:
        return 2;
        break;
      case XrpField.signerWeight:
        return 3;
        break;
      case XrpField.version:
        return 16;
        break;
      case XrpField.flags:
        return 2;
        break;
      case XrpField.sourceTag:
        return 3;
        break;
      case XrpField.sequence:
        return 4;
        break;
      case XrpField.previousTxnLgrSeq:
        return 5;
        break;
      case XrpField.ledgerSequence:
        return 6;
        break;
      case XrpField.closeTime:
        return 7;
        break;
      case XrpField.parentCloseTime:
        return 8;
        break;
      case XrpField.signingTime:
        return 9;
        break;
      case XrpField.expiration:
        return 10;
        break;
      case XrpField.transferRate:
        return 11;
        break;
      case XrpField.walletSize:
        return 12;
        break;
      case XrpField.ownerCount:
        return 13;
        break;
      case XrpField.destinationTag:
        return 14;
        break;
      case XrpField.highQualityIn:
        return 16;
        break;
      case XrpField.highQualityOut:
        return 17;
        break;
      case XrpField.lowQualityIn:
        return 18;
        break;
      case XrpField.lowQualityOut:
        return 19;
        break;
      case XrpField.qualityIn:
        return 20;
        break;
      case XrpField.qualityOut:
        return 21;
        break;
      case XrpField.stampEscrow:
        return 22;
        break;
      case XrpField.bondAmount:
        return 23;
        break;
      case XrpField.loadFee:
        return 24;
        break;
      case XrpField.offerSequence:
        return 25;
        break;
      case XrpField.firstLedgerSequence:
        return 26;
        break;
      case XrpField.lastLedgerSequence:
        return 27;
        break;
      case XrpField.transactionIndex:
        return 28;
        break;
      case XrpField.operationLimit:
        return 29;
        break;
      case XrpField.referenceFeeUnits:
        return 30;
        break;
      case XrpField.reserveBase:
        return 31;
        break;
      case XrpField.reserveIncrement:
        return 32;
        break;
      case XrpField.setFlag:
        return 33;
        break;
      case XrpField.clearFlag:
        return 34;
        break;
      case XrpField.signerQuorum:
        return 35;
        break;
      case XrpField.cancelAfetr:
        return 36;
        break;
      case XrpField.finishAfter:
        return 38;
        break;
      case XrpField.signerListId:
        return 38;
        break;
      case XrpField.settleDelay:
        return 39;
        break;
      case XrpField.indexNext:
        return 1;
        break;
      case XrpField.indexPrevious:
        return 2;
        break;
      case XrpField.bookNode:
        return 3;
        break;
      case XrpField.ownerNode:
        return 4;
        break;
      case XrpField.baseFee:
        return 5;
        break;
      case XrpField.exchangeRate:
        return 6;
        break;
      case XrpField.lowNode:
        return 7;
        break;
      case XrpField.highNode:
        return 8;
        break;
      case XrpField.destinationNode:
        return 9;
        break;
      case XrpField.cookie:
        return 10;
        break;
      case XrpField.emailHash:
        return 1;
        break;
      case XrpField.takerPaysCurrency:
        return 1;
        break;
      case XrpField.takerPaysIssuer:
        return 2;
        break;
      case XrpField.takerGetCurrency:
        return 3;
        break;
      case XrpField.takerGetsIssuer:
        return 4;
        break;
      case XrpField.ledgerHash:
        return 1;
        break;
      case XrpField.parentHash:
        return 2;
        break;
      case XrpField.transactionHash:
        return 3;
        break;
      case XrpField.accountHash:
        return 4;
        break;
      case XrpField.previousTxnId:
        return 5;
        break;
      case XrpField.ledgerIndex:
        return 6;
        break;
      case XrpField.walletLocator:
        return 7;
        break;
      case XrpField.rootIndex:
        return 8;
        break;
      case XrpField.accountTxnId:
        return 9;
        break;
      case XrpField.bookDirectory:
        return 16;
        break;
      case XrpField.invoiceId:
        return 17;
        break;
      case XrpField.nickname:
        return 18;
        break;
      case XrpField.amendment:
        return 19;
        break;
      case XrpField.ticketId:
        return 20;
        break;
      case XrpField.digest:
        return 21;
        break;
      case XrpField.payChannel:
        return 22;
        break;
      case XrpField.consensusHash:
        return 23;
        break;
      case XrpField.checkId:
        return 24;
        break;
      case XrpField.amount:
        return 1;
        break;
      case XrpField.balance:
        return 2;
        break;
      case XrpField.limitAmount:
        return 3;
        break;
      case XrpField.takerPays:
        return 4;
        break;
      case XrpField.takerGets:
        return 5;
        break;
      case XrpField.lowLimit:
        return 6;
        break;
      case XrpField.highLimit:
        return 7;
        break;
      case XrpField.fee:
        return 8;
        break;
      case XrpField.sendMax:
        return 9;
        break;
      case XrpField.deliverMin:
        return 10;
        break;
      case XrpField.minimumOffer:
        return 16;
        break;
      case XrpField.rippleEscrow:
        return 17;
        break;
      case XrpField.deliveredAmount:
        return 18;
        break;
      case XrpField.publicKey:
        return 1;
        break;
      case XrpField.messageKey:
        return 2;
        break;
      case XrpField.signingPubKey:
        return 3;
        break;
      case XrpField.txnSignature:
        return 4;
        break;
      case XrpField.signature:
        return 6;
        break;
      case XrpField.domain:
        return 7;
        break;
      case XrpField.fundCode:
        return 8;
        break;
      case XrpField.removeCode:
        return 9;
        break;
      case XrpField.expireCode:
        return 10;
        break;
      case XrpField.createCode:
        return 11;
        break;
      case XrpField.memoType:
        return 12;
        break;
      case XrpField.memoData:
        return 13;
        break;
      case XrpField.memoFormat:
        return 14;
        break;
      case XrpField.fulfillment:
        return 16;
        break;
      case XrpField.condition:
        return 17;
        break;
      case XrpField.masterSignature:
        return 18;
        break;
      case XrpField.account:
        return 1;
        break;
      case XrpField.owner:
        return 2;
        break;
      case XrpField.destination:
        return 3;
        break;
      case XrpField.issuer:
        return 4;
        break;
      case XrpField.authorize:
        return 5;
        break;
      case XrpField.unauthorize:
        return 6;
        break;
      case XrpField.target:
        return 7;
        break;
      case XrpField.regularKey:
        return 8;
        break;
      case XrpField.paths:
        return 1;
        break;
      case XrpField.indexes:
        return 1;
        break;
      case XrpField.hashes:
        return 2;
        break;
      case XrpField.amendments:
        return 3;
        break;
      case XrpField.transactionMetaData:
        return 2;
        break;
      case XrpField.createdNode:
        return 3;
        break;
      case XrpField.deletedNode:
        return 4;
        break;
      case XrpField.modifiedNode:
        return 5;
        break;
      case XrpField.previousFields:
        return 6;
        break;
      case XrpField.finalFields:
        return 7;
        break;
      case XrpField.newFields:
        return 8;
        break;
      case XrpField.templateEntry:
        return 9;
        break;
      case XrpField.memo:
        return 10;
        break;
      case XrpField.signerEntry:
        return 11;
        break;
      case XrpField.signer:
        return 16;
        break;
      case XrpField.majority:
        return 18;
        break;
      case XrpField.signingAccounts:
        return 2;
        break;
      case XrpField.signers:
        return 3;
        break;
      case XrpField.signerEntries:
        return 4;
        break;
      case XrpField.template:
        return 5;
        break;
      case XrpField.necessary:
        return 6;
        break;
      case XrpField.sufficient:
        return 7;
        break;
      case XrpField.affectedNodes:
        return 8;
        break;
      case XrpField.memos:
        return 9;
        break;
      case XrpField.majorities:
        return 16;
        break;
    }
  }

  XrpInternalType get type {
    switch (this) {
      case XrpField.generic:
        return XrpInternalType.unknown;
        break;
      case XrpField.ledgerEntry:
        return XrpInternalType.ledgerEntry;
        break;
      case XrpField.transaction:
        return XrpInternalType.transaction;
        break;
      case XrpField.validation:
        return XrpInternalType.validation;
        break;
      case XrpField.metadata:
        return XrpInternalType.metadata;
        break;
      case XrpField.hash:
        return XrpInternalType.hash256;
        break;
      case XrpField.index_:
        return XrpInternalType.hash256;
        break;
      case XrpField.closeResolution:
      case XrpField.method:
      case XrpField.transactionResult:
      case XrpField.tickSize:
        return XrpInternalType.uint8;
        break;
      case XrpField.ledgerEntryType:
      case XrpField.transactionType:
      case XrpField.signerWeight:
      case XrpField.version:
        return XrpInternalType.uint16;
        break;
      case XrpField.flags:
      case XrpField.sourceTag:
      case XrpField.sequence:
      case XrpField.previousTxnLgrSeq:
      case XrpField.ledgerSequence:
      case XrpField.closeTime:
      case XrpField.parentCloseTime:
      case XrpField.signingTime:
      case XrpField.expiration:
      case XrpField.transferRate:
      case XrpField.walletSize:
      case XrpField.ownerCount:
      case XrpField.destinationTag:
        return XrpInternalType.uint32;
        break;
      case XrpField.highQualityIn:
      case XrpField.highQualityOut:
      case XrpField.lowQualityIn:
      case XrpField.lowQualityOut:
      case XrpField.qualityIn:
      case XrpField.qualityOut:
      case XrpField.stampEscrow:
      case XrpField.bondAmount:
      case XrpField.loadFee:
      case XrpField.offerSequence:
      case XrpField.firstLedgerSequence:
      case XrpField.lastLedgerSequence:
      case XrpField.transactionIndex:
      case XrpField.operationLimit:
      case XrpField.referenceFeeUnits:
      case XrpField.reserveBase:
      case XrpField.reserveIncrement:
      case XrpField.setFlag:
      case XrpField.clearFlag:
      case XrpField.signerQuorum:
      case XrpField.cancelAfetr:
      case XrpField.finishAfter:
      case XrpField.signerListId:
      case XrpField.settleDelay:
        return XrpInternalType.uint32;
        break;
      case XrpField.indexNext:
      case XrpField.indexPrevious:
      case XrpField.bookNode:
      case XrpField.ownerNode:
      case XrpField.baseFee:
      case XrpField.exchangeRate:
      case XrpField.lowNode:
      case XrpField.highNode:
      case XrpField.destinationNode:
      case XrpField.cookie:
        return XrpInternalType.uint64;
        break;
      case XrpField.emailHash:
        return XrpInternalType.hash128;
        break;
      case XrpField.takerPaysCurrency:
      case XrpField.takerPaysIssuer:
      case XrpField.takerGetCurrency:
      case XrpField.takerGetsIssuer:
        return XrpInternalType.hash160;
        break;
      case XrpField.ledgerHash:
      case XrpField.parentHash:
      case XrpField.transactionHash:
      case XrpField.accountHash:
      case XrpField.previousTxnId:
      case XrpField.ledgerIndex:
      case XrpField.walletLocator:
      case XrpField.rootIndex:
      case XrpField.accountTxnId:
        return XrpInternalType.hash256;
        break;
      case XrpField.bookDirectory:
      case XrpField.invoiceId:
      case XrpField.nickname:
      case XrpField.amendment:
      case XrpField.ticketId:
      case XrpField.digest:
      case XrpField.payChannel:
      case XrpField.consensusHash:
      case XrpField.checkId:
        return XrpInternalType.hash256;
        break;
      case XrpField.amount:
      case XrpField.balance:
      case XrpField.limitAmount:
      case XrpField.takerPays:
      case XrpField.takerGets:
      case XrpField.lowLimit:
      case XrpField.highLimit:
      case XrpField.fee:
      case XrpField.sendMax:
      case XrpField.deliverMin:
      case XrpField.minimumOffer:
      case XrpField.rippleEscrow:
      case XrpField.deliveredAmount:
        return XrpInternalType.amount;
        break;
      case XrpField.publicKey:
      case XrpField.messageKey:
      case XrpField.signingPubKey:
      case XrpField.txnSignature:
      case XrpField.signature:
      case XrpField.domain:
      case XrpField.fundCode:
      case XrpField.removeCode:
      case XrpField.expireCode:
      case XrpField.createCode:
      case XrpField.memoType:
      case XrpField.memoData:
      case XrpField.memoFormat:
      case XrpField.fulfillment:
      case XrpField.condition:
      case XrpField.masterSignature:
        return XrpInternalType.blob;
        break;
      case XrpField.account:
      case XrpField.owner:
      case XrpField.destination:
      case XrpField.issuer:
      case XrpField.authorize:
      case XrpField.unauthorize:
      case XrpField.target:
      case XrpField.regularKey:
        return XrpInternalType.accountId;
        break;
      case XrpField.paths:
        return XrpInternalType.pathSet;
        break;
      case XrpField.indexes:
      case XrpField.hashes:
      case XrpField.amendments:
        return XrpInternalType.vector256;
        break;
      case XrpField.transactionMetaData:
      case XrpField.createdNode:
      case XrpField.deletedNode:
      case XrpField.modifiedNode:
      case XrpField.previousFields:
      case XrpField.finalFields:
      case XrpField.newFields:
      case XrpField.templateEntry:
      case XrpField.memo:
      case XrpField.signerEntry:
        return XrpInternalType.stObject;
        break;
      case XrpField.signer:
      case XrpField.majority:
        return XrpInternalType.stObject;
        break;
      case XrpField.signingAccounts:
      case XrpField.signers:
      case XrpField.signerEntries:
      case XrpField.template:
      case XrpField.necessary:
      case XrpField.sufficient:
      case XrpField.affectedNodes:
      case XrpField.memos:
      case XrpField.majorities:
        return XrpInternalType.stArray;
        break;
    }
  }

  List<int> get fieldId {
    if (this.code < 0 ||
        this.type.code < 0 ||
        this.code > 0xFF ||
        this.type.code > 0xFF) {
      print("Invalid field");
      return [0xFF, 0xFF, 0xFF, 0xFF];
    }
    if (this.type.code < 16 && this.code < 16)
      return [this.type.code << 4 | this.code];
    else if (this.type.code >= 16 && this.code < 16)
      return [this.code, this.type.code];
    else if (this.type.code < 16 && this.code >= 16)
      return [this.type.code << 4, this.code];
    else
      return [0, this.type.code, this.code];
  }
}
