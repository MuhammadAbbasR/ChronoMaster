import 'package:chronomaster_pro/model/workout_step_model.dart';
import 'package:chronomaster_pro/model/workout_template_model.dart';

final recoveryTemplate = WorkoutTemplate(
  id: 't_recovery',
  name: 'Recovery Stretch',
  description: 'Light movement and stretching',
  createdAt: DateTime.now(),
  steps: [

    WorkoutStep(
      id: 's1',
      name: 'Light Walk',
      duration: 180,
    ),
    WorkoutStep(
      id: 's2',
      name: 'Hamstring Stretch',
      duration: 60,
    ),
    WorkoutStep(
      id: 's3',
      name: 'Calf Stretch',
      duration: 60,
    ),
    WorkoutStep(
      id: 's4',
      name: 'Deep Breathing',
      duration: 120,
    ),

  ],
);
