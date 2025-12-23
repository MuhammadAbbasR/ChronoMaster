import 'package:chronomaster_pro/model/workout_step_model.dart';
import 'package:chronomaster_pro/model/workout_template_model.dart' show WorkoutTemplate;

final hiitSprintTemplate = WorkoutTemplate(
  id: 't_hiit',
  name: 'HIIT Sprint',
  description: 'High intensity sprint intervals',
  createdAt: DateTime.now(),
  steps: [
    WorkoutStep(
      id: 's1',
      name: 'Warm-up',
      duration: 300,

    ),
    WorkoutStep(
      id: 's2',
      name: 'Sprint',
      duration: 60,

    ),
    WorkoutStep(
      id: 's3',
      name: 'Rest',
      duration: 30,

    ),
    WorkoutStep(
      id: 's4',
      name: 'Sprint',
      duration: 60,
  
    ),
    WorkoutStep(
      id: 's5',
      name: 'Cool Down',
      duration: 240,

    ),
  ],
);
