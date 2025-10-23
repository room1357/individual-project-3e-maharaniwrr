import 'package:flutter/material.dart';
import '../managers/expense_manager.dart';
import '../models/expense.dart';
import '../models/user_model.dart';
import '../screens/add_expense_screen.dart';
import '../screens/edit_expense_screen.dart';
import '../screens/category_screen.dart';
import '../screens/statistics_screen.dart';
import '../managers/export_import_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ExpenseScreen extends StatefulWidget {
  final User user;
  const ExpenseScreen({super.key, required this.user});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter pengeluaran hanya milik user ini
    final allExpenses = ExpenseManager.getExpensesByUser(widget.user.username);
    final filteredExpenses = searchQuery.isEmpty
        ? allExpenses
        : ExpenseManager.searchExpenses(allExpenses, searchQuery);

    final highest = ExpenseManager.getHighestExpense(widget.user.username);
    final total = ExpenseManager.getTotal(filteredExpenses);
    final avg = ExpenseManager.getAverage(filteredExpenses);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "💎 Analisis Pengeluaran",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 243, 33, 180),
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddExpenseScreen(user: widget.user)),
              );
              setState(() {}); // refresh setelah kembali
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    "📊 Ringkasan Pengeluaran",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _summaryCard("Total", total)),
                      const SizedBox(width: 8),
                      Expanded(child: _summaryCard("Rata-rata", avg)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (highest != null)
                    Card(
                      color: Colors.pink[100],
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.trending_up,
                          color: Colors.pinkAccent,
                          size: 30,
                        ),
                        title: const Text(
                          "Pengeluaran Tertinggi",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "${highest.title} - Rp${highest.amount.toStringAsFixed(0)}"),
                      ),
                    ),
                  const SizedBox(height: 20),
                  StatisticsWidget(expenses: filteredExpenses),
                  const SizedBox(height: 20),

                  // Export & Import
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final file = await ExportImportHelper.exportToCsv(
                              filteredExpenses);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('✅ Data diekspor ke CSV: ${file.path}')),
                            );
                          }
                        },
                        icon: const Icon(Icons.table_chart),
                        label: const Text("Export CSV"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result != null && result.files.single.path != null) {
                            final importedFile =
                                File(result.files.single.path!);
                            final importedData =
                                await ExportImportHelper.importFromCsv(
                                    importedFile, widget.user.username);
                            setState(() {
                              ExpenseManager.expenses.addAll(importedData);
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('📥 Data CSV berhasil diimpor!')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text("Import CSV"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final file =
                              await ExportImportHelper.exportToPdf(filteredExpenses);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('📄 PDF dibuat: ${file.path}')),
                            );
                          }
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Export PDF"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "📂 Daftar Pengeluaran",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Search
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.pinkAccent),
                      hintText: "Cari pengeluaran...",
                      filled: true,
                      fillColor: Colors.pink[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Daftar pengeluaran
                  if (filteredExpenses.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "Tidak ada pengeluaran ditemukan.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...filteredExpenses.map((expense) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.pinkAccent,
                          ),
                          title: Text(
                            expense.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                              "${expense.category} • ${expense.formattedDate}",
                              style: const TextStyle(fontSize: 12)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Rp${expense.amount.toStringAsFixed(0)}",
                                style: const TextStyle(
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blueAccent),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditExpenseScreen(
                                        expense: expense,
                                        onUpdate: (updatedExpense) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  setState(() {
                                    ExpenseManager.expenses
                                        .removeWhere((e) => e.id == expense.id);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.category),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const CategoryScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, double value) {
    return Card(
      color: Colors.pink[50],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Rp${value.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
