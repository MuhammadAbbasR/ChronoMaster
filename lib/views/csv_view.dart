import 'package:flutter/material.dart';

class CsvPreviewScreen extends StatelessWidget {
  const CsvPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CSV Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Lap Data (Preview)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: Text("#${index + 1}"),
                    title: const Text("Lap Time: 00:45"),
                    trailing: const Text("+00:02"),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Save CSV File"),
            )
          ],
        ),
      ),
    );
  }
}
