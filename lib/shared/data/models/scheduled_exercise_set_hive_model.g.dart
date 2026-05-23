// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_exercise_set_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledExerciseSetHiveModelAdapter
    extends TypeAdapter<ScheduledExerciseSetHiveModel> {
  @override
  final int typeId = 11;

  @override
  ScheduledExerciseSetHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledExerciseSetHiveModel(
      userId: fields[0] as String,
      date: fields[1] as DateTime,
      exerciseIds: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledExerciseSetHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.exerciseIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledExerciseSetHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
