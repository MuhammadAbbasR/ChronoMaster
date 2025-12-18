import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chronomaster_pro/model/session_model.dart';
import 'package:chronomaster_pro/widgets/charts.dart';

class SessionDetailScreen extends StatelessWidget {
  final SessionModel sessionModel;

  const SessionDetailScreen({super.key, required this.sessionModel});

  int lapStringToMs(String lap) {
    final parts = lap.split(':');
    final minutes = int.parse(parts[0]);
    final secParts = parts[1].split('.');
    final seconds = int.parse(secParts[0]);
    final milliseconds = int.parse(secParts[1]);
    return minutes * 60000 + seconds * 1000 + milliseconds;
  }

  int getAverage(List<int> lapMsList) {
    if (lapMsList.isEmpty) return 0;
    return lapMsList.reduce((a, b) => a + b) ~/ lapMsList.length;
  }

  String formatMs(int ms) {
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = (ms % 1000).toString().padLeft(3, '0');
    return "$minutes:$seconds.$milliseconds";
  }

  String formatDeltaMs(double ms) {
    final sign = ms >= 0 ? '+' : '-';
    final absMs = ms.abs();

    final minutes = (absMs ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((absMs % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = (absMs % 1000).toString().padLeft(3, '0');

    return "$sign$minutes:$seconds.$milliseconds";
  }

  @override
  Widget build(BuildContext context) {
    final lapMsList =
    sessionModel.laps.map((e) => lapStringToMs(e)).toList();


    final List<int> cumulativeMsList = [];
    int sum = 0;
    for (final ms in lapMsList) {
      sum += ms;
      cumulativeMsList.add(sum);
    }


    final List<double> deltaMsList = [];
    for (int i = 0; i < lapMsList.length; i++) {
      if (i == 0) {
        deltaMsList.add(0);
      } else {
        deltaMsList.add((lapMsList[i] - lapMsList[i - 1]).toDouble());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sessionModel.id,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(sessionModel.date.toString()),
                    const SizedBox(height: 4),
                    Text("Total Time: ${sessionModel.totalMilliseconds}"),
                    const SizedBox(height: 4),
                    Text("Total Laps: ${sessionModel.laps.length}"),
                  ],
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.green[100],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text("Best",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              formatMs(lapMsList.reduce(min)),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.red[100],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text("Worst",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              formatMs(lapMsList.reduce(max)),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.blue[100],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text("Average",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              formatMs(getAverage(lapMsList)),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            LapTimeChart(session: sessionModel),

            const Divider(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(child: Text("Lap", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("Lap Time", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("Delta", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),

            ListView.builder(
              itemCount: sessionModel.laps.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final lap = sessionModel.laps[index];
                final cumulative = cumulativeMsList[index];
                final delta = deltaMsList[index];

                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(child: Text("Lap ${index + 1}")),
                      Expanded(child: Text(lap)),
                      Expanded(
                        child: index == 0
                            ? const Text("—")
                            : Text(
                          formatDeltaMs(delta),
                          style: TextStyle(
                            color:
                            delta > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      Expanded(child: Text(formatMs(cumulative))),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 50,),

          ],
        ),
      ),
    );

  }

}
