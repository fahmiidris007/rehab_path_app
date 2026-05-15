// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motivational_message_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MotivationalMessageEntity {
  String get id => throw _privateConstructorUsedError;
  String get textEn => throw _privateConstructorUsedError;
  String get textId => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MotivationalMessageEntityCopyWith<MotivationalMessageEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotivationalMessageEntityCopyWith<$Res> {
  factory $MotivationalMessageEntityCopyWith(MotivationalMessageEntity value,
          $Res Function(MotivationalMessageEntity) then) =
      _$MotivationalMessageEntityCopyWithImpl<$Res, MotivationalMessageEntity>;
  @useResult
  $Res call({String id, String textEn, String textId, String category});
}

/// @nodoc
class _$MotivationalMessageEntityCopyWithImpl<$Res,
        $Val extends MotivationalMessageEntity>
    implements $MotivationalMessageEntityCopyWith<$Res> {
  _$MotivationalMessageEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? textEn = null,
    Object? textId = null,
    Object? category = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      textEn: null == textEn
          ? _value.textEn
          : textEn // ignore: cast_nullable_to_non_nullable
              as String,
      textId: null == textId
          ? _value.textId
          : textId // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MotivationalMessageEntityImplCopyWith<$Res>
    implements $MotivationalMessageEntityCopyWith<$Res> {
  factory _$$MotivationalMessageEntityImplCopyWith(
          _$MotivationalMessageEntityImpl value,
          $Res Function(_$MotivationalMessageEntityImpl) then) =
      __$$MotivationalMessageEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String textEn, String textId, String category});
}

/// @nodoc
class __$$MotivationalMessageEntityImplCopyWithImpl<$Res>
    extends _$MotivationalMessageEntityCopyWithImpl<$Res,
        _$MotivationalMessageEntityImpl>
    implements _$$MotivationalMessageEntityImplCopyWith<$Res> {
  __$$MotivationalMessageEntityImplCopyWithImpl(
      _$MotivationalMessageEntityImpl _value,
      $Res Function(_$MotivationalMessageEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? textEn = null,
    Object? textId = null,
    Object? category = null,
  }) {
    return _then(_$MotivationalMessageEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      textEn: null == textEn
          ? _value.textEn
          : textEn // ignore: cast_nullable_to_non_nullable
              as String,
      textId: null == textId
          ? _value.textId
          : textId // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MotivationalMessageEntityImpl implements _MotivationalMessageEntity {
  const _$MotivationalMessageEntityImpl(
      {required this.id,
      required this.textEn,
      required this.textId,
      required this.category});

  @override
  final String id;
  @override
  final String textEn;
  @override
  final String textId;
  @override
  final String category;

  @override
  String toString() {
    return 'MotivationalMessageEntity(id: $id, textEn: $textEn, textId: $textId, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotivationalMessageEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.textEn, textEn) || other.textEn == textEn) &&
            (identical(other.textId, textId) || other.textId == textId) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, textEn, textId, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MotivationalMessageEntityImplCopyWith<_$MotivationalMessageEntityImpl>
      get copyWith => __$$MotivationalMessageEntityImplCopyWithImpl<
          _$MotivationalMessageEntityImpl>(this, _$identity);
}

abstract class _MotivationalMessageEntity implements MotivationalMessageEntity {
  const factory _MotivationalMessageEntity(
      {required final String id,
      required final String textEn,
      required final String textId,
      required final String category}) = _$MotivationalMessageEntityImpl;

  @override
  String get id;
  @override
  String get textEn;
  @override
  String get textId;
  @override
  String get category;
  @override
  @JsonKey(ignore: true)
  _$$MotivationalMessageEntityImplCopyWith<_$MotivationalMessageEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
