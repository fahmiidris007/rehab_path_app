import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'program_entity.freezed.dart';

@freezed
class ProgramEntity with _$ProgramEntity {
  const factory ProgramEntity({
    required ProgramLevel level,
    required Map<int, List<String>> weeklySchedule,
  }) = _ProgramEntity;
}
