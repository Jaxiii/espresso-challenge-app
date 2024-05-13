import 'package:api/api.dart';
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
        final List<CoinMarketMapDto> data =
            await cryptoRepository.fetchCoinsListWithMatket(page);
        emit(CoinListWithMarketLoaded(
            cryptoData: data, hasReachedMax: data.isEmpty));
      } catch (e) {
        emit(CoinListError(e.toString()));
      }
    });

    on<FetchCoinList>((event, emit) async {
      emit(CoinListLoading());
      try {
        final List<CoinMapDto> data = await cryptoRepository.fetchCoinList();
        emit(CoinListLoaded(data));
      } catch (e) {
        emit(CoinListError(e.toString()));
      }
    });

    on<LoadMoreCoins>((event, emit) async {
      if (state is CoinListWithMarketLoaded &&
          !(state as CoinListWithMarketLoaded).hasReachedMax) {
        try {
          final int nextPage = page + 1;
          final List<CoinMarketMapDto> newData =
              await cryptoRepository.fetchCoinsListWithMatket(nextPage);
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
