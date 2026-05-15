// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlayerState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ExerciseEntity exercise) idle,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        playing,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        paused,
    required TResult Function(ExerciseEntity exercise) selfReport,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ExerciseEntity exercise)? idle,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult? Function(ExerciseEntity exercise)? selfReport,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ExerciseEntity exercise)? idle,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult Function(ExerciseEntity exercise)? selfReport,
    TResult Function()? saving,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerIdle value) idle,
    required TResult Function(PlayerPlaying value) playing,
    required TResult Function(PlayerPaused value) paused,
    required TResult Function(PlayerSelfReport value) selfReport,
    required TResult Function(PlayerSaving value) saving,
    required TResult Function(PlayerSaved value) saved,
    required TResult Function(PlayerError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerIdle value)? idle,
    TResult? Function(PlayerPlaying value)? playing,
    TResult? Function(PlayerPaused value)? paused,
    TResult? Function(PlayerSelfReport value)? selfReport,
    TResult? Function(PlayerSaving value)? saving,
    TResult? Function(PlayerSaved value)? saved,
    TResult? Function(PlayerError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerIdle value)? idle,
    TResult Function(PlayerPlaying value)? playing,
    TResult Function(PlayerPaused value)? paused,
    TResult Function(PlayerSelfReport value)? selfReport,
    TResult Function(PlayerSaving value)? saving,
    TResult Function(PlayerSaved value)? saved,
    TResult Function(PlayerError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStateCopyWith<$Res> {
  factory $PlayerStateCopyWith(
          PlayerState value, $Res Function(PlayerState) then) =
      _$PlayerStateCopyWithImpl<$Res, PlayerState>;
}

/// @nodoc
class _$PlayerStateCopyWithImpl<$Res, $Val extends PlayerState>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$PlayerIdleImplCopyWith<$Res> {
  factory _$$PlayerIdleImplCopyWith(
          _$PlayerIdleImpl value, $Res Function(_$PlayerIdleImpl) then) =
      __$$PlayerIdleImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ExerciseEntity exercise});

  $ExerciseEntityCopyWith<$Res> get exercise;
}

