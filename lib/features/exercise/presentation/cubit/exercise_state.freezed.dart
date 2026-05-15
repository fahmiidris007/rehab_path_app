// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExerciseState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> exercises) loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> exercises)? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> exercises)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExerciseLoading value) loading,
    required TResult Function(ExerciseLoaded value) loaded,
    required TResult Function(ExerciseError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseLoading value)? loading,
    TResult? Function(ExerciseLoaded value)? loaded,
    TResult? Function(ExerciseError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseLoading value)? loading,
    TResult Function(ExerciseLoaded value)? loaded,
    TResult Function(ExerciseError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseStateCopyWith<$Res> {
  factory $ExerciseStateCopyWith(
          ExerciseState value, $Res Function(ExerciseState) then) =
      _$ExerciseStateCopyWithImpl<$Res, ExerciseState>;
}

/// @nodoc
class _$ExerciseStateCopyWithImpl<$Res, $Val extends ExerciseState>
    implements $ExerciseStateCopyWith<$Res> {
  _$ExerciseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ExerciseLoadingImplCopyWith<$Res> {
  factory _$$ExerciseLoadingImplCopyWith(_$ExerciseLoadingImpl value,
          $Res Function(_$ExerciseLoadingImpl) then) =
      __$$ExerciseLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExerciseLoadingImplCopyWithImpl<$Res>
    extends _$ExerciseStateCopyWithImpl<$Res, _$ExerciseLoadingImpl>
    implements _$$ExerciseLoadingImplCopyWith<$Res> {
  __$$ExerciseLoadingImplCopyWithImpl(
      _$ExerciseLoadingImpl _value, $Res Function(_$ExerciseLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ExerciseLoadingImpl implements ExerciseLoading {
  const _$ExerciseLoadingImpl();

  @override
  String toString() {
    return 'ExerciseState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ExerciseLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> exercises) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> exercises)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> exercises)? loaded,
    TResult Function(String message)? error,
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
    required TResult Function(ExerciseLoading value) loading,
    required TResult Function(ExerciseLoaded value) loaded,
    required TResult Function(ExerciseError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseLoading value)? loading,
    TResult? Function(ExerciseLoaded value)? loaded,
    TResult? Function(ExerciseError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseLoading value)? loading,
    TResult Function(ExerciseLoaded value)? loaded,
    TResult Function(ExerciseError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ExerciseLoading implements ExerciseState {
  const factory ExerciseLoading() = _$ExerciseLoadingImpl;
}

/// @nodoc
abstract class _$$ExerciseLoadedImplCopyWith<$Res> {
  factory _$$ExerciseLoadedImplCopyWith(_$ExerciseLoadedImpl value,
          $Res Function(_$ExerciseLoadedImpl) then) =
      __$$ExerciseLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ExerciseEntity> exercises});
}

/// @nodoc
class __$$ExerciseLoadedImplCopyWithImpl<$Res>
    extends _$ExerciseStateCopyWithImpl<$Res, _$ExerciseLoadedImpl>
    implements _$$ExerciseLoadedImplCopyWith<$Res> {
  __$$ExerciseLoadedImplCopyWithImpl(
      _$ExerciseLoadedImpl _value, $Res Function(_$ExerciseLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercises = null,
  }) {
    return _then(_$ExerciseLoadedImpl(
      null == exercises
          ? _value._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<ExerciseEntity>,
    ));
  }
}

/// @nodoc

class _$ExerciseLoadedImpl implements ExerciseLoaded {
  const _$ExerciseLoadedImpl(final List<ExerciseEntity> exercises)
      : _exercises = exercises;

  final List<ExerciseEntity> _exercises;
  @override
  List<ExerciseEntity> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  String toString() {
    return 'ExerciseState.loaded(exercises: $exercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_exercises));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseLoadedImplCopyWith<_$ExerciseLoadedImpl> get copyWith =>
      __$$ExerciseLoadedImplCopyWithImpl<_$ExerciseLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> exercises) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(exercises);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> exercises)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(exercises);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> exercises)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(exercises);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExerciseLoading value) loading,
    required TResult Function(ExerciseLoaded value) loaded,
    required TResult Function(ExerciseError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseLoading value)? loading,
    TResult? Function(ExerciseLoaded value)? loaded,
    TResult? Function(ExerciseError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseLoading value)? loading,
    TResult Function(ExerciseLoaded value)? loaded,
    TResult Function(ExerciseError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ExerciseLoaded implements ExerciseState {
  const factory ExerciseLoaded(final List<ExerciseEntity> exercises) =
      _$ExerciseLoadedImpl;

  List<ExerciseEntity> get exercises;
  @JsonKey(ignore: true)
  _$$ExerciseLoadedImplCopyWith<_$ExerciseLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExerciseErrorImplCopyWith<$Res> {
  factory _$$ExerciseErrorImplCopyWith(
          _$ExerciseErrorImpl value, $Res Function(_$ExerciseErrorImpl) then) =
      __$$ExerciseErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ExerciseErrorImplCopyWithImpl<$Res>
    extends _$ExerciseStateCopyWithImpl<$Res, _$ExerciseErrorImpl>
    implements _$$ExerciseErrorImplCopyWith<$Res> {
  __$$ExerciseErrorImplCopyWithImpl(
      _$ExerciseErrorImpl _value, $Res Function(_$ExerciseErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ExerciseErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExerciseErrorImpl implements ExerciseError {
  const _$ExerciseErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ExerciseState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseErrorImplCopyWith<_$ExerciseErrorImpl> get copyWith =>
      __$$ExerciseErrorImplCopyWithImpl<_$ExerciseErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> exercises) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> exercises)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> exercises)? loaded,
    TResult Function(String message)? error,
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
    required TResult Function(ExerciseLoading value) loading,
    required TResult Function(ExerciseLoaded value) loaded,
    required TResult Function(ExerciseError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseLoading value)? loading,
    TResult? Function(ExerciseLoaded value)? loaded,
    TResult? Function(ExerciseError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseLoading value)? loading,
    TResult Function(ExerciseLoaded value)? loaded,
    TResult Function(ExerciseError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ExerciseError implements ExerciseState {
  const factory ExerciseError(final String message) = _$ExerciseErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ExerciseErrorImplCopyWith<_$ExerciseErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
