import 'package:api/api.dart';

import '../../services/api_wrapper.dart';

class CryptoRepository {
  final APIWrapper apiWrapper;

  CryptoRepository(this.apiWrapper);

  Future<List<CoinDataMapDto>> fetchCryptoData(String apiKey, int page) async {
    try {
      return await apiWrapper.fetchCoinsData(apiKey, page);
    } catch (e) {
      throw Exception('Failed to fetch cryptocurrency data: ${e.toString()}');
    }
  }

  Future<List<CoinMapDto>> fetchCryptoList(String apiKey) async {
    try {
      return await apiWrapper.fetchCoinList(apiKey);
    } catch (e) {
      throw Exception('Failed to fetch cryptocurrency data: ${e.toString()}');
    }
  }
}