/// @nodoc
class __$$PlayerIdleImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerIdleImpl>
    implements _$$PlayerIdleImplCopyWith<$Res> {
  __$$PlayerIdleImplCopyWithImpl(
      _$PlayerIdleImpl _value, $Res Function(_$PlayerIdleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercise = null,
  }) {
    return _then(_$PlayerIdleImpl(
      null == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as ExerciseEntity,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ExerciseEntityCopyWith<$Res> get exercise {
    return $ExerciseEntityCopyWith<$Res>(_value.exercise, (value) {
      return _then(_value.copyWith(exercise: value));
    });
  }
}

/// @nodoc

class _$PlayerIdleImpl implements PlayerIdle {
  const _$PlayerIdleImpl(this.exercise);

  @override
  final ExerciseEntity exercise;

  @override
  String toString() {
    return 'PlayerState.idle(exercise: $exercise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerIdleImpl &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerIdleImplCopyWith<_$PlayerIdleImpl> get copyWith =>
      __$$PlayerIdleImplCopyWithImpl<_$PlayerIdleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ExerciseEntity exercise) idle,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        playing,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        paused,
    required TResult Function(ExerciseEntity exercise) selfReport,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return idle(exercise);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ExerciseEntity exercise)? idle,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult? Function(ExerciseEntity exercise)? selfReport,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return idle?.call(exercise);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ExerciseEntity exercise)? idle,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult Function(ExerciseEntity exercise)? selfReport,
    TResult Function()? saving,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(exercise);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerIdle value) idle,
    required TResult Function(PlayerPlaying value) playing,
    required TResult Function(PlayerPaused value) paused,
    required TResult Function(PlayerSelfReport value) selfReport,
    required TResult Function(PlayerSaving value) saving,
    required TResult Function(PlayerSaved value) saved,
    required TResult Function(PlayerError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerIdle value)? idle,
    TResult? Function(PlayerPlaying value)? playing,
    TResult? Function(PlayerPaused value)? paused,
    TResult? Function(PlayerSelfReport value)? selfReport,
    TResult? Function(PlayerSaving value)? saving,
    TResult? Function(PlayerSaved value)? saved,
    TResult? Function(PlayerError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerIdle value)? idle,
    TResult Function(PlayerPlaying value)? playing,
    TResult Function(PlayerPaused value)? paused,
    TResult Function(PlayerSelfReport value)? selfReport,
    TResult Function(PlayerSaving value)? saving,
    TResult Function(PlayerSaved value)? saved,
    TResult Function(PlayerError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class PlayerIdle implements PlayerState {
  const factory PlayerIdle(final ExerciseEntity exercise) = _$PlayerIdleImpl;

  ExerciseEntity get exercise;
  @JsonKey(ignore: true)
  _$$PlayerIdleImplCopyWith<_$PlayerIdleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlayerPlayingImplCopyWith<$Res> {
  factory _$$PlayerPlayingImplCopyWith(
          _$PlayerPlayingImpl value, $Res Function(_$PlayerPlayingImpl) then) =
      __$$PlayerPlayingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ExerciseEntity exercise, int remainingSeconds});

  $ExerciseEntityCopyWith<$Res> get exercise;
}

/// @nodoc
class __$$PlayerPlayingImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerPlayingImpl>
    implements _$$PlayerPlayingImplCopyWith<$Res> {
  __$$PlayerPlayingImplCopyWithImpl(
      _$PlayerPlayingImpl _value, $Res Function(_$PlayerPlayingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercise = null,
    Object? remainingSeconds = null,
  }) {
    return _then(_$PlayerPlayingImpl(
      exercise: null == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as ExerciseEntity,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ExerciseEntityCopyWith<$Res> get exercise {
    return $ExerciseEntityCopyWith<$Res>(_value.exercise, (value) {
      return _then(_value.copyWith(exercise: value));
    });
  }
}

/// @nodoc

class _$PlayerPlayingImpl implements PlayerPlaying {
  const _$PlayerPlayingImpl(
      {required this.exercise, required this.remainingSeconds});

  @override
  final ExerciseEntity exercise;
  @override
  final int remainingSeconds;

  @override
  String toString() {
    return 'PlayerState.playing(exercise: $exercise, remainingSeconds: $remainingSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerPlayingImpl &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise, remainingSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerPlayingImplCopyWith<_$PlayerPlayingImpl> get copyWith =>
      __$$PlayerPlayingImplCopyWithImpl<_$PlayerPlayingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ExerciseEntity exercise) idle,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        playing,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        paused,
    required TResult Function(ExerciseEntity exercise) selfReport,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return playing(exercise, remainingSeconds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ExerciseEntity exercise)? idle,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult? Function(ExerciseEntity exercise)? selfReport,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return playing?.call(exercise, remainingSeconds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ExerciseEntity exercise)? idle,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult Function(ExerciseEntity exercise)? selfReport,
    TResult Function()? saving,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (playing != null) {
      return playing(exercise, remainingSeconds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerIdle value) idle,
    required TResult Function(PlayerPlaying value) playing,
    required TResult Function(PlayerPaused value) paused,
    required TResult Function(PlayerSelfReport value) selfReport,
    required TResult Function(PlayerSaving value) saving,
    required TResult Function(PlayerSaved value) saved,
    required TResult Function(PlayerError value) error,
  }) {
    return playing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerIdle value)? idle,
    TResult? Function(PlayerPlaying value)? playing,
    TResult? Function(PlayerPaused value)? paused,
    TResult? Function(PlayerSelfReport value)? selfReport,
    TResult? Function(PlayerSaving value)? saving,
    TResult? Function(PlayerSaved value)? saved,
    TResult? Function(PlayerError value)? error,
  }) {
    return playing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerIdle value)? idle,
    TResult Function(PlayerPlaying value)? playing,
    TResult Function(PlayerPaused value)? paused,
    TResult Function(PlayerSelfReport value)? selfReport,
    TResult Function(PlayerSaving value)? saving,
    TResult Function(PlayerSaved value)? saved,
    TResult Function(PlayerError value)? error,
    required TResult orElse(),
  }) {
    if (playing != null) {
      return playing(this);
    }
    return orElse();
  }
}

