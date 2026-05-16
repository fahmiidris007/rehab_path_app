// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sos_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SosState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<EmergencyContactEntity> contacts) loaded,
    required TResult Function(List<EmergencyContactEntity> contacts) saving,
    required TResult Function(String message) error,
    required TResult Function() callNotSupported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult? Function(List<EmergencyContactEntity> contacts)? saving,
    TResult? Function(String message)? error,
    TResult? Function()? callNotSupported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult Function(List<EmergencyContactEntity> contacts)? saving,
    TResult Function(String message)? error,
    TResult Function()? callNotSupported,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SosLoading value) loading,
    required TResult Function(SosLoaded value) loaded,
    required TResult Function(SosSaving value) saving,
    required TResult Function(SosError value) error,
    required TResult Function(SosCallNotSupported value) callNotSupported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SosLoading value)? loading,
    TResult? Function(SosLoaded value)? loaded,
    TResult? Function(SosSaving value)? saving,
    TResult? Function(SosError value)? error,
    TResult? Function(SosCallNotSupported value)? callNotSupported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SosLoading value)? loading,
    TResult Function(SosLoaded value)? loaded,
    TResult Function(SosSaving value)? saving,
    TResult Function(SosError value)? error,
    TResult Function(SosCallNotSupported value)? callNotSupported,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SosStateCopyWith<$Res> {
  factory $SosStateCopyWith(SosState value, $Res Function(SosState) then) =
      _$SosStateCopyWithImpl<$Res, SosState>;
}

/// @nodoc
class _$SosStateCopyWithImpl<$Res, $Val extends SosState>
    implements $SosStateCopyWith<$Res> {
  _$SosStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SosLoadingImplCopyWith<$Res> {
  factory _$$SosLoadingImplCopyWith(
          _$SosLoadingImpl value, $Res Function(_$SosLoadingImpl) then) =
      __$$SosLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SosLoadingImplCopyWithImpl<$Res>
    extends _$SosStateCopyWithImpl<$Res, _$SosLoadingImpl>
    implements _$$SosLoadingImplCopyWith<$Res> {
  __$$SosLoadingImplCopyWithImpl(
      _$SosLoadingImpl _value, $Res Function(_$SosLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SosLoadingImpl implements SosLoading {
  const _$SosLoadingImpl();

  @override
  String toString() {
    return 'SosState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SosLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<EmergencyContactEntity> contacts) loaded,
    required TResult Function(List<EmergencyContactEntity> contacts) saving,
    required TResult Function(String message) error,
    required TResult Function() callNotSupported,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult? Function(List<EmergencyContactEntity> contacts)? saving,
    TResult? Function(String message)? error,
    TResult? Function()? callNotSupported,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult Function(List<EmergencyContactEntity> contacts)? saving,
    TResult Function(String message)? error,
    TResult Function()? callNotSupported,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SosLoading value) loading,
    required TResult Function(SosLoaded value) loaded,
    required TResult Function(SosSaving value) saving,
    required TResult Function(SosError value) error,
    required TResult Function(SosCallNotSupported value) callNotSupported,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SosLoading value)? loading,
    TResult? Function(SosLoaded value)? loaded,
    TResult? Function(SosSaving value)? saving,
    TResult? Function(SosError value)? error,
    TResult? Function(SosCallNotSupported value)? callNotSupported,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SosLoading value)? loading,
    TResult Function(SosLoaded value)? loaded,
    TResult Function(SosSaving value)? saving,
    TResult Function(SosError value)? error,
    TResult Function(SosCallNotSupported value)? callNotSupported,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SosLoading implements SosState {
  const factory SosLoading() = _$SosLoadingImpl;
}

/// @nodoc
abstract class _$$SosLoadedImplCopyWith<$Res> {
  factory _$$SosLoadedImplCopyWith(
          _$SosLoadedImpl value, $Res Function(_$SosLoadedImpl) then) =
      __$$SosLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<EmergencyContactEntity> contacts});
}

/// @nodoc
class __$$SosLoadedImplCopyWithImpl<$Res>
    extends _$SosStateCopyWithImpl<$Res, _$SosLoadedImpl>
    implements _$$SosLoadedImplCopyWith<$Res> {
  __$$SosLoadedImplCopyWithImpl(
      _$SosLoadedImpl _value, $Res Function(_$SosLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contacts = null,
  }) {
    return _then(_$SosLoadedImpl(
      null == contacts
          ? _value._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<EmergencyContactEntity>,
    ));
  }
}

/// @nodoc

class _$SosLoadedImpl implements SosLoaded {
  const _$SosLoadedImpl(final List<EmergencyContactEntity> contacts)
      : _contacts = contacts;

  final List<EmergencyContactEntity> _contacts;
  @override
  List<EmergencyContactEntity> get contacts {
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contacts);
  }

  @override
  String toString() {
    return 'SosState.loaded(contacts: $contacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SosLoadedImpl &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_contacts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SosLoadedImplCopyWith<_$SosLoadedImpl> get copyWith =>
      __$$SosLoadedImplCopyWithImpl<_$SosLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<EmergencyContactEntity> contacts) loaded,
    required TResult Function(List<EmergencyContactEntity> contacts) saving,
    required TResult Function(String message) error,
    required TResult Function() callNotSupported,
  }) {
    return loaded(contacts);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult? Function(List<EmergencyContactEntity> contacts)? saving,
    TResult? Function(String message)? error,
    TResult? Function()? callNotSupported,
  }) {
    return loaded?.call(contacts);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult Function(List<EmergencyContactEntity> contacts)? saving,
    TResult Function(String message)? error,
    TResult Function()? callNotSupported,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(contacts);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SosLoading value) loading,
    required TResult Function(SosLoaded value) loaded,
    required TResult Function(SosSaving value) saving,
    required TResult Function(SosError value) error,
    required TResult Function(SosCallNotSupported value) callNotSupported,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SosLoading value)? loading,
    TResult? Function(SosLoaded value)? loaded,
    TResult? Function(SosSaving value)? saving,
    TResult? Function(SosError value)? error,
    TResult? Function(SosCallNotSupported value)? callNotSupported,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SosLoading value)? loading,
    TResult Function(SosLoaded value)? loaded,
    TResult Function(SosSaving value)? saving,
    TResult Function(SosError value)? error,
    TResult Function(SosCallNotSupported value)? callNotSupported,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SosLoaded implements SosState {
  const factory SosLoaded(final List<EmergencyContactEntity> contacts) =
      _$SosLoadedImpl;

  List<EmergencyContactEntity> get contacts;
  @JsonKey(ignore: true)
  _$$SosLoadedImplCopyWith<_$SosLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SosSavingImplCopyWith<$Res> {
  factory _$$SosSavingImplCopyWith(
          _$SosSavingImpl value, $Res Function(_$SosSavingImpl) then) =
      __$$SosSavingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<EmergencyContactEntity> contacts});
}

