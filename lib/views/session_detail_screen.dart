import 'dart:math';

import 'package:chronomaster_pro/model/session_model.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';


class SessionDetailScreen extends StatelessWidget {

 SessionModel sessionModel;

   SessionDetailScreen({super.key,required this.sessionModel});

 int lapStringToMs(String lap) {
   final parts = lap.split(':');
   final minutes = int.parse(parts[0]);
   final secParts = parts[1].split('.');
   final seconds = int.parse(secParts[0]);
   final milliseconds = int.parse(secParts[1]);
   return minutes * 60 * 1000 + seconds * 1000 + milliseconds;
 }

 int getAverage(List<int> lapMsList) {
   if (lapMsList.isEmpty) return 0;
   int total = lapMsList.reduce((a, b) => a + b);
   return total ~/ lapMsList.length;
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

    List<int> lapMsList = sessionModel.laps.map((lap) => lapStringToMs(lap)).toList();
    List<int> cumulativeMsList = [];
    List<double> deltaMSList=[];
    int sum = 0;
    for (var ms in lapMsList) {
      print(ms);
      sum += ms;
      cumulativeMsList.add(sum);
    }

    for (int i=0; i <lapMsList.length;i++){
      if(i==0){
        deltaMSList.add(0);
      }else{
        final delta=(lapMsList[i]-lapMsList[i-1]);
        String formattedDelta = (delta >= 0 ? '+' : '') + delta.toStringAsFixed(3) + 's';

        print(formattedDelta);
        deltaMSList.add(delta.toDouble());
      }
      print(deltaMSList);
    }




    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: Column(
        children: [

          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( sessionModel.id,
                   // dummySession.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                   Text(
                    sessionModel.date.toString()
                   // "Date: ${DateFormat('MMM dd, yyyy').format(session.date)}",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total Time: ${sessionModel.totalMilliseconds}",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total Laps: ${sessionModel.laps.length}",
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [

                Expanded(
                  flex: 3,
                  child: Card(
                    color: Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            "Best",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatMs(lapMsList.reduce(min)), // fastest lap = best
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  flex: 4,
                  child: Card(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            "Worst",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatMs(lapMsList.reduce(max)),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  flex: 3,
                  child: Card(
                    color: Colors.blue[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            "Average",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatMs(getAverage(lapMsList)),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Lap",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Lap Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Delta Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          Expanded(
            child: ListView.builder(
              itemCount: sessionModel.laps.length,
              itemBuilder: (context, index) {
                final lap = sessionModel.laps[index];
                final cumulative = cumulativeMsList[index];
                final delta=deltaMSList[index];
                print(delta);
              //  print(lap);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(

                        flex: 4,
                        child: Text(
                          "Lap ${index + 1}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(lap),
                      ),
                      Expanded(
                        flex: 4,
                        child:index==0?
                        const Text("--------------"): Text(formatDeltaMs(delta),
                        style: TextStyle(
                          color: delta>0?Colors.red:
                          Colors.green
                        ),
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child:
                        Text(formatMs(cumulative)),
                      ),
                    ],
                  ),
                );

              },
            ),
          ),

        ],
      ),
    );
  }
}