abstract class PlayerPlaying implements PlayerState {
  const factory PlayerPlaying(
      {required final ExerciseEntity exercise,
      required final int remainingSeconds}) = _$PlayerPlayingImpl;

  ExerciseEntity get exercise;
  int get remainingSeconds;
  @JsonKey(ignore: true)
  _$$PlayerPlayingImplCopyWith<_$PlayerPlayingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlayerPausedImplCopyWith<$Res> {
  factory _$$PlayerPausedImplCopyWith(
          _$PlayerPausedImpl value, $Res Function(_$PlayerPausedImpl) then) =
      __$$PlayerPausedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ExerciseEntity exercise, int remainingSeconds});

  $ExerciseEntityCopyWith<$Res> get exercise;
}

/// @nodoc
class __$$PlayerPausedImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerPausedImpl>
    implements _$$PlayerPausedImplCopyWith<$Res> {
  __$$PlayerPausedImplCopyWithImpl(
      _$PlayerPausedImpl _value, $Res Function(_$PlayerPausedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercise = null,
    Object? remainingSeconds = null,
  }) {
    return _then(_$PlayerPausedImpl(
      exercise: null == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as ExerciseEntity,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ExerciseEntityCopyWith<$Res> get exercise {
    return $ExerciseEntityCopyWith<$Res>(_value.exercise, (value) {
      return _then(_value.copyWith(exercise: value));
    });
  }
}

/// @nodoc

class _$PlayerPausedImpl implements PlayerPaused {
  const _$PlayerPausedImpl(
      {required this.exercise, required this.remainingSeconds});

  @override
  final ExerciseEntity exercise;
  @override
  final int remainingSeconds;

  @override
  String toString() {
    return 'PlayerState.paused(exercise: $exercise, remainingSeconds: $remainingSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerPausedImpl &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise, remainingSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerPausedImplCopyWith<_$PlayerPausedImpl> get copyWith =>
      __$$PlayerPausedImplCopyWithImpl<_$PlayerPausedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ExerciseEntity exercise) idle,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        playing,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        paused,
    required TResult Function(ExerciseEntity exercise) selfReport,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return paused(exercise, remainingSeconds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ExerciseEntity exercise)? idle,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult? Function(ExerciseEntity exercise)? selfReport,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return paused?.call(exercise, remainingSeconds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ExerciseEntity exercise)? idle,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult Function(ExerciseEntity exercise)? selfReport,
    TResult Function()? saving,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(exercise, remainingSeconds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerIdle value) idle,
    required TResult Function(PlayerPlaying value) playing,
    required TResult Function(PlayerPaused value) paused,
    required TResult Function(PlayerSelfReport value) selfReport,
    required TResult Function(PlayerSaving value) saving,
    required TResult Function(PlayerSaved value) saved,
    required TResult Function(PlayerError value) error,
  }) {
    return paused(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerIdle value)? idle,
    TResult? Function(PlayerPlaying value)? playing,
    TResult? Function(PlayerPaused value)? paused,
    TResult? Function(PlayerSelfReport value)? selfReport,
    TResult? Function(PlayerSaving value)? saving,
    TResult? Function(PlayerSaved value)? saved,
    TResult? Function(PlayerError value)? error,
  }) {
    return paused?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerIdle value)? idle,
    TResult Function(PlayerPlaying value)? playing,
    TResult Function(PlayerPaused value)? paused,
    TResult Function(PlayerSelfReport value)? selfReport,
    TResult Function(PlayerSaving value)? saving,
    TResult Function(PlayerSaved value)? saved,
    TResult Function(PlayerError value)? error,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(this);
    }
    return orElse();
  }
}

