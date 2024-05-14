import 'package:intl/intl.dart';

String formatCurrentPrice(num value, String locale) {
  final numberFormat = NumberFormat.currency(
    locale: locale,
    symbol: '\$ ',
    decimalDigits: 2,
  );
  return numberFormat.format(value);
}
