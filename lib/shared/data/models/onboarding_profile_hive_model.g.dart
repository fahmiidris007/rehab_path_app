// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_profile_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardingProfileHiveModelAdapter
    extends TypeAdapter<OnboardingProfileHiveModel> {
  @override
  final int typeId = 2;

  @override
  OnboardingProfileHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnboardingProfileHiveModel(
      age: fields[0] as int,
      gender: fields[1] as String,
      fallsInLastYear: fields[2] as int,
      healthConditions: (fields[3] as List).cast<String>(),
      usesWalkingAid: fields[4] as bool,
      fearOfFallingScore: fields[5] as int,
      preferredExerciseTime: fields[6] as String,
      sessionDurationMinutes: fields[7] as int,
      weeklyFrequencyTarget: fields[8] as int,
      outcomeGoal: fields[9] as String,
      behaviouralGoal: fields[10] as String,
      programLevel: fields[11] as String,
      lastCompletedStep: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingProfileHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.fallsInLastYear)
      ..writeByte(3)
      ..write(obj.healthConditions)
      ..writeByte(4)
      ..write(obj.usesWalkingAid)
      ..writeByte(5)
      ..write(obj.fearOfFallingScore)
      ..writeByte(6)
      ..write(obj.preferredExerciseTime)
      ..writeByte(7)
      ..write(obj.sessionDurationMinutes)
      ..writeByte(8)
      ..write(obj.weeklyFrequencyTarget)
      ..writeByte(9)
      ..write(obj.outcomeGoal)
      ..writeByte(10)
      ..write(obj.behaviouralGoal)
      ..writeByte(11)
      ..write(obj.programLevel)
      ..writeByte(12)
      ..write(obj.lastCompletedStep);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingProfileHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