abstract class PlayerPaused implements PlayerState {
  const factory PlayerPaused(
      {required final ExerciseEntity exercise,
      required final int remainingSeconds}) = _$PlayerPausedImpl;

  ExerciseEntity get exercise;
  int get remainingSeconds;
  @JsonKey(ignore: true)
  _$$PlayerPausedImplCopyWith<_$PlayerPausedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlayerSelfReportImplCopyWith<$Res> {
  factory _$$PlayerSelfReportImplCopyWith(_$PlayerSelfReportImpl value,
          $Res Function(_$PlayerSelfReportImpl) then) =
      __$$PlayerSelfReportImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ExerciseEntity exercise});

  $ExerciseEntityCopyWith<$Res> get exercise;
}

/// @nodoc
class __$$PlayerSelfReportImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerSelfReportImpl>
    implements _$$PlayerSelfReportImplCopyWith<$Res> {
  __$$PlayerSelfReportImplCopyWithImpl(_$PlayerSelfReportImpl _value,
      $Res Function(_$PlayerSelfReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercise = null,
  }) {
    return _then(_$PlayerSelfReportImpl(
      null == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as ExerciseEntity,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ExerciseEntityCopyWith<$Res> get exercise {
    return $ExerciseEntityCopyWith<$Res>(_value.exercise, (value) {
      return _then(_value.copyWith(exercise: value));
    });
  }
}

/// @nodoc

class _$PlayerSelfReportImpl implements PlayerSelfReport {
  const _$PlayerSelfReportImpl(this.exercise);

  @override
  final ExerciseEntity exercise;

  @override
  String toString() {
    return 'PlayerState.selfReport(exercise: $exercise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerSelfReportImpl &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerSelfReportImplCopyWith<_$PlayerSelfReportImpl> get copyWith =>
      __$$PlayerSelfReportImplCopyWithImpl<_$PlayerSelfReportImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ExerciseEntity exercise) idle,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        playing,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        paused,
    required TResult Function(ExerciseEntity exercise) selfReport,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return selfReport(exercise);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ExerciseEntity exercise)? idle,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult? Function(ExerciseEntity exercise)? selfReport,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return selfReport?.call(exercise);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ExerciseEntity exercise)? idle,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult Function(ExerciseEntity exercise)? selfReport,
    TResult Function()? saving,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (selfReport != null) {
      return selfReport(exercise);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerIdle value) idle,
    required TResult Function(PlayerPlaying value) playing,
    required TResult Function(PlayerPaused value) paused,
    required TResult Function(PlayerSelfReport value) selfReport,
    required TResult Function(PlayerSaving value) saving,
    required TResult Function(PlayerSaved value) saved,
    required TResult Function(PlayerError value) error,
  }) {
    return selfReport(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerIdle value)? idle,
    TResult? Function(PlayerPlaying value)? playing,
    TResult? Function(PlayerPaused value)? paused,
    TResult? Function(PlayerSelfReport value)? selfReport,
    TResult? Function(PlayerSaving value)? saving,
    TResult? Function(PlayerSaved value)? saved,
    TResult? Function(PlayerError value)? error,
  }) {
    return selfReport?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerIdle value)? idle,
    TResult Function(PlayerPlaying value)? playing,
    TResult Function(PlayerPaused value)? paused,
    TResult Function(PlayerSelfReport value)? selfReport,
    TResult Function(PlayerSaving value)? saving,
    TResult Function(PlayerSaved value)? saved,
    TResult Function(PlayerError value)? error,
    required TResult orElse(),
  }) {
    if (selfReport != null) {
      return selfReport(this);
    }
    return orElse();
  }
}

abstract class PlayerSelfReport implements PlayerState {
  const factory PlayerSelfReport(final ExerciseEntity exercise) =
      _$PlayerSelfReportImpl;

