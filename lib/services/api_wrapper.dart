import 'package:api/api.dart';

class APIWrapper {
  final CoinsClient client;

  APIWrapper(this.client);

  Future<List<CoinMarketMapDto>> fetchCoinsListWithMatket(
      String apiKey, int page) async {
    var data = await client.getCoinsListWithMarkets(
        apiKey, CoinMarketRequestDto(vsCurrency: 'usd', page: page));
    return data.map<CoinMarketMapDto>((item) => item).toList();
  }

  Future<List<CoinMapDto>> fetchCoinsList(String apiKey) async {
    var data = await client.getCoinsList(apiKey, includePlatform: false);
    return data.map<CoinMapDto>((item) => item).toList();
  }

  Future<CoinDataMapDto> fetchCoinData(String apiKey, String id) async {
    var data = await client.getCoinData(apiKey, id);
    return data;
  }
}
