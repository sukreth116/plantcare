class Formatters {
  /// Safely parses an amount to double.
  static double parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? defaultValue;
  }

  /// Formats an amount as Indian Rupee currency string (e.g. ₹120.00).
  static String formatCurrency(dynamic amount) {
    final parsed = parseDouble(amount);
    return '₹${parsed.toStringAsFixed(2)}';
  }
}
