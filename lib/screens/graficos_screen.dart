import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TelaGraficos extends StatelessWidget {
  const TelaGraficos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF015A84),
      appBar: AppBar(
        title: const Text("Gráficos de Irrigação"),
        backgroundColor: const Color(0xFF016A9B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Consumo de Água (últimos 7 dias)",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("Seg", style: TextStyle(color: Colors.white));
                            case 1:
                              return const Text("Ter", style: TextStyle(color: Colors.white));
                            case 2:
                              return const Text("Qua", style: TextStyle(color: Colors.white));
                            case 3:
                              return const Text("Qui", style: TextStyle(color: Colors.white));
                            case 4:
                              return const Text("Sex", style: TextStyle(color: Colors.white));
                            case 5:
                              return const Text("Sáb", style: TextStyle(color: Colors.white));
                            case 6:
                              return const Text("Dom", style: TextStyle(color: Colors.white));
                          }
                          return const Text("");
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.cyanAccent,
                      barWidth: 4,
                      spots: const [
                        FlSpot(0, 2),
                        FlSpot(1, 5),
                        FlSpot(2, 3),
                        FlSpot(3, 7),
                        FlSpot(4, 4),
                        FlSpot(5, 6),
                        FlSpot(6, 3),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
