import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/coin_list_data_repository/coin_list_data_repository.dart';
import 'coin_list_data_event.dart';
import 'coin_list_data_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;

  CryptoBloc(this.cryptoRepository) : super(CryptoInitial()) {
    on<FetchCryptoData>((event, emit) async {
      emit(CryptoLoading());
      try {
        final data = await cryptoRepository.fetchCryptoData('<API-KEY>');
        emit(CryptoLoaded(data));
      } catch (e) {
        emit(CryptoError(e.toString()));
      }
    });
  }
}
