import '../../model/bitcoin.transaction.model.dart';
import '../../repository/decode.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'decode_transaction_state.dart';

class DecodeTransactionCubit extends Cubit<DecodeTransactionState> {
  DecodeRepository _decodeRepository;
  DecodeTransactionCubit(this._decodeRepository)
      : super(DecodeTransactionInitial());

  Future<void> decode(String hexData) async {
    print('cubit: decode');
    List<String> decodedData =
        await _decodeRepository.decodeBtcTransaction(hexData);
    decodedData.removeWhere((element) => element == null);
    emit(Decoded(decodedData));
  }

  @override
  void onChange(Change<DecodeTransactionState> change) {
    print(change);
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
