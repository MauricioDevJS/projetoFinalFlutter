import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nuzero/components/model.dart';

class GraphScreen extends StatelessWidget {
  final List<Despesa> despesas;
  final List<Receita> receitas;

  GraphScreen({required this.despesas, required this.receitas});

  @override
  Widget build(BuildContext context) {
    final data = _processData();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text('Gráfico de Receitas/Despesas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sections: data,
            centerSpaceRadius: 40,
            sectionsSpace: 2,
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _processData() {
    Map<String, double> categoryTotals = {};
    double totalValue = 0;

    for (var despesa in despesas) {
      totalValue += despesa.valor;
      categoryTotals.update(despesa.categoria, (value) => value + despesa.valor,
          ifAbsent: () => despesa.valor);
    }

    return categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalValue) * 100;
      return PieChartSectionData(
        value: percentage,
        title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
        color: _getColorForCategory(entry.key),
        radius: 50,
      );
    }).toList();
  }

  Color _getColorForCategory(String category) {
    final Map<String, Color> categoryColors = {
      'Alimentação': Colors.red,
      'Transporte': Colors.green,
      'Lazer': Colors.blue,
      'Educação': Colors.orange,
      'Outros': Colors.purple,
      'Saúde': Colors.yellow,
      'Salário': Colors.pink,
      'Honorários': Colors.brown,
    };

    return categoryColors[category] ?? Colors.grey;
  }
}
