// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProgramEntity {
  ProgramLevel get level => throw _privateConstructorUsedError;
  Map<int, List<String>> get weeklySchedule =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProgramEntityCopyWith<ProgramEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgramEntityCopyWith<$Res> {
  factory $ProgramEntityCopyWith(
          ProgramEntity value, $Res Function(ProgramEntity) then) =
      _$ProgramEntityCopyWithImpl<$Res, ProgramEntity>;
  @useResult
  $Res call({ProgramLevel level, Map<int, List<String>> weeklySchedule});
}

/// @nodoc
class _$ProgramEntityCopyWithImpl<$Res, $Val extends ProgramEntity>
    implements $ProgramEntityCopyWith<$Res> {
  _$ProgramEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? weeklySchedule = null,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as ProgramLevel,
      weeklySchedule: null == weeklySchedule
          ? _value.weeklySchedule
          : weeklySchedule // ignore: cast_nullable_to_non_nullable
              as Map<int, List<String>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgramEntityImplCopyWith<$Res>
    implements $ProgramEntityCopyWith<$Res> {
  factory _$$ProgramEntityImplCopyWith(
          _$ProgramEntityImpl value, $Res Function(_$ProgramEntityImpl) then) =
      __$$ProgramEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ProgramLevel level, Map<int, List<String>> weeklySchedule});
}

/// @nodoc
class __$$ProgramEntityImplCopyWithImpl<$Res>
    extends _$ProgramEntityCopyWithImpl<$Res, _$ProgramEntityImpl>
    implements _$$ProgramEntityImplCopyWith<$Res> {
  __$$ProgramEntityImplCopyWithImpl(
      _$ProgramEntityImpl _value, $Res Function(_$ProgramEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? weeklySchedule = null,
  }) {
    return _then(_$ProgramEntityImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as ProgramLevel,
      weeklySchedule: null == weeklySchedule
          ? _value._weeklySchedule
          : weeklySchedule // ignore: cast_nullable_to_non_nullable
              as Map<int, List<String>>,
    ));
  }
}

/// @nodoc

class _$ProgramEntityImpl implements _ProgramEntity {
  const _$ProgramEntityImpl(
      {required this.level,
      required final Map<int, List<String>> weeklySchedule})
      : _weeklySchedule = weeklySchedule;

  @override
  final ProgramLevel level;
  final Map<int, List<String>> _weeklySchedule;
  @override
  Map<int, List<String>> get weeklySchedule {
    if (_weeklySchedule is EqualUnmodifiableMapView) return _weeklySchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weeklySchedule);
  }

  @override
  String toString() {
    return 'ProgramEntity(level: $level, weeklySchedule: $weeklySchedule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgramEntityImpl &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality()
                .equals(other._weeklySchedule, _weeklySchedule));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, level, const DeepCollectionEquality().hash(_weeklySchedule));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgramEntityImplCopyWith<_$ProgramEntityImpl> get copyWith =>
      __$$ProgramEntityImplCopyWithImpl<_$ProgramEntityImpl>(this, _$identity);
}

abstract class _ProgramEntity implements ProgramEntity {
  const factory _ProgramEntity(
          {required final ProgramLevel level,
          required final Map<int, List<String>> weeklySchedule}) =
      _$ProgramEntityImpl;

  @override
  ProgramLevel get level;
  @override
  Map<int, List<String>> get weeklySchedule;
  @override
  @JsonKey(ignore: true)
  _$$ProgramEntityImplCopyWith<_$ProgramEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
