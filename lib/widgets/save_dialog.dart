import "package:flutter/material.dart";

Future<String?> showSaveSessionDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: false, // must choose button
    builder: (context) {
      return AlertDialog(
        title: const Text("Save Session"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Enter session name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, null); // Cancel
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              Navigator.pop(context, controller.text.trim());
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
