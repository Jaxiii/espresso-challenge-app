import 'package:api/api.dart';

class APIWrapper {
  final CoinsClient client;

  APIWrapper(this.client);

  Future<List<CoinDataMapDto>> fetchCoins(String apiKey) async {
    var data =
        await client.getCoinData(apiKey, CoinDataRequestDto(vsCurrency: 'usd'));
    return data.map<CoinDataMapDto>((item) => item).toList();
  }
}
