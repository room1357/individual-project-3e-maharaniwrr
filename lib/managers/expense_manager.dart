import '../models/expense.dart';
import '../models/user_model.dart';
import '../managers/user_manager.dart';

class ExpenseManager {
  static List<Expense> expenses = [
    Expense(
      id: '01',
      title: 'Beli bahan kalung',
      description: 'Mutiara sintetis & rantai stainless',
      amount: 250000,
      category: 'Material',
      date: DateTime(2025, 10, 10),
      username: 'user1',
    ),
    Expense(
      id: '02',
      title: 'Iklan Instagram',
      description: 'Promosi koleksi baru',
      amount: 150000,
      category: 'Marketing',
      date: DateTime(2025, 10, 9),
      username: 'user1',
    ),
    Expense(
      id: '03',
      title: 'Kemasan baru',
      description: 'Kotak perhiasan elegan',
      amount: 100000,
      category: 'Packaging',
      date: DateTime(2025, 10, 8),
      username: 'user1',
    ),
  ];

  // Total pengeluaran per kategori
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category] =
          (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  static List<Expense> getExpensesByUser(String username) {
    return expenses.where((e) => e.username == username).toList();
  }

  // Pengeluaran tertinggi per user
  static Expense? getHighestExpense(String username) {
    final userExpenses = getExpensesByUser(username);
    if (userExpenses.isEmpty) return null;
    return userExpenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }


  // Pengeluaran bulan tertentu
  static List<Expense> getExpensesByMonth(
      List<Expense> expenses, int month, int year) {
    return expenses
        .where((expense) =>
            expense.date.month == month && expense.date.year == year)
        .toList();
  }

  // Cari pengeluaran berdasarkan keyword
  static List<Expense> searchExpenses(
    List<Expense> expenses, String keyword) {
      String lowerKeyword = keyword.toLowerCase();
      return expenses
      .where((expense) =>
          expense.title.toLowerCase().contains(lowerKeyword))
      .toList();
  }

  // Rata-rata pengeluaran harian
  static double getAverageDaily(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;

    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);

    // Hitung jumlah hari unik
    Set<String> uniqueDays = expenses
        .map((expense) =>
            '${expense.date.year}-${expense.date.month}-${expense.date.day}')
        .toSet();

    return total / uniqueDays.length;
  }

  // Total semua pengeluaran
  static double getTotal(List<Expense> expenses) {
    return expenses.fold(0, (sum, e) => sum + e.amount);
  }

  // Rata-rata pengeluaran
  static double getAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    return getTotal(expenses) / expenses.length;
  }

  // Tambah pengeluaran
  static void addExpense(Expense expense) {
    expenses.add(expense);
  }

  // Ubah data pengeluaran
  static void updateExpense(Expense updatedExpense) {
    int index = expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      expenses[index] = updatedExpense;
    }
  }

}


