String formatCurrencyVnd(int amount) {
  final formatted = amount.abs().toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
  final sign = amount < 0 ? '-' : '';
  return '$sign$formatted đ';
}

String formatQuantityLabel(int quantity) {
  return 'x$quantity';
}