/// @nodoc
class __$$SosSavingImplCopyWithImpl<$Res>
    extends _$SosStateCopyWithImpl<$Res, _$SosSavingImpl>
    implements _$$SosSavingImplCopyWith<$Res> {
  __$$SosSavingImplCopyWithImpl(
      _$SosSavingImpl _value, $Res Function(_$SosSavingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contacts = null,
  }) {
    return _then(_$SosSavingImpl(
      null == contacts
          ? _value._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<EmergencyContactEntity>,
    ));
  }
}

/// @nodoc

class _$SosSavingImpl implements SosSaving {
  const _$SosSavingImpl(final List<EmergencyContactEntity> contacts)
      : _contacts = contacts;

  final List<EmergencyContactEntity> _contacts;
  @override
  List<EmergencyContactEntity> get contacts {
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contacts);
  }

  @override
  String toString() {
    return 'SosState.saving(contacts: $contacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SosSavingImpl &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_contacts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SosSavingImplCopyWith<_$SosSavingImpl> get copyWith =>
      __$$SosSavingImplCopyWithImpl<_$SosSavingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<EmergencyContactEntity> contacts) loaded,
    required TResult Function(List<EmergencyContactEntity> contacts) saving,
    required TResult Function(String message) error,
    required TResult Function() callNotSupported,
  }) {
    return saving(contacts);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult? Function(List<EmergencyContactEntity> contacts)? saving,
    TResult? Function(String message)? error,
    TResult? Function()? callNotSupported,
  }) {
    return saving?.call(contacts);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult Function(List<EmergencyContactEntity> contacts)? saving,
    TResult Function(String message)? error,
    TResult Function()? callNotSupported,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving(contacts);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SosLoading value) loading,
    required TResult Function(SosLoaded value) loaded,
    required TResult Function(SosSaving value) saving,
    required TResult Function(SosError value) error,
    required TResult Function(SosCallNotSupported value) callNotSupported,
  }) {
    return saving(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SosLoading value)? loading,
    TResult? Function(SosLoaded value)? loaded,
    TResult? Function(SosSaving value)? saving,
    TResult? Function(SosError value)? error,
    TResult? Function(SosCallNotSupported value)? callNotSupported,
  }) {
    return saving?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SosLoading value)? loading,
    TResult Function(SosLoaded value)? loaded,
    TResult Function(SosSaving value)? saving,
    TResult Function(SosError value)? error,
    TResult Function(SosCallNotSupported value)? callNotSupported,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving(this);
    }
    return orElse();
  }
}

abstract class SosSaving implements SosState {
  const factory SosSaving(final List<EmergencyContactEntity> contacts) =
      _$SosSavingImpl;

