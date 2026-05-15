// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fall_event_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FallEventHiveModelAdapter extends TypeAdapter<FallEventHiveModel> {
  @override
  final int typeId = 4;

  @override
  FallEventHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FallEventHiveModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FallEventHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FallEventHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
