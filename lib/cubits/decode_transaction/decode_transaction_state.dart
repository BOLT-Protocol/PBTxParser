part of 'decode_transaction_cubit.dart';

abstract class DecodeTransactionState extends Equatable {
  const DecodeTransactionState();

  @override
  List<Object> get props => [];
}

class Decoded extends DecodeTransactionState {
  final Map decodedTx;

  Decoded(this.decodedTx);
  @override
  List<Object> get props => [decodedTx];
}

class DecodeTransactionInitial extends DecodeTransactionState {}
