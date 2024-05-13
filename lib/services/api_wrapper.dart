import 'package:api/api.dart';

class APIWrapper {
  final CoinsClient client;
  final String apiKey = const String.fromEnvironment('API_KEY');
  APIWrapper(this.client);

  Future<List<CoinMarketMapDto>> fetchCoinsListWithMatket(int page) async {
    List<CoinMarketMapDto> data = await client.getCoinsListWithMarkets(
      apiKey,
      CoinMarketRequestDto(vsCurrency: 'usd', page: page),
    );
    return data.map<CoinMarketMapDto>((item) => item).toList();
  }

  Future<List<CoinMapDto>> fetchCoinsList() async {
    List<CoinMapDto> data =
        await client.getCoinsList(apiKey, includePlatform: false);
    return data.map<CoinMapDto>((item) => item).toList();
  }

  Future<CoinDataMapDto> fetchCoinData(String id) async {
    CoinDataMapDto data = await client.getCoinData(apiKey, id);
    return data;
  }

  Future<HistoricalPricesMapDto> fetchCoinHistoricalPrices(String id) async {
    HistoricalPricesMapDto data = await client.getCoinMarkerChart(
      apiKey,
      id,
      HistoricalPricesRequestDto(
        vsCurrency: 'usd',
        days: '1',
      ),
    );
    return data;
  }

  Future<Map<String, PriceMapDto>> fetchCoinPrice(String id) async {
    Map<String, PriceMapDto> data = await client.getPrice(
      apiKey,
      PriceRequestDto(ids: [id], vsCurrencies: ['usd']),
    );
    return data;
  }
}
