import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

class Lap {
  final int lapNumber;
  final Duration lapTime;
  final Duration totalTime;

  Lap({
    required this.lapNumber,
    required this.lapTime,
    required this.totalTime,
  });
}

class Session {
  final String id;
  final String title;
  final DateTime date;
  final Duration totalDuration;
  final List<Lap> laps;

  Session({
    required this.id,
    required this.title,
    required this.date,
    required this.totalDuration,
    required this.laps,
  });
}

class SessionDetailScreen extends StatelessWidget {
  final dummySession = Session(
    id: 's1',
    title: 'Morning Run',
    date: DateTime.now(),
    totalDuration: const Duration(minutes: 30, seconds: 25),
    laps: [
      Lap(
        lapNumber: 1,
        lapTime: const Duration(minutes: 5, seconds: 30),
        totalTime: const Duration(minutes: 5, seconds: 30),
      ),
      Lap(
        lapNumber: 2,
        lapTime: const Duration(minutes: 6, seconds: 0),
        totalTime: const Duration(minutes: 11, seconds: 30),
      ),
      Lap(
        lapNumber: 3,
        lapTime: const Duration(minutes: 5, seconds: 55),
        totalTime: const Duration(minutes: 17, seconds: 25),
      ),
      Lap(
        lapNumber: 4,
        lapTime: const Duration(minutes: 6, seconds: 10),
        totalTime: const Duration(minutes: 23, seconds: 35),
      ),
      Lap(
        lapNumber: 5,
        lapTime: const Duration(minutes: 6, seconds: 50),
        totalTime: const Duration(minutes: 30, seconds: 25),
      ),
    ],
  );

  SessionDetailScreen({super.key});

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: Column(
        children: [
          // 🔹 Summary Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dummySession.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    ""
                   // "Date: ${DateFormat('MMM dd, yyyy').format(session.date)}",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total Time: ${formatDuration(dummySession.totalDuration)}",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total Laps: ${dummySession.laps.length}",
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Laps Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Lap", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Lap Time", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          const Divider(),

          // 🔹 Laps List
          Expanded(
            child: ListView.builder(
              itemCount: dummySession.laps.length,
              itemBuilder: (context, index) {
                final lap = dummySession.laps[index];
                return ListTile(
                  leading: Text(
                    "Lap ${lap.lapNumber}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  title: Text(formatDuration(lap.lapTime)),
                  trailing: Text(formatDuration(lap.totalTime)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
