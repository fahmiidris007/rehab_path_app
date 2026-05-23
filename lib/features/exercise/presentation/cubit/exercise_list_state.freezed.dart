// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExerciseListState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> todaySchedule) todayMode,
    required TResult Function(List<ExerciseEntity> allExercises) allMode,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult? Function(List<ExerciseEntity> allExercises)? allMode,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult Function(List<ExerciseEntity> allExercises)? allMode,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExerciseListLoading value) loading,
    required TResult Function(ExerciseListTodayMode value) todayMode,
    required TResult Function(ExerciseListAllMode value) allMode,
    required TResult Function(ExerciseListError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseListLoading value)? loading,
    TResult? Function(ExerciseListTodayMode value)? todayMode,
    TResult? Function(ExerciseListAllMode value)? allMode,
    TResult? Function(ExerciseListError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseListLoading value)? loading,
    TResult Function(ExerciseListTodayMode value)? todayMode,
    TResult Function(ExerciseListAllMode value)? allMode,
    TResult Function(ExerciseListError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseListStateCopyWith<$Res> {
  factory $ExerciseListStateCopyWith(
          ExerciseListState value, $Res Function(ExerciseListState) then) =
      _$ExerciseListStateCopyWithImpl<$Res, ExerciseListState>;
}

/// @nodoc
class _$ExerciseListStateCopyWithImpl<$Res, $Val extends ExerciseListState>
    implements $ExerciseListStateCopyWith<$Res> {
  _$ExerciseListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ExerciseListLoadingImplCopyWith<$Res> {
  factory _$$ExerciseListLoadingImplCopyWith(_$ExerciseListLoadingImpl value,
          $Res Function(_$ExerciseListLoadingImpl) then) =
      __$$ExerciseListLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExerciseListLoadingImplCopyWithImpl<$Res>
    extends _$ExerciseListStateCopyWithImpl<$Res, _$ExerciseListLoadingImpl>
    implements _$$ExerciseListLoadingImplCopyWith<$Res> {
  __$$ExerciseListLoadingImplCopyWithImpl(_$ExerciseListLoadingImpl _value,
      $Res Function(_$ExerciseListLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ExerciseListLoadingImpl implements ExerciseListLoading {
  const _$ExerciseListLoadingImpl();

  @override
  String toString() {
    return 'ExerciseListState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseListLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> todaySchedule) todayMode,
    required TResult Function(List<ExerciseEntity> allExercises) allMode,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult? Function(List<ExerciseEntity> allExercises)? allMode,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult Function(List<ExerciseEntity> allExercises)? allMode,
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
    required TResult Function(ExerciseListLoading value) loading,
    required TResult Function(ExerciseListTodayMode value) todayMode,
    required TResult Function(ExerciseListAllMode value) allMode,
    required TResult Function(ExerciseListError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseListLoading value)? loading,
    TResult? Function(ExerciseListTodayMode value)? todayMode,
    TResult? Function(ExerciseListAllMode value)? allMode,
    TResult? Function(ExerciseListError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseListLoading value)? loading,
    TResult Function(ExerciseListTodayMode value)? todayMode,
    TResult Function(ExerciseListAllMode value)? allMode,
    TResult Function(ExerciseListError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ExerciseListLoading implements ExerciseListState {
  const factory ExerciseListLoading() = _$ExerciseListLoadingImpl;
}

/// @nodoc
abstract class _$$ExerciseListTodayModeImplCopyWith<$Res> {
  factory _$$ExerciseListTodayModeImplCopyWith(
          _$ExerciseListTodayModeImpl value,
          $Res Function(_$ExerciseListTodayModeImpl) then) =
      __$$ExerciseListTodayModeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ExerciseEntity> todaySchedule});
}

/// @nodoc
class __$$ExerciseListTodayModeImplCopyWithImpl<$Res>
    extends _$ExerciseListStateCopyWithImpl<$Res, _$ExerciseListTodayModeImpl>
    implements _$$ExerciseListTodayModeImplCopyWith<$Res> {
  __$$ExerciseListTodayModeImplCopyWithImpl(_$ExerciseListTodayModeImpl _value,
      $Res Function(_$ExerciseListTodayModeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todaySchedule = null,
  }) {
    return _then(_$ExerciseListTodayModeImpl(
      todaySchedule: null == todaySchedule
          ? _value._todaySchedule
          : todaySchedule // ignore: cast_nullable_to_non_nullable
              as List<ExerciseEntity>,
    ));
  }
}

/// @nodoc

class _$ExerciseListTodayModeImpl implements ExerciseListTodayMode {
  const _$ExerciseListTodayModeImpl(
      {required final List<ExerciseEntity> todaySchedule})
      : _todaySchedule = todaySchedule;

  final List<ExerciseEntity> _todaySchedule;
  @override
  List<ExerciseEntity> get todaySchedule {
    if (_todaySchedule is EqualUnmodifiableListView) return _todaySchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todaySchedule);
  }

  @override
  String toString() {
    return 'ExerciseListState.todayMode(todaySchedule: $todaySchedule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseListTodayModeImpl &&
            const DeepCollectionEquality()
                .equals(other._todaySchedule, _todaySchedule));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_todaySchedule));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseListTodayModeImplCopyWith<_$ExerciseListTodayModeImpl>
      get copyWith => __$$ExerciseListTodayModeImplCopyWithImpl<
          _$ExerciseListTodayModeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> todaySchedule) todayMode,
    required TResult Function(List<ExerciseEntity> allExercises) allMode,
    required TResult Function(String message) error,
  }) {
    return todayMode(todaySchedule);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult? Function(List<ExerciseEntity> allExercises)? allMode,
    TResult? Function(String message)? error,
  }) {
    return todayMode?.call(todaySchedule);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult Function(List<ExerciseEntity> allExercises)? allMode,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (todayMode != null) {
      return todayMode(todaySchedule);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExerciseListLoading value) loading,
    required TResult Function(ExerciseListTodayMode value) todayMode,
    required TResult Function(ExerciseListAllMode value) allMode,
    required TResult Function(ExerciseListError value) error,
  }) {
    return todayMode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseListLoading value)? loading,
    TResult? Function(ExerciseListTodayMode value)? todayMode,
    TResult? Function(ExerciseListAllMode value)? allMode,
    TResult? Function(ExerciseListError value)? error,
  }) {
    return todayMode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseListLoading value)? loading,
    TResult Function(ExerciseListTodayMode value)? todayMode,
    TResult Function(ExerciseListAllMode value)? allMode,
    TResult Function(ExerciseListError value)? error,
    required TResult orElse(),
  }) {
    if (todayMode != null) {
      return todayMode(this);
    }
    return orElse();
  }
}