  ExerciseEntity get exercise;
  @JsonKey(ignore: true)
  _$$PlayerSelfReportImplCopyWith<_$PlayerSelfReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlayerSavingImplCopyWith<$Res> {
  factory _$$PlayerSavingImplCopyWith(
          _$PlayerSavingImpl value, $Res Function(_$PlayerSavingImpl) then) =
      __$$PlayerSavingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PlayerSavingImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerSavingImpl>
    implements _$$PlayerSavingImplCopyWith<$Res> {
  __$$PlayerSavingImplCopyWithImpl(
      _$PlayerSavingImpl _value, $Res Function(_$PlayerSavingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PlayerSavingImpl implements PlayerSaving {
  const _$PlayerSavingImpl();

  @override
  String toString() {
    return 'PlayerState.saving()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PlayerSavingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ExerciseEntity exercise) idle,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        playing,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        paused,
    required TResult Function(ExerciseEntity exercise) selfReport,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return saving();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ExerciseEntity exercise)? idle,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult? Function(ExerciseEntity exercise)? selfReport,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return saving?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ExerciseEntity exercise)? idle,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult Function(ExerciseEntity exercise)? selfReport,
    TResult Function()? saving,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerIdle value) idle,
    required TResult Function(PlayerPlaying value) playing,
    required TResult Function(PlayerPaused value) paused,
    required TResult Function(PlayerSelfReport value) selfReport,
    required TResult Function(PlayerSaving value) saving,
    required TResult Function(PlayerSaved value) saved,
    required TResult Function(PlayerError value) error,
  }) {
    return saving(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerIdle value)? idle,
    TResult? Function(PlayerPlaying value)? playing,
    TResult? Function(PlayerPaused value)? paused,
    TResult? Function(PlayerSelfReport value)? selfReport,
    TResult? Function(PlayerSaving value)? saving,
    TResult? Function(PlayerSaved value)? saved,
    TResult? Function(PlayerError value)? error,
  }) {
    return saving?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerIdle value)? idle,
    TResult Function(PlayerPlaying value)? playing,
    TResult Function(PlayerPaused value)? paused,
    TResult Function(PlayerSelfReport value)? selfReport,
    TResult Function(PlayerSaving value)? saving,
    TResult Function(PlayerSaved value)? saved,
    TResult Function(PlayerError value)? error,
    required TResult orElse(),
  }) {
    if (saving != null) {
      return saving(this);
    }
    return orElse();
  }
}

abstract class PlayerSaving implements PlayerState {
  const factory PlayerSaving() = _$PlayerSavingImpl;
}

/// @nodoc
abstract class _$$PlayerSavedImplCopyWith<$Res> {
  factory _$$PlayerSavedImplCopyWith(
          _$PlayerSavedImpl value, $Res Function(_$PlayerSavedImpl) then) =
      __$$PlayerSavedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PlayerSavedImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerSavedImpl>
    implements _$$PlayerSavedImplCopyWith<$Res> {
  __$$PlayerSavedImplCopyWithImpl(
      _$PlayerSavedImpl _value, $Res Function(_$PlayerSavedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PlayerSavedImpl implements PlayerSaved {
  const _$PlayerSavedImpl();

  @override
  String toString() {
    return 'PlayerState.saved()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PlayerSavedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ExerciseEntity exercise) idle,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        playing,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        paused,
    required TResult Function(ExerciseEntity exercise) selfReport,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return saved();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ExerciseEntity exercise)? idle,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult? Function(ExerciseEntity exercise)? selfReport,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return saved?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ExerciseEntity exercise)? idle,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult Function(ExerciseEntity exercise)? selfReport,
    TResult Function()? saving,
    TResult Function()? saved,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerIdle value) idle,
    required TResult Function(PlayerPlaying value) playing,
    required TResult Function(PlayerPaused value) paused,
    required TResult Function(PlayerSelfReport value) selfReport,
    required TResult Function(PlayerSaving value) saving,
    required TResult Function(PlayerSaved value) saved,
    required TResult Function(PlayerError value) error,
  }) {
    return saved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerIdle value)? idle,
    TResult? Function(PlayerPlaying value)? playing,
    TResult? Function(PlayerPaused value)? paused,
    TResult? Function(PlayerSelfReport value)? selfReport,
    TResult? Function(PlayerSaving value)? saving,
    TResult? Function(PlayerSaved value)? saved,
    TResult? Function(PlayerError value)? error,
  }) {
    return saved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerIdle value)? idle,
    TResult Function(PlayerPlaying value)? playing,
    TResult Function(PlayerPaused value)? paused,
    TResult Function(PlayerSelfReport value)? selfReport,
    TResult Function(PlayerSaving value)? saving,
    TResult Function(PlayerSaved value)? saved,
    TResult Function(PlayerError value)? error,
    required TResult orElse(),
  }) {
    if (saved != null) {
      return saved(this);
    }
    return orElse();
  }
}

