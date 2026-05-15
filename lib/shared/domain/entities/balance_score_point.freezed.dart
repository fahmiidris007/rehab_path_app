// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_score_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BalanceScorePoint {
  DateTime get date => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BalanceScorePointCopyWith<BalanceScorePoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceScorePointCopyWith<$Res> {
  factory $BalanceScorePointCopyWith(
          BalanceScorePoint value, $Res Function(BalanceScorePoint) then) =
      _$BalanceScorePointCopyWithImpl<$Res, BalanceScorePoint>;
  @useResult
  $Res call({DateTime date, int score});
}

/// @nodoc
class _$BalanceScorePointCopyWithImpl<$Res, $Val extends BalanceScorePoint>
    implements $BalanceScorePointCopyWith<$Res> {
  _$BalanceScorePointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BalanceScorePointImplCopyWith<$Res>
    implements $BalanceScorePointCopyWith<$Res> {
  factory _$$BalanceScorePointImplCopyWith(_$BalanceScorePointImpl value,
          $Res Function(_$BalanceScorePointImpl) then) =
      __$$BalanceScorePointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int score});
}

/// @nodoc
class __$$BalanceScorePointImplCopyWithImpl<$Res>
    extends _$BalanceScorePointCopyWithImpl<$Res, _$BalanceScorePointImpl>
    implements _$$BalanceScorePointImplCopyWith<$Res> {
  __$$BalanceScorePointImplCopyWithImpl(_$BalanceScorePointImpl _value,
      $Res Function(_$BalanceScorePointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? score = null,
  }) {
    return _then(_$BalanceScorePointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BalanceScorePointImpl implements _BalanceScorePoint {
  const _$BalanceScorePointImpl({required this.date, required this.score});

  @override
  final DateTime date;
  @override
  final int score;

  @override
  String toString() {
    return 'BalanceScorePoint(date: $date, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceScorePointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.score, score) || other.score == score));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, score);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceScorePointImplCopyWith<_$BalanceScorePointImpl> get copyWith =>
      __$$BalanceScorePointImplCopyWithImpl<_$BalanceScorePointImpl>(
          this, _$identity);
}

abstract class _BalanceScorePoint implements BalanceScorePoint {
  const factory _BalanceScorePoint(
      {required final DateTime date,
      required final int score}) = _$BalanceScorePointImpl;

  @override
  DateTime get date;
  @override
  int get score;
  @override
  @JsonKey(ignore: true)
  _$$BalanceScorePointImplCopyWith<_$BalanceScorePointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
