import 'package:flutter/material.dart';

import '../theme.dart';

class RankChip extends StatelessWidget {
  const RankChip({
    super.key,
    required this.rank,
  });

  final num rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      width: 24 + (8.0 * (rank).toString().length),
      child: Chip(
        padding: const EdgeInsets.only(bottom: 8.0),
        label: Text(
          '#${(rank + 1)}',
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: CpTheme.of(context).secondaryTextColor,
              ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
    );
  }
}
