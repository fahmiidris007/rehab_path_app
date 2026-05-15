// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_data_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProgressDataEntity {
  String get userId => throw _privateConstructorUsedError;
  List<BalanceScorePoint> get balanceScores =>
      throw _privateConstructorUsedError;
  List<ExerciseSessionEntity> get sessions =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProgressDataEntityCopyWith<ProgressDataEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressDataEntityCopyWith<$Res> {
  factory $ProgressDataEntityCopyWith(
          ProgressDataEntity value, $Res Function(ProgressDataEntity) then) =
      _$ProgressDataEntityCopyWithImpl<$Res, ProgressDataEntity>;
  @useResult
  $Res call(
      {String userId,
      List<BalanceScorePoint> balanceScores,
      List<ExerciseSessionEntity> sessions});
}

/// @nodoc
class _$ProgressDataEntityCopyWithImpl<$Res, $Val extends ProgressDataEntity>
    implements $ProgressDataEntityCopyWith<$Res> {
  _$ProgressDataEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? balanceScores = null,
    Object? sessions = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      balanceScores: null == balanceScores
          ? _value.balanceScores
          : balanceScores // ignore: cast_nullable_to_non_nullable
              as List<BalanceScorePoint>,
      sessions: null == sessions
          ? _value.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<ExerciseSessionEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressDataEntityImplCopyWith<$Res>
    implements $ProgressDataEntityCopyWith<$Res> {
  factory _$$ProgressDataEntityImplCopyWith(_$ProgressDataEntityImpl value,
          $Res Function(_$ProgressDataEntityImpl) then) =
      __$$ProgressDataEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      List<BalanceScorePoint> balanceScores,
      List<ExerciseSessionEntity> sessions});
}

/// @nodoc
class __$$ProgressDataEntityImplCopyWithImpl<$Res>
    extends _$ProgressDataEntityCopyWithImpl<$Res, _$ProgressDataEntityImpl>
    implements _$$ProgressDataEntityImplCopyWith<$Res> {
  __$$ProgressDataEntityImplCopyWithImpl(_$ProgressDataEntityImpl _value,
      $Res Function(_$ProgressDataEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? balanceScores = null,
    Object? sessions = null,
  }) {
    return _then(_$ProgressDataEntityImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      balanceScores: null == balanceScores
          ? _value._balanceScores
          : balanceScores // ignore: cast_nullable_to_non_nullable
              as List<BalanceScorePoint>,
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<ExerciseSessionEntity>,
    ));
  }
}

/// @nodoc

class _$ProgressDataEntityImpl implements _ProgressDataEntity {
  const _$ProgressDataEntityImpl(
      {required this.userId,
      required final List<BalanceScorePoint> balanceScores,
      required final List<ExerciseSessionEntity> sessions})
      : _balanceScores = balanceScores,
        _sessions = sessions;

  @override
  final String userId;
  final List<BalanceScorePoint> _balanceScores;
  @override
  List<BalanceScorePoint> get balanceScores {
    if (_balanceScores is EqualUnmodifiableListView) return _balanceScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_balanceScores);
  }

  final List<ExerciseSessionEntity> _sessions;
  @override
  List<ExerciseSessionEntity> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  String toString() {
    return 'ProgressDataEntity(userId: $userId, balanceScores: $balanceScores, sessions: $sessions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressDataEntityImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._balanceScores, _balanceScores) &&
            const DeepCollectionEquality().equals(other._sessions, _sessions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      const DeepCollectionEquality().hash(_balanceScores),
      const DeepCollectionEquality().hash(_sessions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressDataEntityImplCopyWith<_$ProgressDataEntityImpl> get copyWith =>
      __$$ProgressDataEntityImplCopyWithImpl<_$ProgressDataEntityImpl>(
          this, _$identity);
}

abstract class _ProgressDataEntity implements ProgressDataEntity {
  const factory _ProgressDataEntity(
          {required final String userId,
          required final List<BalanceScorePoint> balanceScores,
          required final List<ExerciseSessionEntity> sessions}) =
      _$ProgressDataEntityImpl;

  @override
  String get userId;
  @override
  List<BalanceScorePoint> get balanceScores;
  @override
  List<ExerciseSessionEntity> get sessions;
  @override
  @JsonKey(ignore: true)
  _$$ProgressDataEntityImplCopyWith<_$ProgressDataEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
