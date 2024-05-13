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

  Future<List<CoinMarketMapDto>> fetchCoinsListWithMatket(int page) async {
    try {
      return await apiWrapper.fetchCoinsListWithMatket(page);
    } catch (e) {
      return throwError(e, 'Failed to fetch cryptocurrency list with market');
    }
  }

  Future<List<CoinMapDto>> fetchCoinList() async {
    try {
      return await apiWrapper.fetchCoinsList();
    } catch (e) {
      return throwError(e, 'Failed to fetch cryptocurrency list');
    }
  }

  Future<CoinDataMapDto> fetchCryptoData(String id) async {
    try {
      return await apiWrapper.fetchCoinData(id);
    } catch (e) {
      return throwError(e, 'Failed to fetch cryptocurrency data');
    }
  }

  Future<HistoricalPricesMapDto> fetchCoinHistoricalPrices(String id) async {
    try {
      return await apiWrapper.fetchCoinHistoricalPrices(id);
    } catch (e) {
      return throwError(e, 'Failed to fetch cryptocurrency historical prices');
    }
  }

  Future<Map<String, PriceMapDto>> fetchCoinPrice(String id) async {
    try {
      return await apiWrapper.fetchCoinPrice(id);
    } catch (e) {
      return throwError(e, 'Failed to fetch cryptocurrency historical prices');
    }
  }
}
