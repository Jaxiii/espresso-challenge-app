import 'package:api/api.dart';

import '../../services/api_wrapper.dart';

class CryptoRepository {
  final APIWrapper apiWrapper;

  CryptoRepository(this.apiWrapper);

  Future<List<CoinDataMapDto>> fetchCryptoData(String apiKey) async {
    try {
      return await apiWrapper.fetchCoins(apiKey);
    } catch (e) {
      throw Exception('Failed to fetch cryptocurrency data: ${e.toString()}');
    }
  }
}
