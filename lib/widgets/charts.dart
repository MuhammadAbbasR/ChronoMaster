import 'package:chronomaster_pro/model/session_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LapTimeChart extends StatelessWidget {
  final SessionModel session;

  const LapTimeChart({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
   // final lapTimes = session.laps.map(int.parse).toList();
    final lapTimes = session.laps.map(timeStringToMs).toList();

    if (lapTimes.isEmpty) return const SizedBox();

    final best = lapTimes.reduce((a, b) => a < b ? a : b);
    final worst = lapTimes.reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lap Performance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: lapTimes.length.toDouble(),
                minY: best * 0.95,
                maxY: worst * 1.05,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                titlesData: _titles(),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.blue,
                    spots: _spots(lapTimes),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        final value = lapTimes[index];

                        if (value == best) {
                          return _dot(Colors.green);
                        }
                        if (value == worst) {
                          return _dot(Colors.red);
                        }
                        return _dot(Colors.blue, radius: 4);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int timeStringToMs(String time) {
    final parts = time.split(':'); // ["00", "01.519"]

    final minutes = int.parse(parts[0]);

    final secondsParts = parts[1].split('.');
    final seconds = int.parse(secondsParts[0]);
    final milliseconds = int.parse(secondsParts[1]);

    return (minutes * 60 * 1000) +
        (seconds * 1000) +
        milliseconds;
  }


  // ---------- Helpers ----------

  List<FlSpot> _spots(List<int> laps) {
    return List.generate(
      laps.length,
          (i) => FlSpot((i + 1).toDouble(), laps[i].toDouble()),
    );
  }

  FlDotCirclePainter _dot(Color color, {double radius = 5}) {
    return FlDotCirclePainter(
      radius: radius,
      color: color,
      strokeWidth: 2,
      strokeColor: Colors.white,
    );
  }

  FlTitlesData _titles() {
    return FlTitlesData(
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (v, _) =>
              Text('Lap ${v.toInt()}', style: const TextStyle(fontSize: 10)),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (v, _) =>
              Text('${(v / 1000).toStringAsFixed(2)}s',
                  style: const TextStyle(fontSize: 10)),
        ),
      ),
    );
  }
}
