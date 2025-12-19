import 'package:hive/hive.dart';

part 'workout_step_model.g.dart';


@HiveType(typeId: 1)
class WorkoutStep extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int duration; // in seconds



  @HiveField(3)
  final bool alert;

  WorkoutStep({
    required this.id,
    required this.name,
    required this.duration,
    this.alert = true,
  });
}
