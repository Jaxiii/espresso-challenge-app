import 'package:api/api.dart';

class APIWrapper {
  final CoinsClient client;

  APIWrapper(this.client);

  Future<List<CoinDataMapDto>> fetchCoinsData(String apiKey, int page) async {
    var data = await client.getCoinData(
        apiKey, CoinDataRequestDto(vsCurrency: 'usd', page: page));
    return data.map<CoinDataMapDto>((item) => item).toList();
  }

  Future<List<CoinMapDto>> fetchCoinList(String apiKey) async {
    var data = await client.getCoinsList(apiKey, includePlatform: false);
    return data.map<CoinMapDto>((item) => item).toList();
  }
}
