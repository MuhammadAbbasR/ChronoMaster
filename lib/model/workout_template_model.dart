import 'package:hive/hive.dart';
import 'workout_step_model.dart';

part 'workout_template_model.g.dart';


@HiveType(typeId: 2)
class WorkoutTemplate extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final List<WorkoutStep> steps;

  WorkoutTemplate({
    required this.id,
    required this.name,
    required this.steps,
    this.description = '',
    required this.createdAt,
  });
}