abstract class PlayerSaved implements PlayerState {
  const factory PlayerSaved() = _$PlayerSavedImpl;
}

/// @nodoc
abstract class _$$PlayerErrorImplCopyWith<$Res> {
  factory _$$PlayerErrorImplCopyWith(
          _$PlayerErrorImpl value, $Res Function(_$PlayerErrorImpl) then) =
      __$$PlayerErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PlayerErrorImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerErrorImpl>
    implements _$$PlayerErrorImplCopyWith<$Res> {
  __$$PlayerErrorImplCopyWithImpl(
      _$PlayerErrorImpl _value, $Res Function(_$PlayerErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PlayerErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PlayerErrorImpl implements PlayerError {
  const _$PlayerErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PlayerState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerErrorImplCopyWith<_$PlayerErrorImpl> get copyWith =>
      __$$PlayerErrorImplCopyWithImpl<_$PlayerErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ExerciseEntity exercise) idle,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        playing,
    required TResult Function(ExerciseEntity exercise, int remainingSeconds)
        paused,
    required TResult Function(ExerciseEntity exercise) selfReport,
    required TResult Function() saving,
    required TResult Function() saved,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ExerciseEntity exercise)? idle,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult? Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult? Function(ExerciseEntity exercise)? selfReport,
    TResult? Function()? saving,
    TResult? Function()? saved,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ExerciseEntity exercise)? idle,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? playing,
    TResult Function(ExerciseEntity exercise, int remainingSeconds)? paused,
    TResult Function(ExerciseEntity exercise)? selfReport,
    TResult Function()? saving,
    TResult Function()? saved,
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
    required TResult Function(PlayerIdle value) idle,
    required TResult Function(PlayerPlaying value) playing,
    required TResult Function(PlayerPaused value) paused,
    required TResult Function(PlayerSelfReport value) selfReport,
    required TResult Function(PlayerSaving value) saving,
    required TResult Function(PlayerSaved value) saved,
    required TResult Function(PlayerError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerIdle value)? idle,
    TResult? Function(PlayerPlaying value)? playing,
    TResult? Function(PlayerPaused value)? paused,
    TResult? Function(PlayerSelfReport value)? selfReport,
    TResult? Function(PlayerSaving value)? saving,
    TResult? Function(PlayerSaved value)? saved,
    TResult? Function(PlayerError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerIdle value)? idle,
    TResult Function(PlayerPlaying value)? playing,
    TResult Function(PlayerPaused value)? paused,
    TResult Function(PlayerSelfReport value)? selfReport,
    TResult Function(PlayerSaving value)? saving,
    TResult Function(PlayerSaved value)? saved,
    TResult Function(PlayerError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PlayerError implements PlayerState {
  const factory PlayerError(final String message) = _$PlayerErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$PlayerErrorImplCopyWith<_$PlayerErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
