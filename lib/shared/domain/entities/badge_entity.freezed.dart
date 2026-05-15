// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BadgeEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get iconPath => throw _privateConstructorUsedError;
  String get unlockCondition => throw _privateConstructorUsedError;
  bool get isEarned => throw _privateConstructorUsedError;
  DateTime? get earnedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BadgeEntityCopyWith<BadgeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeEntityCopyWith<$Res> {
  factory $BadgeEntityCopyWith(
          BadgeEntity value, $Res Function(BadgeEntity) then) =
      _$BadgeEntityCopyWithImpl<$Res, BadgeEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String iconPath,
      String unlockCondition,
      bool isEarned,
      DateTime? earnedAt});
}

/// @nodoc
class _$BadgeEntityCopyWithImpl<$Res, $Val extends BadgeEntity>
    implements $BadgeEntityCopyWith<$Res> {
  _$BadgeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconPath = null,
    Object? unlockCondition = null,
    Object? isEarned = null,
    Object? earnedAt = freezed,
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
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      unlockCondition: null == unlockCondition
          ? _value.unlockCondition
          : unlockCondition // ignore: cast_nullable_to_non_nullable
              as String,
      isEarned: null == isEarned
          ? _value.isEarned
          : isEarned // ignore: cast_nullable_to_non_nullable
              as bool,
      earnedAt: freezed == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BadgeEntityImplCopyWith<$Res>
    implements $BadgeEntityCopyWith<$Res> {
  factory _$$BadgeEntityImplCopyWith(
          _$BadgeEntityImpl value, $Res Function(_$BadgeEntityImpl) then) =
      __$$BadgeEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String iconPath,
      String unlockCondition,
      bool isEarned,
      DateTime? earnedAt});
}

/// @nodoc
class __$$BadgeEntityImplCopyWithImpl<$Res>
    extends _$BadgeEntityCopyWithImpl<$Res, _$BadgeEntityImpl>
    implements _$$BadgeEntityImplCopyWith<$Res> {
  __$$BadgeEntityImplCopyWithImpl(
      _$BadgeEntityImpl _value, $Res Function(_$BadgeEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconPath = null,
    Object? unlockCondition = null,
    Object? isEarned = null,
    Object? earnedAt = freezed,
  }) {
    return _then(_$BadgeEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      unlockCondition: null == unlockCondition
          ? _value.unlockCondition
          : unlockCondition // ignore: cast_nullable_to_non_nullable
              as String,
      isEarned: null == isEarned
          ? _value.isEarned
          : isEarned // ignore: cast_nullable_to_non_nullable
              as bool,
      earnedAt: freezed == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BadgeEntityImpl implements _BadgeEntity {
  const _$BadgeEntityImpl(
      {required this.id,
      required this.name,
      required this.iconPath,
      required this.unlockCondition,
      required this.isEarned,
      this.earnedAt});

  @override
  final String id;
  @override
  final String name;
  @override
  final String iconPath;
  @override
  final String unlockCondition;
  @override
  final bool isEarned;
  @override
  final DateTime? earnedAt;

  @override
  String toString() {
    return 'BadgeEntity(id: $id, name: $name, iconPath: $iconPath, unlockCondition: $unlockCondition, isEarned: $isEarned, earnedAt: $earnedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath) &&
            (identical(other.unlockCondition, unlockCondition) ||
                other.unlockCondition == unlockCondition) &&
            (identical(other.isEarned, isEarned) ||
                other.isEarned == isEarned) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, iconPath, unlockCondition, isEarned, earnedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeEntityImplCopyWith<_$BadgeEntityImpl> get copyWith =>
      __$$BadgeEntityImplCopyWithImpl<_$BadgeEntityImpl>(this, _$identity);
}

abstract class _BadgeEntity implements BadgeEntity {
  const factory _BadgeEntity(
      {required final String id,
      required final String name,
      required final String iconPath,
      required final String unlockCondition,
      required final bool isEarned,
      final DateTime? earnedAt}) = _$BadgeEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get iconPath;
  @override
  String get unlockCondition;
  @override
  bool get isEarned;
  @override
  DateTime? get earnedAt;
  @override
  @JsonKey(ignore: true)
  _$$BadgeEntityImplCopyWith<_$BadgeEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
