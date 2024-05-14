import 'package:flutter/material.dart';

class NoDataText extends StatelessWidget {
  const NoDataText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'No data available',
      style: TextStyle(fontSize: 20),
    );
  }
}
