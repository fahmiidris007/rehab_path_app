// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_contact_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EmergencyContactEntity {
  String get name => throw _privateConstructorUsedError;
  String get relationship => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EmergencyContactEntityCopyWith<EmergencyContactEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyContactEntityCopyWith<$Res> {
  factory $EmergencyContactEntityCopyWith(EmergencyContactEntity value,
          $Res Function(EmergencyContactEntity) then) =
      _$EmergencyContactEntityCopyWithImpl<$Res, EmergencyContactEntity>;
  @useResult
  $Res call({String name, String relationship, String phoneNumber});
}

/// @nodoc
class _$EmergencyContactEntityCopyWithImpl<$Res,
        $Val extends EmergencyContactEntity>
    implements $EmergencyContactEntityCopyWith<$Res> {
  _$EmergencyContactEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? relationship = null,
    Object? phoneNumber = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmergencyContactEntityImplCopyWith<$Res>
    implements $EmergencyContactEntityCopyWith<$Res> {
  factory _$$EmergencyContactEntityImplCopyWith(
          _$EmergencyContactEntityImpl value,
          $Res Function(_$EmergencyContactEntityImpl) then) =
      __$$EmergencyContactEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String relationship, String phoneNumber});
}

/// @nodoc
class __$$EmergencyContactEntityImplCopyWithImpl<$Res>
    extends _$EmergencyContactEntityCopyWithImpl<$Res,
        _$EmergencyContactEntityImpl>
    implements _$$EmergencyContactEntityImplCopyWith<$Res> {
  __$$EmergencyContactEntityImplCopyWithImpl(
      _$EmergencyContactEntityImpl _value,
      $Res Function(_$EmergencyContactEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? relationship = null,
    Object? phoneNumber = null,
  }) {
    return _then(_$EmergencyContactEntityImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EmergencyContactEntityImpl implements _EmergencyContactEntity {
  const _$EmergencyContactEntityImpl(
      {required this.name,
      required this.relationship,
      required this.phoneNumber});

  @override
  final String name;
  @override
  final String relationship;
  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'EmergencyContactEntity(name: $name, relationship: $relationship, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyContactEntityImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, relationship, phoneNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyContactEntityImplCopyWith<_$EmergencyContactEntityImpl>
      get copyWith => __$$EmergencyContactEntityImplCopyWithImpl<
          _$EmergencyContactEntityImpl>(this, _$identity);
}

abstract class _EmergencyContactEntity implements EmergencyContactEntity {
  const factory _EmergencyContactEntity(
      {required final String name,
      required final String relationship,
      required final String phoneNumber}) = _$EmergencyContactEntityImpl;

  @override
  String get name;
  @override
  String get relationship;
  @override
  String get phoneNumber;
  @override
  @JsonKey(ignore: true)
  _$$EmergencyContactEntityImplCopyWith<_$EmergencyContactEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
