// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_session_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExerciseSessionEntity {
  String get id => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;
  BodyCondition get bodyCondition => throw _privateConstructorUsedError;
  SupportUsed get supportUsed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExerciseSessionEntityCopyWith<ExerciseSessionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseSessionEntityCopyWith<$Res> {
  factory $ExerciseSessionEntityCopyWith(ExerciseSessionEntity value,
          $Res Function(ExerciseSessionEntity) then) =
      _$ExerciseSessionEntityCopyWithImpl<$Res, ExerciseSessionEntity>;
  @useResult
  $Res call(
      {String id,
      String exerciseId,
      String userId,
      DateTime completedAt,
      BodyCondition bodyCondition,
      SupportUsed supportUsed});
}

/// @nodoc
class _$ExerciseSessionEntityCopyWithImpl<$Res,
        $Val extends ExerciseSessionEntity>
    implements $ExerciseSessionEntityCopyWith<$Res> {
  _$ExerciseSessionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exerciseId = null,
    Object? userId = null,
    Object? completedAt = null,
    Object? bodyCondition = null,
    Object? supportUsed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bodyCondition: null == bodyCondition
          ? _value.bodyCondition
          : bodyCondition // ignore: cast_nullable_to_non_nullable
              as BodyCondition,
      supportUsed: null == supportUsed
          ? _value.supportUsed
          : supportUsed // ignore: cast_nullable_to_non_nullable
              as SupportUsed,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseSessionEntityImplCopyWith<$Res>
    implements $ExerciseSessionEntityCopyWith<$Res> {
  factory _$$ExerciseSessionEntityImplCopyWith(
          _$ExerciseSessionEntityImpl value,
          $Res Function(_$ExerciseSessionEntityImpl) then) =
      __$$ExerciseSessionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String exerciseId,
      String userId,
      DateTime completedAt,
      BodyCondition bodyCondition,
      SupportUsed supportUsed});
}

/// @nodoc
class __$$ExerciseSessionEntityImplCopyWithImpl<$Res>
    extends _$ExerciseSessionEntityCopyWithImpl<$Res,
        _$ExerciseSessionEntityImpl>
    implements _$$ExerciseSessionEntityImplCopyWith<$Res> {
  __$$ExerciseSessionEntityImplCopyWithImpl(_$ExerciseSessionEntityImpl _value,
      $Res Function(_$ExerciseSessionEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exerciseId = null,
    Object? userId = null,
    Object? completedAt = null,
    Object? bodyCondition = null,
    Object? supportUsed = null,
  }) {
    return _then(_$ExerciseSessionEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bodyCondition: null == bodyCondition
          ? _value.bodyCondition
          : bodyCondition // ignore: cast_nullable_to_non_nullable
              as BodyCondition,
      supportUsed: null == supportUsed
          ? _value.supportUsed
          : supportUsed // ignore: cast_nullable_to_non_nullable
              as SupportUsed,
    ));
  }
}

/// @nodoc

class _$ExerciseSessionEntityImpl implements _ExerciseSessionEntity {
  const _$ExerciseSessionEntityImpl(
      {required this.id,
      required this.exerciseId,
      required this.userId,
      required this.completedAt,
      required this.bodyCondition,
      required this.supportUsed});

  @override
  final String id;
  @override
  final String exerciseId;
  @override
  final String userId;
  @override
  final DateTime completedAt;
  @override
  final BodyCondition bodyCondition;
  @override
  final SupportUsed supportUsed;

  @override
  String toString() {
    return 'ExerciseSessionEntity(id: $id, exerciseId: $exerciseId, userId: $userId, completedAt: $completedAt, bodyCondition: $bodyCondition, supportUsed: $supportUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseSessionEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.bodyCondition, bodyCondition) ||
                other.bodyCondition == bodyCondition) &&
            (identical(other.supportUsed, supportUsed) ||
                other.supportUsed == supportUsed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, exerciseId, userId,
      completedAt, bodyCondition, supportUsed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseSessionEntityImplCopyWith<_$ExerciseSessionEntityImpl>
      get copyWith => __$$ExerciseSessionEntityImplCopyWithImpl<
          _$ExerciseSessionEntityImpl>(this, _$identity);
}

abstract class _ExerciseSessionEntity implements ExerciseSessionEntity {
  const factory _ExerciseSessionEntity(
      {required final String id,
      required final String exerciseId,
      required final String userId,
      required final DateTime completedAt,
      required final BodyCondition bodyCondition,
      required final SupportUsed supportUsed}) = _$ExerciseSessionEntityImpl;

  @override
  String get id;
  @override
  String get exerciseId;
  @override
  String get userId;
  @override
  DateTime get completedAt;
  @override
  BodyCondition get bodyCondition;
  @override
  SupportUsed get supportUsed;
  @override
  @JsonKey(ignore: true)
  _$$ExerciseSessionEntityImplCopyWith<_$ExerciseSessionEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
