import 'package:api/api.dart';
import 'package:dio/dio.dart';

import '../services/api_wrapper.dart';

class CoinRepository {
  final APIWrapper apiWrapper;

  CoinRepository(this.apiWrapper);

  throwError(Object err, String message) {
    if (err is DioException && err.error is EspressoCashException) {
      throw err.error!;
    } else {
      throw Exception(message);
    }
  }

  Future<List<CoinMarketMapDto>> fetchCoinsListWithMatket(
      String apiKey, int page) async {
    try {
      return await apiWrapper.fetchCoinsListWithMatket(apiKey, page);
    } catch (e) {
      return throwError(e, 'Failed to fetch cryptocurrency list with market');
    }
  }

  Future<List<CoinMapDto>> fetchCoinList(String apiKey) async {
    try {
      return await apiWrapper.fetchCoinsList(apiKey);
    } catch (e) {
      return throwError(e, 'Failed to fetch cryptocurrency list');
    }
  }

  Future<CoinDataMapDto> fetchCryptoData(String apiKey, String id) async {
    try {
      return await apiWrapper.fetchCoinData(apiKey, id);
    } catch (e) {
      return throwError(e, 'Failed to fetch cryptocurrency data');
    }
  }
}
