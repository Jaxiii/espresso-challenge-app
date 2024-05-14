import 'package:flutter/material.dart';

import '../theme.dart';
import 'price_change_chip.dart';

class PriceRow extends StatelessWidget {
  final String price;
  final num priceChange;

  const PriceRow({
    required this.price,
    required this.priceChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          price,
          style:
              Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 28),
        ),
        Row(
          children: [
            Chip(
              padding: EdgeInsets.zero,
              label: Icon(
                Icons.notifications_outlined,
                color: CpTheme.of(context).secondaryTextColor,
                size: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            PriceChangeChip(
              priceChange: priceChange,
            ),
          ],
        ),
      ],
    );
  }
}
