import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatNaira(double amount) {
    final format = NumberFormat.currency(
      locale: 'en_NG', 
      symbol: '₦',
      decimalDigits: 2,
    );
    return format.format(amount);
  }
}
