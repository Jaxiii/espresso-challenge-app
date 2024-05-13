import 'package:api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/coin_repository.dart';
import 'coin_data_event.dart';
import 'coin_data_state.dart';

class CoinDataBloc extends Bloc<CryptoDataEvent, CoinDataState> {
  final CoinRepository cryptoRepository;

  CoinDataBloc(this.cryptoRepository) : super(CoinDataInitial()) {
    on<FetchCoinData>((event, emit) async {
      emit(CoinDataLoading());
      try {
        CoinDataMapDto data = await cryptoRepository.fetchCryptoData(event.id);
        emit(CoinDataLoaded(data));
      } catch (e) {
        if (e is EspressoCashException) {
          emit(CoinDataError("Failed to fetch data", e.error));
        } else {
          emit(CoinDataError(e.toString(), null));
        }
      }
    });

    on<FetchCoinHistoricalPrice>((event, emit) async {
      emit(CoinDataLoading());
      try {
        HistoricalPricesMapDto data =
            await cryptoRepository.fetchCoinHistoricalPrices(event.id);
        emit(CoinChartLoaded(data));
      } catch (e) {
        if (e is EspressoCashException) {
          emit(CoinDataError("Failed to fetch data", e.error));
        } else {
          emit(CoinDataError(e.toString(), null));
        }
      }
    });

    on<FetchCoinPrice>((event, emit) async {
      emit(CoinDataLoading());
      try {
        Map<String, PriceMapDto> data =
            await cryptoRepository.fetchCoinPrice(event.id);
        emit(CoinPriceLoaded(data));
      } catch (e) {
        if (e is EspressoCashException) {
          emit(CoinDataError("Failed to fetch data", e.error));
        } else {
          emit(CoinDataError(e.toString(), null));
        }
      }
    });
  }
}
