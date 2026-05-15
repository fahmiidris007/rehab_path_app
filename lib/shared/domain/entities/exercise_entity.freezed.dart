// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExerciseEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ExerciseCategory get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get steps => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  int get sets => throw _privateConstructorUsedError;
  int get reps => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  List<String> get safetyTips => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  ProgramLevel? get recommendedLevel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExerciseEntityCopyWith<ExerciseEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseEntityCopyWith<$Res> {
  factory $ExerciseEntityCopyWith(
          ExerciseEntity value, $Res Function(ExerciseEntity) then) =
      _$ExerciseEntityCopyWithImpl<$Res, ExerciseEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      ExerciseCategory category,
      String description,
      List<String> steps,
      int durationSeconds,
      int sets,
      int reps,
      int difficulty,
      List<String> safetyTips,
      String imagePath,
      ProgramLevel? recommendedLevel});
}

/// @nodoc
class _$ExerciseEntityCopyWithImpl<$Res, $Val extends ExerciseEntity>
    implements $ExerciseEntityCopyWith<$Res> {
  _$ExerciseEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? description = null,
    Object? steps = null,
    Object? durationSeconds = null,
    Object? sets = null,
    Object? reps = null,
    Object? difficulty = null,
    Object? safetyTips = null,
    Object? imagePath = null,
    Object? recommendedLevel = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExerciseCategory,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      safetyTips: null == safetyTips
          ? _value.safetyTips
          : safetyTips // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedLevel: freezed == recommendedLevel
          ? _value.recommendedLevel
          : recommendedLevel // ignore: cast_nullable_to_non_nullable
              as ProgramLevel?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseEntityImplCopyWith<$Res>
    implements $ExerciseEntityCopyWith<$Res> {
  factory _$$ExerciseEntityImplCopyWith(_$ExerciseEntityImpl value,
          $Res Function(_$ExerciseEntityImpl) then) =
      __$$ExerciseEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      ExerciseCategory category,
      String description,
      List<String> steps,
      int durationSeconds,
      int sets,
      int reps,
      int difficulty,
      List<String> safetyTips,
      String imagePath,
      ProgramLevel? recommendedLevel});
}

/// @nodoc
class __$$ExerciseEntityImplCopyWithImpl<$Res>
    extends _$ExerciseEntityCopyWithImpl<$Res, _$ExerciseEntityImpl>
    implements _$$ExerciseEntityImplCopyWith<$Res> {
  __$$ExerciseEntityImplCopyWithImpl(
      _$ExerciseEntityImpl _value, $Res Function(_$ExerciseEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? description = null,
    Object? steps = null,
    Object? durationSeconds = null,
    Object? sets = null,
    Object? reps = null,
    Object? difficulty = null,
    Object? safetyTips = null,
    Object? imagePath = null,
    Object? recommendedLevel = freezed,
  }) {
    return _then(_$ExerciseEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ExerciseCategory,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      safetyTips: null == safetyTips
          ? _value._safetyTips
          : safetyTips // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedLevel: freezed == recommendedLevel
          ? _value.recommendedLevel
          : recommendedLevel // ignore: cast_nullable_to_non_nullable
              as ProgramLevel?,
    ));
  }
}

/// @nodoc

class _$ExerciseEntityImpl implements _ExerciseEntity {
  const _$ExerciseEntityImpl(
      {required this.id,
      required this.name,
      required this.category,
      required this.description,
      required final List<String> steps,
      required this.durationSeconds,
      required this.sets,
      required this.reps,
      required this.difficulty,
      required final List<String> safetyTips,
      required this.imagePath,
      this.recommendedLevel})
      : _steps = steps,
        _safetyTips = safetyTips;

  @override
  final String id;
  @override
  final String name;
  @override
  final ExerciseCategory category;
  @override
  final String description;
  final List<String> _steps;
  @override
  List<String> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final int durationSeconds;
  @override
  final int sets;
  @override
  final int reps;
  @override
  final int difficulty;
  final List<String> _safetyTips;
  @override
  List<String> get safetyTips {
    if (_safetyTips is EqualUnmodifiableListView) return _safetyTips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_safetyTips);
  }

  @override
  final String imagePath;
  @override
  final ProgramLevel? recommendedLevel;

  @override
  String toString() {
    return 'ExerciseEntity(id: $id, name: $name, category: $category, description: $description, steps: $steps, durationSeconds: $durationSeconds, sets: $sets, reps: $reps, difficulty: $difficulty, safetyTips: $safetyTips, imagePath: $imagePath, recommendedLevel: $recommendedLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality()
                .equals(other._safetyTips, _safetyTips) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.recommendedLevel, recommendedLevel) ||
                other.recommendedLevel == recommendedLevel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      category,
      description,
      const DeepCollectionEquality().hash(_steps),
      durationSeconds,
      sets,
      reps,
      difficulty,
      const DeepCollectionEquality().hash(_safetyTips),
      imagePath,
      recommendedLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseEntityImplCopyWith<_$ExerciseEntityImpl> get copyWith =>
      __$$ExerciseEntityImplCopyWithImpl<_$ExerciseEntityImpl>(
          this, _$identity);
}

abstract class _ExerciseEntity implements ExerciseEntity {
  const factory _ExerciseEntity(
      {required final String id,
      required final String name,
      required final ExerciseCategory category,
      required final String description,
      required final List<String> steps,
      required final int durationSeconds,
      required final int sets,
      required final int reps,
      required final int difficulty,
      required final List<String> safetyTips,
      required final String imagePath,
      final ProgramLevel? recommendedLevel}) = _$ExerciseEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  ExerciseCategory get category;
  @override
  String get description;
  @override
  List<String> get steps;
  @override
  int get durationSeconds;
  @override
  int get sets;
  @override
  int get reps;
  @override
  int get difficulty;
  @override
  List<String> get safetyTips;
  @override
  String get imagePath;
  @override
  ProgramLevel? get recommendedLevel;
  @override
  @JsonKey(ignore: true)
  _$$ExerciseEntityImplCopyWith<_$ExerciseEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
