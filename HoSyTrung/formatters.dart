import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );
  return currency.format(value);
}

String soldText(int count) {
  if (count >= 1000) {
    return 'Đã bán ${(count / 1000).toStringAsFixed(1)}k';
  }
  return 'Đã bán $count';
}
import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );
  return currency.format(value);
}

String soldText(int count) {
  if (count >= 1000) {
    return 'Đã bán ${(count / 1000).toStringAsFixed(1)}k';
  }
  return 'Đã bán $count';
}