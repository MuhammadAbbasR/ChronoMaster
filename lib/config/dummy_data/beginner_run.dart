import 'package:chronomaster_pro/model/workout_step_model.dart';
import 'package:chronomaster_pro/model/workout_template_model.dart';

final beginnerRunTemplate = WorkoutTemplate(
  id: 't_beginner',
  name: 'Beginner Run',
  description: 'Easy run with walk breaks',
  createdAt: DateTime.now(),
  steps: [
    WorkoutStep(
      id: 's1',
      name: 'Warm-up Walk',
      duration: 300,

    ),
    WorkoutStep(
      id: 's2',
      name: 'Jog',
      duration: 120,

    ),
    WorkoutStep(
      id: 's3',
      name: 'Walk',
      duration: 90,

    ),
    WorkoutStep(
      id: 's4',
      name: 'Jog',
      duration: 120,

    ),
    WorkoutStep(
      id: 's5',
      name: 'Cool Down Walk',
      duration: 300,

    ),
  ],
);