abstract class ExerciseListTodayMode implements ExerciseListState {
  const factory ExerciseListTodayMode(
          {required final List<ExerciseEntity> todaySchedule}) =
      _$ExerciseListTodayModeImpl;

  List<ExerciseEntity> get todaySchedule;
  @JsonKey(ignore: true)
  _$$ExerciseListTodayModeImplCopyWith<_$ExerciseListTodayModeImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExerciseListAllModeImplCopyWith<$Res> {
  factory _$$ExerciseListAllModeImplCopyWith(_$ExerciseListAllModeImpl value,
          $Res Function(_$ExerciseListAllModeImpl) then) =
      __$$ExerciseListAllModeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ExerciseEntity> allExercises});
}

/// @nodoc
class __$$ExerciseListAllModeImplCopyWithImpl<$Res>
    extends _$ExerciseListStateCopyWithImpl<$Res, _$ExerciseListAllModeImpl>
    implements _$$ExerciseListAllModeImplCopyWith<$Res> {
  __$$ExerciseListAllModeImplCopyWithImpl(_$ExerciseListAllModeImpl _value,
      $Res Function(_$ExerciseListAllModeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allExercises = null,
  }) {
    return _then(_$ExerciseListAllModeImpl(
      allExercises: null == allExercises
          ? _value._allExercises
          : allExercises // ignore: cast_nullable_to_non_nullable
              as List<ExerciseEntity>,
    ));
  }
}

/// @nodoc

class _$ExerciseListAllModeImpl implements ExerciseListAllMode {
  const _$ExerciseListAllModeImpl(
      {required final List<ExerciseEntity> allExercises})
      : _allExercises = allExercises;

