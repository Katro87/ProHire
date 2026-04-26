const Map<String, String> kCurrencySymbols = {
  'USD': '\$',
  'EUR': '€',
  'GBP': '£',
  'NGN': '₦',
  'KES': 'KSh',
  'ZAR': 'R',
  'INR': '₹',
  'JPY': '¥',
};

String currencySymbol(String code) {
  return kCurrencySymbols[code] ?? code;
}

String formatCurrency(double amount, String code) {
  final symbol = currencySymbol(code);
  final value = amount % 1 == 0 ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
  return '$symbol$value';
}
