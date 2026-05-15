import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/program_entity.dart';
import '../../domain/enums/app_enums.dart';

part 'program_json_model.g.dart';

@JsonSerializable()
class ProgramJsonModel {
  final String level;
  final Map<String, List<String>> weeklySchedule;

  const ProgramJsonModel({
    required this.level,
    required this.weeklySchedule,
  });

  factory ProgramJsonModel.fromJson(Map<String, dynamic> json) =>
      _$ProgramJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramJsonModelToJson(this);

  ProgramEntity toEntity() {
    return ProgramEntity(
      level: ProgramLevel.values.firstWhere(
        (e) => e.name == level,
        orElse: () => ProgramLevel.beginner,
      ),
      weeklySchedule: weeklySchedule.map(
        (key, value) => MapEntry(int.parse(key), value),
      ),
    );
  }
}
