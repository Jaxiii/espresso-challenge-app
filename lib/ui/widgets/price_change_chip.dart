import 'package:flutter/material.dart';

class PriceChangeChip extends StatelessWidget {
  const PriceChangeChip({
    super.key,
    required this.priceChange,
  });

  final num priceChange;

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.only(right: 8.0),
      label: Row(
        children: [
          Icon(
            priceChange > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          ),
          Text(
            '${priceChange.abs().toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      backgroundColor: MaterialStateColor.resolveWith(
        (states) => priceChange > 0 ? Colors.green : Colors.red,
      ),
    );
  }
}
