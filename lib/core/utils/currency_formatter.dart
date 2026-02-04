import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatNaira(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '₦${formatter.format(amount)}';
  }
}
