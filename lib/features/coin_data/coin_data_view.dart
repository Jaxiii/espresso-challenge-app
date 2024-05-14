import 'package:api/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../ui/widgets/chart.dart';
import '../../ui/widgets/exchange_rates.dart';
import '../../ui/widgets/no_data.dart';
import 'coin_data_bloc.dart';
import 'coin_data_state.dart';

class CoinDataBlocWidget extends StatefulWidget {
  CoinDataBlocWidget({Key? key}) : super(key: key);

  @override
  _CoinDataBlocWidgetState createState() => _CoinDataBlocWidgetState();
}

class _CoinDataBlocWidgetState extends State<CoinDataBlocWidget> {
  double _containerHeight = 100.0;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDataBloc, CoinDataState>(
      builder: (context, state) {
        if (state is CoinDataLoading && state.isInitialLoad) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CoinDataError) {
          if (state.error == EspressoCashError.notFound) {
            return SizedBox();
          }
          debugPrint(
            state.message + state.error.toString(),
          );
          return SizedBox();
        }
        if (state is CoinDataLoaded) {
          if (!_expanded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final TextSpan textSpan = TextSpan(
                text: state.coinData.description['en'],
                style: TextStyle(fontSize: 16),
              );
              final TextPainter textPainter = TextPainter(
                text: textSpan,
                maxLines: null,
                textDirection: TextDirection.ltr,
              );
              textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
              setState(() {
                _containerHeight = textPainter.size.height;
              });
            });
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About ${state.coinData.name}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 18.0),
              Stack(
                children: [
                  AnimatedContainer(
                    height: _expanded ? _containerHeight : 100.0,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    child: HtmlWidget(
                      state.coinData.description['en'],
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  if (!_expanded)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 20.0,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.25),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              TextButton(
                onPressed: () => setState(() {
                  _expanded = !_expanded;
                }),
                child: Text(_expanded ? 'Read less' : 'Read more'),
              ),
            ],
          );
        }
        return NoDataText();
      },
    );
  }
}

class CoinChartBlocWidget extends StatefulWidget {
  CoinChartBlocWidget({Key? key}) : super(key: key);

  @override
  _CoinChartBlocWidgetState createState() => _CoinChartBlocWidgetState();
}

class _CoinChartBlocWidgetState extends State<CoinChartBlocWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDataBloc, CoinDataState>(
      builder: (context, state) {
        if (state is CoinDataLoading && state.isInitialLoad) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CoinDataError) {
          if (state.error == EspressoCashError.notFound) {
            return SizedBox();
          }
          debugPrint(
            state.message + state.error.toString(),
          );
          return SizedBox();
        }
        if (state is CoinChartLoaded) {
          return CoinChart(priceData: state.coinChart.prices);
        }
        return NoDataText();
      },
    );
  }
}

class CoinPriceBlocWidget extends StatefulWidget {
  final String id;
  final String symbol;
  CoinPriceBlocWidget({Key? key, required this.id, required this.symbol})
      : super(key: key);

  @override
  _CoinPriceBlocWidgetState createState() =>
      _CoinPriceBlocWidgetState(id: id, symbol: symbol);
}

class _CoinPriceBlocWidgetState extends State<CoinPriceBlocWidget> {
  late TextEditingController usdController;
  late TextEditingController coinController;
  final String id;
  final String symbol;
  _CoinPriceBlocWidgetState({required this.id, required this.symbol});

  @override
  void initState() {
    usdController = TextEditingController();
    coinController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usdController.dispose();
    coinController.dispose();
    super.dispose();
  }

  void updateUsd(String value, double price) {
    if (value.isEmpty) {
      usdController.text = '';
      return;
    }

    try {
      final coinValue = num.parse(value.replaceFirst(',', '.'));
      final usdRate = price;
      usdController.text = (coinValue * usdRate).toStringAsFixed(2);
    } catch (e) {
      usdController.text = 'Invalid input';
    }
  }

  void updateCoin(String value, double price) {
    if (value.isEmpty) {
      coinController.text = '';
      return;
    }

    try {
      final usdValue = num.parse(value.replaceFirst(',', '.'));
      final usdRate = price;
      if (usdRate != 0) {
        coinController.text = (usdValue / usdRate).toStringAsFixed(6);
      }
    } catch (e) {
      coinController.text = 'Invalid input';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDataBloc, CoinDataState>(
      builder: (context, state) {
        if (state is CoinDataLoading && state.isInitialLoad) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CoinDataError) {
          if (state.error == EspressoCashError.notFound) {
            return SizedBox();
          }
          debugPrint(
            state.message + state.error.toString(),
          );
          return SizedBox();
        }
        if (state is CoinPriceLoaded) {
          if (state.coinPrice[id.toLowerCase()] == null) {
            return NoDataText();
          }
          usdController.text =
              state.coinPrice[id.toLowerCase()]!.usd.toString();
          coinController.text = 1.toString();

          final void Function(dynamic value) onChangedUsd =
              (value) => updateUsd(
                    value,
                    state.coinPrice[id.toLowerCase()]!.usd!,
                  );
          final void Function(dynamic value) onChangedCoin =
              (value) => updateCoin(
                    value,
                    state.coinPrice[id.toLowerCase()]!.usd!,
                  );

          return ExchangeRatesWidget(
            symbol: symbol,
            coinController: coinController,
            usdController: usdController,
            onChangedCoin: onChangedCoin,
            onChangedUsd: onChangedUsd,
          );
        }
        return NoDataText();
      },
    );
  }
}

class CoinImageBlocWidget extends StatelessWidget {
  const CoinImageBlocWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDataBloc, CoinDataState>(
      builder: (context, state) {
        if (state is CoinDataLoading && state.isInitialLoad) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CoinDataError) {
          if (state.error == EspressoCashError.notFound) {
            return const SizedBox();
          }
          debugPrint('${state.message}${state.error}');
          return const SizedBox();
        }
        if (state is CoinDataLoaded) {
          if (state.coinData.id.isEmpty) {
            return const NoDataText();
          }
          return CachedNetworkImage(
            imageUrl: state.coinData.image['thumb'],
            width: 24,
            height: 24,
          );
        }
        return const SizedBox();
      },
    );
  }
}
