import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/expense.dart';
import '../managers/user_manager.dart';

class ExportImportHelper {
  /// 🔹 Export data ke file CSV
  static Future<File> exportToCsv(List<Expense> expenses) async {
    final rows = [
      ['ID', 'Judul', 'Kategori', 'Jumlah', 'Tanggal'],
      ...expenses.map((e) => [
            e.id,
            e.title,
            e.category,
            e.amount,
            e.formattedDate,
          ]),
    ];

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/expenses.csv');
    await file.writeAsString(csvData);
    return file;
  }

  /// 🔹 Import data dari file CSV
  static Future<List<Expense>> importFromCsv(File file, String username) async {
    final csvData = await file.readAsString();
    final List<List<dynamic>> rows =
        const CsvToListConverter().convert(csvData, eol: '\n');

    List<Expense> imported = [];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      imported.add(
        Expense(
          id: row[0].toString(),
          title: row[1].toString(),
          category: row[2].toString(),
          amount: double.tryParse(row[3].toString()) ?? 0,
          date: DateTime.tryParse(row[4].toString()) ?? DateTime.now(),
          username: username,
        ),
      );
    }
    return imported;
  }

  /// 🔹 Export data ke file PDF
  static Future<File> exportToPdf(List<Expense> expenses) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("📊 Laporan Pengeluaran",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              )),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Judul', 'Kategori', 'Jumlah (Rp)', 'Tanggal'],
            data: expenses
                .map((e) => [
                      e.title,
                      e.category,
                      e.amount.toStringAsFixed(0),
                      e.formattedDate,
                    ])
                .toList(),
          ),
          pw.SizedBox(height: 30),
          pw.Text(
            "Total: Rp${expenses.fold<double>(0, (sum, e) => sum + e.amount).toStringAsFixed(0)}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/laporan_pengeluaran.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
