// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BadgeHiveModelAdapter extends TypeAdapter<BadgeHiveModel> {
  @override
  final int typeId = 5;

  @override
  BadgeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BadgeHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      iconPath: fields[2] as String,
      unlockCondition: fields[3] as String,
      isEarned: fields[4] as bool,
      earnedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BadgeHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconPath)
      ..writeByte(3)
      ..write(obj.unlockCondition)
      ..writeByte(4)
      ..write(obj.isEarned)
      ..writeByte(5)
      ..write(obj.earnedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
