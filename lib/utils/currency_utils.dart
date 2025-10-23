import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatCurrency.format(value);
  }
}
