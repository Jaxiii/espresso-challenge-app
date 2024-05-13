import 'package:flutter/material.dart';

class ExchangeRatesWidget extends StatelessWidget {
  const ExchangeRatesWidget({
    super.key,
    required this.usdController,
    required this.onChangedCoin,
    required this.coinController,
    required this.id,
    required this.onChangedUsd,
  });

  final TextEditingController usdController;
  final void Function(dynamic value) onChangedCoin;
  final TextEditingController coinController;
  final String id;
  final void Function(dynamic value) onChangedUsd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.0),
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
            labelText: id,
            border: OutlineInputBorder(),
          ),
          onChanged: onChangedUsd,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}
