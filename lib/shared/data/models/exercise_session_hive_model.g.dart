// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_session_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseSessionHiveModelAdapter
    extends TypeAdapter<ExerciseSessionHiveModel> {
  @override
  final int typeId = 3;

  @override
  ExerciseSessionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseSessionHiveModel(
      id: fields[0] as String,
      exerciseId: fields[1] as String,
      userId: fields[2] as String,
      completedAt: fields[3] as DateTime,
      bodyCondition: fields[4] as String,
      supportUsed: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseSessionHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.exerciseId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.completedAt)
      ..writeByte(4)
      ..write(obj.bodyCondition)
      ..writeByte(5)
      ..write(obj.supportUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSessionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
