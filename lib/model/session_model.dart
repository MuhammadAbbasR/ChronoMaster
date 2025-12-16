import 'package:hive/hive.dart';

part "session_model.g.dart";


@HiveType(typeId: 0)
class SessionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String totalMilliseconds;

  @HiveField(3)
  final List<String> laps;

  SessionModel({
    required this.id,
    required this.date,
    required this.totalMilliseconds,
    required this.laps,
  });
}