  final List<ExerciseEntity> _allExercises;
  @override
  List<ExerciseEntity> get allExercises {
    if (_allExercises is EqualUnmodifiableListView) return _allExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allExercises);
  }

  @override
  String toString() {
    return 'ExerciseListState.allMode(allExercises: $allExercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseListAllModeImpl &&
            const DeepCollectionEquality()
                .equals(other._allExercises, _allExercises));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_allExercises));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseListAllModeImplCopyWith<_$ExerciseListAllModeImpl> get copyWith =>
      __$$ExerciseListAllModeImplCopyWithImpl<_$ExerciseListAllModeImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> todaySchedule) todayMode,
    required TResult Function(List<ExerciseEntity> allExercises) allMode,
    required TResult Function(String message) error,
  }) {
    return allMode(allExercises);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult? Function(List<ExerciseEntity> allExercises)? allMode,
    TResult? Function(String message)? error,
  }) {
    return allMode?.call(allExercises);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult Function(List<ExerciseEntity> allExercises)? allMode,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (allMode != null) {
      return allMode(allExercises);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExerciseListLoading value) loading,
    required TResult Function(ExerciseListTodayMode value) todayMode,
    required TResult Function(ExerciseListAllMode value) allMode,
    required TResult Function(ExerciseListError value) error,
  }) {
    return allMode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseListLoading value)? loading,
    TResult? Function(ExerciseListTodayMode value)? todayMode,
    TResult? Function(ExerciseListAllMode value)? allMode,
    TResult? Function(ExerciseListError value)? error,
  }) {
    return allMode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseListLoading value)? loading,
    TResult Function(ExerciseListTodayMode value)? todayMode,
    TResult Function(ExerciseListAllMode value)? allMode,
    TResult Function(ExerciseListError value)? error,
    required TResult orElse(),
  }) {
    if (allMode != null) {
      return allMode(this);
    }
    return orElse();
  }
}

abstract class ExerciseListAllMode implements ExerciseListState {
  const factory ExerciseListAllMode(
          {required final List<ExerciseEntity> allExercises}) =
      _$ExerciseListAllModeImpl;

  List<ExerciseEntity> get allExercises;
  @JsonKey(ignore: true)
  _$$ExerciseListAllModeImplCopyWith<_$ExerciseListAllModeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExerciseListErrorImplCopyWith<$Res> {
  factory _$$ExerciseListErrorImplCopyWith(_$ExerciseListErrorImpl value,
          $Res Function(_$ExerciseListErrorImpl) then) =
      __$$ExerciseListErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ExerciseListErrorImplCopyWithImpl<$Res>
    extends _$ExerciseListStateCopyWithImpl<$Res, _$ExerciseListErrorImpl>
    implements _$$ExerciseListErrorImplCopyWith<$Res> {
  __$$ExerciseListErrorImplCopyWithImpl(_$ExerciseListErrorImpl _value,
      $Res Function(_$ExerciseListErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ExerciseListErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExerciseListErrorImpl implements ExerciseListError {
  const _$ExerciseListErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ExerciseListState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseListErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseListErrorImplCopyWith<_$ExerciseListErrorImpl> get copyWith =>
      __$$ExerciseListErrorImplCopyWithImpl<_$ExerciseListErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<ExerciseEntity> todaySchedule) todayMode,
    required TResult Function(List<ExerciseEntity> allExercises) allMode,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult? Function(List<ExerciseEntity> allExercises)? allMode,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<ExerciseEntity> todaySchedule)? todayMode,
    TResult Function(List<ExerciseEntity> allExercises)? allMode,
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
    required TResult Function(ExerciseListLoading value) loading,
    required TResult Function(ExerciseListTodayMode value) todayMode,
    required TResult Function(ExerciseListAllMode value) allMode,
    required TResult Function(ExerciseListError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExerciseListLoading value)? loading,
    TResult? Function(ExerciseListTodayMode value)? todayMode,
    TResult? Function(ExerciseListAllMode value)? allMode,
    TResult? Function(ExerciseListError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExerciseListLoading value)? loading,
    TResult Function(ExerciseListTodayMode value)? todayMode,
    TResult Function(ExerciseListAllMode value)? allMode,
    TResult Function(ExerciseListError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ExerciseListError implements ExerciseListState {
  const factory ExerciseListError(final String message) =
      _$ExerciseListErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ExerciseListErrorImplCopyWith<_$ExerciseListErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
