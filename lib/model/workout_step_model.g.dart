// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_step_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutStepAdapter extends TypeAdapter<WorkoutStep> {
  @override
  final int typeId = 1;

  @override
  WorkoutStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutStep(
      id: fields[0] as String,
      name: fields[1] as String,
      duration: fields[2] as int,
      alert: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutStep obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.alert);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
