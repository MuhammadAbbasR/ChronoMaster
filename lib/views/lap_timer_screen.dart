import 'package:chronomaster_pro/views/history_screen.dart';
import 'package:chronomaster_pro/widgets/save_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/lap_provider.dart';


class LapTimerScreen extends StatelessWidget {
  const LapTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LapProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lap Timer'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (context)=>const HistoryScreen()));

          },
              icon: Icon(Icons.history)
          )

        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Timer Display
            Text(
              vm.formattedTime,
            //  vm.formattedTime,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              vm.currentLapformattedTime,
              //  vm.formattedTime,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed:vm.isRunning ? (){
                    Provider.of<LapProvider>(context,listen: false).pauseTimer();
                  }:(){
                    Provider.of<LapProvider>(context,listen: false).startTimer();
                  },
                  child: vm.isRunning?const Text("Pause"):
                  const Text("Start"),
                ),
                ElevatedButton(
                  onPressed: vm.isRunning ? vm.newLap :
                  null,
                  child: Text("Lap"),
                ),
                ElevatedButton(
                  onPressed:vm.race_finished ? (){
                    vm.resetLap();
                  }:()async{
                    vm.stopTimer();
                    final sessionName = await showSaveSessionDialog(context);

    if (sessionName == null) return;
    vm.saveSession(name: sessionName);
    print("Session saved with name: $sessionName");

    },


                  child: vm.race_finished? const Text("Reset")
                      : const Text("Stop")
                  ,
                ),

             //   vm.race_finished? ElevatedButton(onPressed: (){}, child: Text("Save ")
             //   ) : Container(),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),

           vm.race_finished? Text("${vm.total_Time}"): Container(),

            /// Lap List
            Expanded(
              child: ListView.builder(
                itemCount: vm.laps.length,
                itemBuilder: (context, index) {
               //   final lapTime = vm.laps[index];
                  return ListTile(
                    leading: Text("Lap ${index+1}"),
                    trailing: Text("${vm.laps[index]}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
