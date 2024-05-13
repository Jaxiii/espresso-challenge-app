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
        var data =
            await cryptoRepository.fetchCryptoData('<API-KEY>', event.id);
        emit(CoinDataLoaded(data));
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
