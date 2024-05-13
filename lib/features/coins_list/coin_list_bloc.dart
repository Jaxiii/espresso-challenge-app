import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/coin_repository.dart';
import 'coin_list_event.dart';
import 'coin_list_state.dart';

class CoinListBloc extends Bloc<CryptoEvent, CoinListState> {
  final CoinRepository cryptoRepository;
  int page = 0;

  CoinListBloc(this.cryptoRepository) : super(CoinListInitial()) {
    on<FetchCoinListWithMarket>((event, emit) async {
      page = 1; // reset page count for initial fetch
      try {
        final data =
            await cryptoRepository.fetchCoinsListWithMatket('<API-KEY>', page);
        emit(CoinListWithMarketLoaded(
            cryptoData: data, hasReachedMax: data.isEmpty));
      } catch (e) {
        emit(CoinListError(e.toString()));
      }
    });

    on<FetchCoinList>((event, emit) async {
      emit(CoinListLoading());
      try {
        var data = await cryptoRepository.fetchCoinList('<API-KEY>');
        emit(CoinListLoaded(data));
      } catch (e) {
        emit(CoinListError(e.toString()));
      }
    });

    on<LoadMoreCoins>((event, emit) async {
      if (state is CoinListWithMarketLoaded &&
          !(state as CoinListWithMarketLoaded).hasReachedMax) {
        try {
          final nextPage = page + 1;
          final newData = await cryptoRepository.fetchCoinsListWithMatket(
              '<API-KEY>', nextPage);
          emit(CoinListWithMarketLoaded(
            cryptoData:
                (state as CoinListWithMarketLoaded).cryptoData + newData,
            hasReachedMax: newData.isEmpty,
          ));
          page = nextPage;
        } catch (e) {
          emit(CoinListError(e.toString()));
        }
      }
    });
  }
}
