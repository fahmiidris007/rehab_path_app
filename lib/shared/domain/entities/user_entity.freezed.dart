// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  ProgramLevel get programLevel => throw _privateConstructorUsedError;
  List<String> get healthConditions => throw _privateConstructorUsedError;
  List<EmergencyContactEntity> get emergencyContacts =>
      throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarPath => throw _privateConstructorUsedError;
  OnboardingProfileEntity? get onboardingProfile =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
          UserEntity value, $Res Function(UserEntity) then) =
      _$UserEntityCopyWithImpl<$Res, UserEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String phoneNumber,
      int age,
      String gender,
      ProgramLevel programLevel,
      List<String> healthConditions,
      List<EmergencyContactEntity> emergencyContacts,
      String? email,
      String? avatarPath,
      OnboardingProfileEntity? onboardingProfile});

  $OnboardingProfileEntityCopyWith<$Res>? get onboardingProfile;
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res, $Val extends UserEntity>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? age = null,
    Object? gender = null,
    Object? programLevel = null,
    Object? healthConditions = null,
    Object? emergencyContacts = null,
    Object? email = freezed,
    Object? avatarPath = freezed,
    Object? onboardingProfile = freezed,
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
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      programLevel: null == programLevel
          ? _value.programLevel
          : programLevel // ignore: cast_nullable_to_non_nullable
              as ProgramLevel,
      healthConditions: null == healthConditions
          ? _value.healthConditions
          : healthConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emergencyContacts: null == emergencyContacts
          ? _value.emergencyContacts
          : emergencyContacts // ignore: cast_nullable_to_non_nullable
              as List<EmergencyContactEntity>,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarPath: freezed == avatarPath
          ? _value.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      onboardingProfile: freezed == onboardingProfile
          ? _value.onboardingProfile
          : onboardingProfile // ignore: cast_nullable_to_non_nullable
              as OnboardingProfileEntity?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OnboardingProfileEntityCopyWith<$Res>? get onboardingProfile {
    if (_value.onboardingProfile == null) {
      return null;
    }

    return $OnboardingProfileEntityCopyWith<$Res>(_value.onboardingProfile!,
        (value) {
      return _then(_value.copyWith(onboardingProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserEntityImplCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$$UserEntityImplCopyWith(
          _$UserEntityImpl value, $Res Function(_$UserEntityImpl) then) =
      __$$UserEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String phoneNumber,
      int age,
      String gender,
      ProgramLevel programLevel,
      List<String> healthConditions,
      List<EmergencyContactEntity> emergencyContacts,
      String? email,
      String? avatarPath,
      OnboardingProfileEntity? onboardingProfile});

  @override
  $OnboardingProfileEntityCopyWith<$Res>? get onboardingProfile;
}

/// @nodoc
class __$$UserEntityImplCopyWithImpl<$Res>
    extends _$UserEntityCopyWithImpl<$Res, _$UserEntityImpl>
    implements _$$UserEntityImplCopyWith<$Res> {
  __$$UserEntityImplCopyWithImpl(
      _$UserEntityImpl _value, $Res Function(_$UserEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? age = null,
    Object? gender = null,
    Object? programLevel = null,
    Object? healthConditions = null,
    Object? emergencyContacts = null,
    Object? email = freezed,
    Object? avatarPath = freezed,
    Object? onboardingProfile = freezed,
  }) {
    return _then(_$UserEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      programLevel: null == programLevel
          ? _value.programLevel
          : programLevel // ignore: cast_nullable_to_non_nullable
              as ProgramLevel,
      healthConditions: null == healthConditions
          ? _value._healthConditions
          : healthConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emergencyContacts: null == emergencyContacts
          ? _value._emergencyContacts
          : emergencyContacts // ignore: cast_nullable_to_non_nullable
              as List<EmergencyContactEntity>,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarPath: freezed == avatarPath
          ? _value.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      onboardingProfile: freezed == onboardingProfile
          ? _value.onboardingProfile
          : onboardingProfile // ignore: cast_nullable_to_non_nullable
              as OnboardingProfileEntity?,
    ));
  }
}

/// @nodoc

class _$UserEntityImpl implements _UserEntity {
  const _$UserEntityImpl(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.age,
      required this.gender,
      required this.programLevel,
      required final List<String> healthConditions,
      required final List<EmergencyContactEntity> emergencyContacts,
      this.email,
      this.avatarPath,
      this.onboardingProfile})
      : _healthConditions = healthConditions,
        _emergencyContacts = emergencyContacts;

  @override
  final String id;
  @override
  final String name;
  @override
  final String phoneNumber;
  @override
  final int age;
  @override
  final String gender;
  @override
  final ProgramLevel programLevel;
  final List<String> _healthConditions;
  @override
  List<String> get healthConditions {
    if (_healthConditions is EqualUnmodifiableListView)
      return _healthConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthConditions);
  }

  final List<EmergencyContactEntity> _emergencyContacts;
  @override
  List<EmergencyContactEntity> get emergencyContacts {
    if (_emergencyContacts is EqualUnmodifiableListView)
      return _emergencyContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emergencyContacts);
  }

  @override
  final String? email;
  @override
  final String? avatarPath;
  @override
  final OnboardingProfileEntity? onboardingProfile;

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, phoneNumber: $phoneNumber, age: $age, gender: $gender, programLevel: $programLevel, healthConditions: $healthConditions, emergencyContacts: $emergencyContacts, email: $email, avatarPath: $avatarPath, onboardingProfile: $onboardingProfile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.programLevel, programLevel) ||
                other.programLevel == programLevel) &&
            const DeepCollectionEquality()
                .equals(other._healthConditions, _healthConditions) &&
            const DeepCollectionEquality()
                .equals(other._emergencyContacts, _emergencyContacts) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarPath, avatarPath) ||
                other.avatarPath == avatarPath) &&
            (identical(other.onboardingProfile, onboardingProfile) ||
                other.onboardingProfile == onboardingProfile));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      phoneNumber,
      age,
      gender,
      programLevel,
      const DeepCollectionEquality().hash(_healthConditions),
      const DeepCollectionEquality().hash(_emergencyContacts),
      email,
      avatarPath,
      onboardingProfile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      __$$UserEntityImplCopyWithImpl<_$UserEntityImpl>(this, _$identity);
}

abstract class _UserEntity implements UserEntity {
  const factory _UserEntity(
      {required final String id,
      required final String name,
      required final String phoneNumber,
      required final int age,
      required final String gender,
      required final ProgramLevel programLevel,
      required final List<String> healthConditions,
      required final List<EmergencyContactEntity> emergencyContacts,
      final String? email,
      final String? avatarPath,
      final OnboardingProfileEntity? onboardingProfile}) = _$UserEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get phoneNumber;
  @override
  int get age;
  @override
  String get gender;
  @override
  ProgramLevel get programLevel;
  @override
  List<String> get healthConditions;
  @override
  List<EmergencyContactEntity> get emergencyContacts;
  @override
  String? get email;
  @override
  String? get avatarPath;
  @override
  OnboardingProfileEntity? get onboardingProfile;
  @override
  @JsonKey(ignore: true)
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
