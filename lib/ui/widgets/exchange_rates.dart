import 'package:flutter/material.dart';

class ExchangeRatesWidget extends StatelessWidget {
  const ExchangeRatesWidget({
    super.key,
    required this.usdController,
    required this.onChangedCoin,
    required this.coinController,
    required this.symbol,
    required this.onChangedUsd,
  });

  final TextEditingController usdController;
  final void Function(dynamic value) onChangedCoin;
  final TextEditingController coinController;
  final String symbol;
  final void Function(dynamic value) onChangedUsd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Convert rate - USD to ${symbol.toUpperCase()}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 36.0),
        TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: usdController,
          decoration: InputDecoration(
            labelText: 'USD',
            border: OutlineInputBorder(),
          ),
          onChanged: onChangedCoin,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
        SizedBox(height: 24.0),
        TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: coinController,
          decoration: InputDecoration(
            labelText: symbol.toUpperCase(),
            border: OutlineInputBorder(),
          ),
          onChanged: onChangedUsd,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