  List<EmergencyContactEntity> get contacts;
  @JsonKey(ignore: true)
  _$$SosSavingImplCopyWith<_$SosSavingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SosErrorImplCopyWith<$Res> {
  factory _$$SosErrorImplCopyWith(
          _$SosErrorImpl value, $Res Function(_$SosErrorImpl) then) =
      __$$SosErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SosErrorImplCopyWithImpl<$Res>
    extends _$SosStateCopyWithImpl<$Res, _$SosErrorImpl>
    implements _$$SosErrorImplCopyWith<$Res> {
  __$$SosErrorImplCopyWithImpl(
      _$SosErrorImpl _value, $Res Function(_$SosErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SosErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SosErrorImpl implements SosError {
  const _$SosErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SosState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SosErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SosErrorImplCopyWith<_$SosErrorImpl> get copyWith =>
      __$$SosErrorImplCopyWithImpl<_$SosErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<EmergencyContactEntity> contacts) loaded,
    required TResult Function(List<EmergencyContactEntity> contacts) saving,
    required TResult Function(String message) error,
    required TResult Function() callNotSupported,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult? Function(List<EmergencyContactEntity> contacts)? saving,
    TResult? Function(String message)? error,
    TResult? Function()? callNotSupported,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult Function(List<EmergencyContactEntity> contacts)? saving,
    TResult Function(String message)? error,
    TResult Function()? callNotSupported,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SosLoading value) loading,
    required TResult Function(SosLoaded value) loaded,
    required TResult Function(SosSaving value) saving,
    required TResult Function(SosError value) error,
    required TResult Function(SosCallNotSupported value) callNotSupported,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SosLoading value)? loading,
    TResult? Function(SosLoaded value)? loaded,
    TResult? Function(SosSaving value)? saving,
    TResult? Function(SosError value)? error,
    TResult? Function(SosCallNotSupported value)? callNotSupported,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SosLoading value)? loading,
    TResult Function(SosLoaded value)? loaded,
    TResult Function(SosSaving value)? saving,
    TResult Function(SosError value)? error,
    TResult Function(SosCallNotSupported value)? callNotSupported,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SosError implements SosState {
  const factory SosError(final String message) = _$SosErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$SosErrorImplCopyWith<_$SosErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SosCallNotSupportedImplCopyWith<$Res> {
  factory _$$SosCallNotSupportedImplCopyWith(_$SosCallNotSupportedImpl value,
          $Res Function(_$SosCallNotSupportedImpl) then) =
      __$$SosCallNotSupportedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SosCallNotSupportedImplCopyWithImpl<$Res>
    extends _$SosStateCopyWithImpl<$Res, _$SosCallNotSupportedImpl>
    implements _$$SosCallNotSupportedImplCopyWith<$Res> {
  __$$SosCallNotSupportedImplCopyWithImpl(_$SosCallNotSupportedImpl _value,
      $Res Function(_$SosCallNotSupportedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SosCallNotSupportedImpl implements SosCallNotSupported {
  const _$SosCallNotSupportedImpl();

  @override
  String toString() {
    return 'SosState.callNotSupported()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SosCallNotSupportedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<EmergencyContactEntity> contacts) loaded,
    required TResult Function(List<EmergencyContactEntity> contacts) saving,
    required TResult Function(String message) error,
    required TResult Function() callNotSupported,
  }) {
    return callNotSupported();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult? Function(List<EmergencyContactEntity> contacts)? saving,
    TResult? Function(String message)? error,
    TResult? Function()? callNotSupported,
  }) {
    return callNotSupported?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<EmergencyContactEntity> contacts)? loaded,
    TResult Function(List<EmergencyContactEntity> contacts)? saving,
    TResult Function(String message)? error,
    TResult Function()? callNotSupported,
    required TResult orElse(),
  }) {
    if (callNotSupported != null) {
      return callNotSupported();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SosLoading value) loading,
    required TResult Function(SosLoaded value) loaded,
    required TResult Function(SosSaving value) saving,
    required TResult Function(SosError value) error,
    required TResult Function(SosCallNotSupported value) callNotSupported,
  }) {
    return callNotSupported(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SosLoading value)? loading,
    TResult? Function(SosLoaded value)? loaded,
    TResult? Function(SosSaving value)? saving,
    TResult? Function(SosError value)? error,
    TResult? Function(SosCallNotSupported value)? callNotSupported,
  }) {
    return callNotSupported?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SosLoading value)? loading,
    TResult Function(SosLoaded value)? loaded,
    TResult Function(SosSaving value)? saving,
    TResult Function(SosError value)? error,
    TResult Function(SosCallNotSupported value)? callNotSupported,
    required TResult orElse(),
  }) {
    if (callNotSupported != null) {
      return callNotSupported(this);
    }
    return orElse();
  }
}

abstract class SosCallNotSupported implements SosState {
  const factory SosCallNotSupported() = _$SosCallNotSupportedImpl;
}
