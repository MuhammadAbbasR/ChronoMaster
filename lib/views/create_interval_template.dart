import 'package:flutter/material.dart';

class CreateIntervalTemplate extends StatefulWidget {
  const CreateIntervalTemplate({super.key});

  @override
  State<CreateIntervalTemplate> createState() => _CreateIntervalTemplateState();
}

class _CreateIntervalTemplateState extends State<CreateIntervalTemplate> {
  final _formKey = GlobalKey<FormState>();

  String? selectedWork;
  String? selectedTime;

  List<String> steps = [];

  // Dropdown options
  final List<String> workOptions = [
    "Warm Up",
    "Sprint",
    "Jog",
    "Rest",
    "Stretch"
  ];

  final List<String> warmUp = ["60", "300", "600", "900", "1200"];
  final List<String> sprintOption = ["15", "30", "60", "90", "120"];
  final List<String> jogOptions = ["120", "300", "420", "600", "900"];
  final List<String> restOptions = ["5", "10", "15", "20"];
  final List<String> stretch = ["15", "30", "60", "120", "300"];

  List<String> getDurationOptions() {
    switch (selectedWork) {
      case "Warm Up":
        return warmUp;
      case "Sprint":
        return sprintOption;
      case "Jog":
        return jogOptions;
      case "Rest":
        return restOptions;
      case "Stretch":
        return stretch;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Interval Template"),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                const Text(
                  "Add Interval Step",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Input Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDropdownField(
                          fieldKey: const ValueKey("activity_dropdown"),
                          value: selectedWork,
                          items: workOptions,
                          label: "Activity",
                          icon: Icons.fitness_center,
                          onChanged: (val) {
                            setState(() {
                              selectedWork = val;
                              selectedTime = null;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        if (selectedWork != null)
                          _buildDropdownField(
                            fieldKey: ValueKey("duration_${selectedWork}"),
                            value: selectedTime,
                            items: getDurationOptions(),
                            label: "Duration (seconds)",
                            icon: Icons.timer,
                            onChanged: (val) {
                              setState(() => selectedTime = val);
                            },

                          ),

                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                steps.add(
                                    "$selectedWork • $selectedTime sec");
                                selectedWork = null;
                                selectedTime = null;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Step added")),
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add Step"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            minimumSize:
                            const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Steps List Title
                const Text(
                  "Workout Steps",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // Empty State
                if (steps.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "No steps added yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                // Steps List
                ListView.builder(
                  itemCount: steps.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Text("${index + 1}"),
                        ),
                        title: Text(steps[index]),
                        trailing: const Icon(Icons.drag_handle),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required Key fieldKey,
    required String? value,
    required List<String> items,
    required String label,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: DropdownButtonFormField<String>(
          key: fieldKey,
          value: value,
          hint: Text("Select $label"),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: InputBorder.none,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),
          onChanged: onChanged,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Please select $label";
            }
            return null;
          },
        ),
      ),
    );
  }
}
