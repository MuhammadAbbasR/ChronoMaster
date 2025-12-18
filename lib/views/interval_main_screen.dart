import 'package:chronomaster_pro/views/create_interval_template.dart';
import 'package:flutter/material.dart';

class IntervalScreen extends StatefulWidget {
  const IntervalScreen({super.key});

  @override
  State<IntervalScreen> createState() => _IntervalScreenState();
}

class _IntervalScreenState extends State<IntervalScreen> {

  // 🔹 Dummy interval templates
  final List<Map<String, dynamic>> templates = [
    {
      "name": "Sprint Training",
      "steps": 6,
      "time": "30 min",
    },
    {
      "name": "HIIT Session",
      "steps": 8,
      "time": "20 min",
    },
    {
      "name": "Warm Up",
      "steps": 4,
      "time": "10 min",
    },
    {
      "name": "Endurance Run",
      "steps": 10,
      "time": "45 min",
    },
  ];

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
              child: ListView.builder(
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index];
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    onDismissed:(_){
                      templates.removeAt(index);
                      setState(() {

                      });
                    },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      //key: ValueKey<int>(templates[index]),
                    key: Key(template["name"]),
                      child: _intervalTemplateCard(
                        name: template["name"],
                        steps: template["steps"],
                        time: template["time"],
                      )

                  );
                 // return
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _intervalTemplateCard({
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
                    // TODO: Start interval timer with this template
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
