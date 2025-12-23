import 'dart:async';
import 'package:chronomaster_pro/model/workout_step_model.dart';
import 'package:chronomaster_pro/model/workout_template_model.dart';
import 'package:flutter/material.dart';

class IntervalScreen extends StatefulWidget {
  final WorkoutTemplate template;
  const IntervalScreen({super.key, required this.template});

  @override
  State<IntervalScreen> createState() => _IntervalScreenState();
}

class _IntervalScreenState extends State<IntervalScreen> {
  int currentStepIndex = 0;
  late int remainingSeconds;
  Timer? _timer;
  bool isRunning = true;

  WorkoutStep get currentStep =>
      widget.template.steps[currentStepIndex];

  @override
  void initState() {
    super.initState();
    remainingSeconds = currentStep.duration;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRunning) return;

      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        moveToNextStep();
      }
    });
  }

  void moveToNextStep() {
    if (currentStepIndex < widget.template.steps.length - 1) {
      setState(() {
        currentStepIndex++;
        remainingSeconds = currentStep.duration;
      });
    } else {
      _timer?.cancel();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRest = currentStep.name == "Rest";

    return Scaffold(
      backgroundColor: isRest ? Colors.blueGrey : Colors.redAccent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              currentStep.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              formatTime(remainingSeconds),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            if (currentStepIndex + 1 < widget.template.steps.length)
              Text(
                'Next: ${widget.template.steps[currentStepIndex + 1].name}',
                style: const TextStyle(color: Colors.white70),
              ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  color: Colors.white,
                  icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      isRunning = !isRunning;
                    });
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 40,
                  color: Colors.white,
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

}