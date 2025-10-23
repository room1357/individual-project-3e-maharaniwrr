import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../managers/expense_manager.dart';

class StatisticsWidget extends StatelessWidget {
  final List<Expense> expenses;
  const StatisticsWidget({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    // Kelompokkan berdasarkan kategori untuk grafik
    final Map<String, double> categoryTotals = {};
    for (var e in expenses) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0) + e.amount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (categoryTotals.isNotEmpty)
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "📉 Grafik Pengeluaran per Kategori",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 📊 Grafik Batang
                  SizedBox(
                    height: 240,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 50000,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 48, // ruang kiri biar teks gak numpuk
                              interval: 50000,
                              getTitlesWidget: (value, _) {
                                String label;
                                if (value >= 1000000) {
                                  label = '${(value / 1000000).toStringAsFixed(1)}M';
                                } else if (value >= 1000) {
                                  label = '${(value / 1000).toStringAsFixed(0)}K';
                                } else {
                                  label = value.toStringAsFixed(0);
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                      height: 1.4, // biar spacing rapi antar angka
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, _) {
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index < categoryTotals.keys.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      categoryTotals.keys.elementAt(index),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        barGroups: List.generate(categoryTotals.length, (index) {
                          final key = categoryTotals.keys.elementAt(index);
                          final value = categoryTotals[key]!;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: value,
                                color: Colors.pinkAccent,
                                width: 20,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
