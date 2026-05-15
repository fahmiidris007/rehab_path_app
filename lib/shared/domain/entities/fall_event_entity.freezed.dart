// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fall_event_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FallEventEntity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FallEventEntityCopyWith<FallEventEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FallEventEntityCopyWith<$Res> {
  factory $FallEventEntityCopyWith(
          FallEventEntity value, $Res Function(FallEventEntity) then) =
      _$FallEventEntityCopyWithImpl<$Res, FallEventEntity>;
  @useResult
  $Res call({String id, String userId, DateTime date});
}

/// @nodoc
class _$FallEventEntityCopyWithImpl<$Res, $Val extends FallEventEntity>
    implements $FallEventEntityCopyWith<$Res> {
  _$FallEventEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FallEventEntityImplCopyWith<$Res>
    implements $FallEventEntityCopyWith<$Res> {
  factory _$$FallEventEntityImplCopyWith(_$FallEventEntityImpl value,
          $Res Function(_$FallEventEntityImpl) then) =
      __$$FallEventEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String userId, DateTime date});
}

/// @nodoc
class __$$FallEventEntityImplCopyWithImpl<$Res>
    extends _$FallEventEntityCopyWithImpl<$Res, _$FallEventEntityImpl>
    implements _$$FallEventEntityImplCopyWith<$Res> {
  __$$FallEventEntityImplCopyWithImpl(
      _$FallEventEntityImpl _value, $Res Function(_$FallEventEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
  }) {
    return _then(_$FallEventEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$FallEventEntityImpl implements _FallEventEntity {
  const _$FallEventEntityImpl(
      {required this.id, required this.userId, required this.date});

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'FallEventEntity(id: $id, userId: $userId, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FallEventEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, userId, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FallEventEntityImplCopyWith<_$FallEventEntityImpl> get copyWith =>
      __$$FallEventEntityImplCopyWithImpl<_$FallEventEntityImpl>(
          this, _$identity);
}

abstract class _FallEventEntity implements FallEventEntity {
  const factory _FallEventEntity(
      {required final String id,
      required final String userId,
      required final DateTime date}) = _$FallEventEntityImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get date;
  @override
  @JsonKey(ignore: true)
  _$$FallEventEntityImplCopyWith<_$FallEventEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
