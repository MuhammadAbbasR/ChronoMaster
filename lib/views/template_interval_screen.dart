import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chronomaster_pro/model/workout_template_model.dart';
import 'package:chronomaster_pro/view_model/time_interval_provider.dart';

class IntervalScreen extends StatefulWidget {
  final WorkoutTemplate template;

  const IntervalScreen({super.key, required this.template});

  @override
  State<IntervalScreen> createState() => _IntervalScreenState();
}

class _IntervalScreenState extends State<IntervalScreen> {
  bool _popped = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TimeIntervalProvider>().initializeWorkout(widget.template);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeIntervalProvider>(
      builder: (context, vm, _) {

        if (vm.isWorkoutFinished && !_popped) {
          _popped = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            vm.reset();
            Navigator.pop(context);
          });
        }

        if (vm.workoutSteps.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final step = vm.workoutSteps[vm.currentStepIndex];
        final isRest = step.name.toLowerCase() == "rest";

        return Scaffold(
          backgroundColor: isRest ? Colors.blueGrey : Colors.redAccent,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  step.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  _formatTime(vm.remainingTime),
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                if (vm.currentStepIndex + 1 < vm.workoutSteps.length)
                  Text(
                    'Next: ${vm.workoutSteps[vm.currentStepIndex + 1].name}',
                    style: const TextStyle(color: Colors.white70),
                  ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      icon: Icon(
                        vm.isRunning ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        vm.isRunning ? vm.pause() : vm.resume();
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      iconSize: 40,
                      color: Colors.white,
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        vm.stop();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
