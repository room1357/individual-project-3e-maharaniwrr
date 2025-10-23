import 'package:intl/intl.dart'; // untuk format tanggal & angka

class Expense {
  final String? id;
  final String title;
  final String? description;
  final double amount;
  final String category;
  final DateTime date;
  final String username;

  Expense({
    this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.username,
  });

  // Tambahkan getter formattedDate
  String get formattedDate {
    return "${date.day.toString().padLeft(2, '0')} "
           "${_monthName(date.month)} "
           "${date.year}";
  }

  static String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  // Tambahkan getter formattedAmount
  String get formattedAmount {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatCurrency.format(amount);
  }
}
