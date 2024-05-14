import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../ui/widgets/chart.dart';
import '../../ui/widgets/exchange_rates.dart';
import '../../ui/widgets/no_data.dart';
import 'coin_data_bloc.dart';
import 'coin_data_state.dart';

class CoinDataWidget extends StatefulWidget {
  CoinDataWidget({Key? key}) : super(key: key);

  @override
  _CoinDataWidgetState createState() => _CoinDataWidgetState();
}

class _CoinDataWidgetState extends State<CoinDataWidget> {
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
                      textStyle:
                          TextStyle(fontSize: 16, overflow: TextOverflow.fade),
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

class CoinChartWidget extends StatefulWidget {
  CoinChartWidget({Key? key}) : super(key: key);

  @override
  _CoinChartWidgetState createState() => _CoinChartWidgetState();
}

class _CoinChartWidgetState extends State<CoinChartWidget> {
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

class CoinPriceWidget extends StatefulWidget {
  final String id;
  CoinPriceWidget({Key? key, required this.id}) : super(key: key);

  @override
  _CoinPriceWidgetState createState() => _CoinPriceWidgetState(id: id);
}

class _CoinPriceWidgetState extends State<CoinPriceWidget> {
  late TextEditingController usdController;
  late TextEditingController coinController;
  final String id;
  _CoinPriceWidgetState({required this.id});

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
            id: id,
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
