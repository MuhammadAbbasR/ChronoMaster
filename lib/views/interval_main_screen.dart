import 'package:chronomaster_pro/model/workout_template_model.dart';
import 'package:chronomaster_pro/view_model/time_interval_provider.dart';
import 'package:chronomaster_pro/views/create_interval_template.dart';
import 'package:chronomaster_pro/views/template_interval_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntervalMainScreen extends StatefulWidget {
  const IntervalMainScreen({super.key});

  @override
  State<IntervalMainScreen> createState() => _IntervalMainScreenState();
}

class _IntervalMainScreenState extends State<IntervalMainScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      context.read<TimeIntervalProvider>().fetchTemplate();
    });


  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Templates List",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: Colors.grey.shade200,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateIntervalTemplate(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Create New Template"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Consumer<TimeIntervalProvider>( builder: (context,providerList,_){

                return providerList.loading==true ? CircularProgressIndicator(color: Colors.black,): ListView.builder(
                  itemCount: providerList.templateList.length,
                  itemBuilder: (context, index) {
                    final template = providerList.templateList[index];
                    return Dismissible(
                        key: Key(template.id),
                        direction: DismissDirection.startToEnd,
                        onDismissed:(_){
                          // templates.removeAt(index);
                      //    setState(() {//

                      //    });
                       //   providerList.deleteTemplate(template);
                          context.read<TimeIntervalProvider>().deleteTemplate(template,index);

                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        //key: ValueKey<int>(templates[index]),
                        //key: Key(template.id),
                        child: _intervalTemplateCard(
                          template: template,
                          name: template.name,
                          steps: template.steps.length,
                          time: template.createdAt.toString(),
                        )
                    );
                    // return
                  },
                );

              },

              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _intervalTemplateCard({
    required WorkoutTemplate template,
    required String name,
    required int steps,
    required String time,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(label: "Steps", value: steps.toString()),
                _StatItem(label: "Time", value: time),
                TextButton.icon(
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                         IntervalScreen(template:template)));

                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
