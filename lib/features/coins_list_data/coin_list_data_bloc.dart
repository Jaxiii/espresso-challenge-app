import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/coin_list_data_repository/coin_list_data_repository.dart';
import 'coin_list_data_event.dart';
import 'coin_list_data_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;
  int page = 0;

  CryptoBloc(this.cryptoRepository) : super(CryptoInitial()) {
    on<FetchCryptoData>((event, emit) async {
      page = 1; // reset page count for initial fetch
      try {
        final data = await cryptoRepository.fetchCryptoData('<API-KEY>', page);
        emit(CryptoLoaded(cryptoData: data, hasReachedMax: data.isEmpty));
      } catch (e) {
        emit(CryptoError(e.toString()));
      }
    });

    on<FetchCoinList>((event, emit) async {
      emit(CryptoLoading());
      try {
        var data = await cryptoRepository.fetchCryptoList('api-key');
        emit(CoinListLoaded(data));
      } catch (e) {
        emit(CryptoError(e.toString()));
      }
    });

    on<LoadMoreCoins>((event, emit) async {
      if (state is CryptoLoaded && !(state as CryptoLoaded).hasReachedMax) {
        try {
          final nextPage = page + 1;
          final newData =
              await cryptoRepository.fetchCryptoData('<API-KEY>', nextPage);
          emit(CryptoLoaded(
            cryptoData: (state as CryptoLoaded).cryptoData + newData,
            hasReachedMax: newData.isEmpty,
          ));
          page = nextPage;
        } catch (e) {
          emit(CryptoError(e.toString()));
        }
      }
    });
  }
}
