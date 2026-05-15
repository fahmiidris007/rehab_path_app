// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeData {
  UserEntity get user => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  List<ExerciseEntity> get todaySchedule => throw _privateConstructorUsedError;
  int get completedToday => throw _privateConstructorUsedError;
  List<ExerciseEntity> get recommendedExercises =>
      throw _privateConstructorUsedError;
  MotivationalMessageEntity get motivationalMessage =>
      throw _privateConstructorUsedError;
  List<DateTime> get completedDaysThisWeek =>
      throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeDataCopyWith<HomeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDataCopyWith<$Res> {
  factory $HomeDataCopyWith(HomeData value, $Res Function(HomeData) then) =
      _$HomeDataCopyWithImpl<$Res, HomeData>;
  @useResult
  $Res call(
      {UserEntity user,
      int streakDays,
      List<ExerciseEntity> todaySchedule,
      int completedToday,
      List<ExerciseEntity> recommendedExercises,
      MotivationalMessageEntity motivationalMessage,
      List<DateTime> completedDaysThisWeek,
      int totalMinutes,
      int totalSessions});

  $UserEntityCopyWith<$Res> get user;
  $MotivationalMessageEntityCopyWith<$Res> get motivationalMessage;
}

/// @nodoc
class _$HomeDataCopyWithImpl<$Res, $Val extends HomeData>
    implements $HomeDataCopyWith<$Res> {
  _$HomeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? streakDays = null,
    Object? todaySchedule = null,
    Object? completedToday = null,
    Object? recommendedExercises = null,
    Object? motivationalMessage = null,
    Object? completedDaysThisWeek = null,
    Object? totalMinutes = null,
    Object? totalSessions = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      todaySchedule: null == todaySchedule
          ? _value.todaySchedule
          : todaySchedule // ignore: cast_nullable_to_non_nullable
              as List<ExerciseEntity>,
      completedToday: null == completedToday
          ? _value.completedToday
          : completedToday // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedExercises: null == recommendedExercises
          ? _value.recommendedExercises
          : recommendedExercises // ignore: cast_nullable_to_non_nullable
              as List<ExerciseEntity>,
      motivationalMessage: null == motivationalMessage
          ? _value.motivationalMessage
          : motivationalMessage // ignore: cast_nullable_to_non_nullable
              as MotivationalMessageEntity,
      completedDaysThisWeek: null == completedDaysThisWeek
          ? _value.completedDaysThisWeek
          : completedDaysThisWeek // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res> get user {
    return $UserEntityCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MotivationalMessageEntityCopyWith<$Res> get motivationalMessage {
    return $MotivationalMessageEntityCopyWith<$Res>(_value.motivationalMessage,
        (value) {
      return _then(_value.copyWith(motivationalMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeDataImplCopyWith<$Res>
    implements $HomeDataCopyWith<$Res> {
  factory _$$HomeDataImplCopyWith(
          _$HomeDataImpl value, $Res Function(_$HomeDataImpl) then) =
      __$$HomeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserEntity user,
      int streakDays,
      List<ExerciseEntity> todaySchedule,
      int completedToday,
      List<ExerciseEntity> recommendedExercises,
      MotivationalMessageEntity motivationalMessage,
      List<DateTime> completedDaysThisWeek,
      int totalMinutes,
      int totalSessions});

  @override
  $UserEntityCopyWith<$Res> get user;
  @override
  $MotivationalMessageEntityCopyWith<$Res> get motivationalMessage;
}

/// @nodoc
class __$$HomeDataImplCopyWithImpl<$Res>
    extends _$HomeDataCopyWithImpl<$Res, _$HomeDataImpl>
    implements _$$HomeDataImplCopyWith<$Res> {
  __$$HomeDataImplCopyWithImpl(
      _$HomeDataImpl _value, $Res Function(_$HomeDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? streakDays = null,
    Object? todaySchedule = null,
    Object? completedToday = null,
    Object? recommendedExercises = null,
    Object? motivationalMessage = null,
    Object? completedDaysThisWeek = null,
    Object? totalMinutes = null,
    Object? totalSessions = null,
  }) {
    return _then(_$HomeDataImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      todaySchedule: null == todaySchedule
          ? _value._todaySchedule
          : todaySchedule // ignore: cast_nullable_to_non_nullable
              as List<ExerciseEntity>,
      completedToday: null == completedToday
          ? _value.completedToday
          : completedToday // ignore: cast_nullable_to_non_nullable
              as int,
      recommendedExercises: null == recommendedExercises
          ? _value._recommendedExercises
          : recommendedExercises // ignore: cast_nullable_to_non_nullable
              as List<ExerciseEntity>,
      motivationalMessage: null == motivationalMessage
          ? _value.motivationalMessage
          : motivationalMessage // ignore: cast_nullable_to_non_nullable
              as MotivationalMessageEntity,
      completedDaysThisWeek: null == completedDaysThisWeek
          ? _value._completedDaysThisWeek
          : completedDaysThisWeek // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HomeDataImpl implements _HomeData {
  const _$HomeDataImpl(
      {required this.user,
      required this.streakDays,
      required final List<ExerciseEntity> todaySchedule,
      required this.completedToday,
      required final List<ExerciseEntity> recommendedExercises,
      required this.motivationalMessage,
      required final List<DateTime> completedDaysThisWeek,
      required this.totalMinutes,
      required this.totalSessions})
      : _todaySchedule = todaySchedule,
        _recommendedExercises = recommendedExercises,
        _completedDaysThisWeek = completedDaysThisWeek;

  @override
  final UserEntity user;
  @override
  final int streakDays;
  final List<ExerciseEntity> _todaySchedule;
  @override
  List<ExerciseEntity> get todaySchedule {
    if (_todaySchedule is EqualUnmodifiableListView) return _todaySchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todaySchedule);
  }

  @override
  final int completedToday;
  final List<ExerciseEntity> _recommendedExercises;
  @override
  List<ExerciseEntity> get recommendedExercises {
    if (_recommendedExercises is EqualUnmodifiableListView)
      return _recommendedExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedExercises);
  }

  @override
  final MotivationalMessageEntity motivationalMessage;
  final List<DateTime> _completedDaysThisWeek;
  @override
  List<DateTime> get completedDaysThisWeek {
    if (_completedDaysThisWeek is EqualUnmodifiableListView)
      return _completedDaysThisWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedDaysThisWeek);
  }

  @override
  final int totalMinutes;
  @override
  final int totalSessions;

  @override
  String toString() {
    return 'HomeData(user: $user, streakDays: $streakDays, todaySchedule: $todaySchedule, completedToday: $completedToday, recommendedExercises: $recommendedExercises, motivationalMessage: $motivationalMessage, completedDaysThisWeek: $completedDaysThisWeek, totalMinutes: $totalMinutes, totalSessions: $totalSessions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDataImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            const DeepCollectionEquality()
                .equals(other._todaySchedule, _todaySchedule) &&
            (identical(other.completedToday, completedToday) ||
                other.completedToday == completedToday) &&
            const DeepCollectionEquality()
                .equals(other._recommendedExercises, _recommendedExercises) &&
            (identical(other.motivationalMessage, motivationalMessage) ||
                other.motivationalMessage == motivationalMessage) &&
            const DeepCollectionEquality()
                .equals(other._completedDaysThisWeek, _completedDaysThisWeek) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      user,
      streakDays,
      const DeepCollectionEquality().hash(_todaySchedule),
      completedToday,
      const DeepCollectionEquality().hash(_recommendedExercises),
      motivationalMessage,
      const DeepCollectionEquality().hash(_completedDaysThisWeek),
      totalMinutes,
      totalSessions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      __$$HomeDataImplCopyWithImpl<_$HomeDataImpl>(this, _$identity);
}

abstract class _HomeData implements HomeData {
  const factory _HomeData(
      {required final UserEntity user,
      required final int streakDays,
      required final List<ExerciseEntity> todaySchedule,
      required final int completedToday,
      required final List<ExerciseEntity> recommendedExercises,
      required final MotivationalMessageEntity motivationalMessage,
      required final List<DateTime> completedDaysThisWeek,
      required final int totalMinutes,
      required final int totalSessions}) = _$HomeDataImpl;

  @override
  UserEntity get user;
  @override
  int get streakDays;
  @override
  List<ExerciseEntity> get todaySchedule;
  @override
  int get completedToday;
  @override
  List<ExerciseEntity> get recommendedExercises;
  @override
  MotivationalMessageEntity get motivationalMessage;
  @override
  List<DateTime> get completedDaysThisWeek;
  @override
  int get totalMinutes;
  @override
  int get totalSessions;
  @override
  @JsonKey(ignore: true)
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HomeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(HomeData data) loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(HomeData data)? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(HomeData data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeLoading value) loading,
    required TResult Function(HomeLoaded value) loaded,
    required TResult Function(HomeError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeLoading value)? loading,
    TResult? Function(HomeLoaded value)? loaded,
    TResult? Function(HomeError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeLoading value)? loading,
    TResult Function(HomeLoaded value)? loaded,
    TResult Function(HomeError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$HomeLoadingImplCopyWith<$Res> {
  factory _$$HomeLoadingImplCopyWith(
          _$HomeLoadingImpl value, $Res Function(_$HomeLoadingImpl) then) =
      __$$HomeLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeLoadingImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeLoadingImpl>
    implements _$$HomeLoadingImplCopyWith<$Res> {
  __$$HomeLoadingImplCopyWithImpl(
      _$HomeLoadingImpl _value, $Res Function(_$HomeLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HomeLoadingImpl implements HomeLoading {
  const _$HomeLoadingImpl();

  @override
  String toString() {
    return 'HomeState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(HomeData data) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(HomeData data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(HomeData data)? loaded,
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
    required TResult Function(HomeLoading value) loading,
    required TResult Function(HomeLoaded value) loaded,
    required TResult Function(HomeError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeLoading value)? loading,
    TResult? Function(HomeLoaded value)? loaded,
    TResult? Function(HomeError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeLoading value)? loading,
    TResult Function(HomeLoaded value)? loaded,
    TResult Function(HomeError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HomeLoading implements HomeState {
  const factory HomeLoading() = _$HomeLoadingImpl;
}

/// @nodoc
abstract class _$$HomeLoadedImplCopyWith<$Res> {
  factory _$$HomeLoadedImplCopyWith(
          _$HomeLoadedImpl value, $Res Function(_$HomeLoadedImpl) then) =
      __$$HomeLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({HomeData data});

  $HomeDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$HomeLoadedImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeLoadedImpl>
    implements _$$HomeLoadedImplCopyWith<$Res> {
  __$$HomeLoadedImplCopyWithImpl(
      _$HomeLoadedImpl _value, $Res Function(_$HomeLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$HomeLoadedImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as HomeData,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $HomeDataCopyWith<$Res> get data {
    return $HomeDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$HomeLoadedImpl implements HomeLoaded {
  const _$HomeLoadedImpl(this.data);

  @override
  final HomeData data;

  @override
  String toString() {
    return 'HomeState.loaded(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeLoadedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeLoadedImplCopyWith<_$HomeLoadedImpl> get copyWith =>
      __$$HomeLoadedImplCopyWithImpl<_$HomeLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(HomeData data) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(HomeData data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(HomeData data)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeLoading value) loading,
    required TResult Function(HomeLoaded value) loaded,
    required TResult Function(HomeError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeLoading value)? loading,
    TResult? Function(HomeLoaded value)? loaded,
    TResult? Function(HomeError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeLoading value)? loading,
    TResult Function(HomeLoaded value)? loaded,
    TResult Function(HomeError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class HomeLoaded implements HomeState {
  const factory HomeLoaded(final HomeData data) = _$HomeLoadedImpl;

  HomeData get data;
  @JsonKey(ignore: true)
  _$$HomeLoadedImplCopyWith<_$HomeLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HomeErrorImplCopyWith<$Res> {
  factory _$$HomeErrorImplCopyWith(
          _$HomeErrorImpl value, $Res Function(_$HomeErrorImpl) then) =
      __$$HomeErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$HomeErrorImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeErrorImpl>
    implements _$$HomeErrorImplCopyWith<$Res> {
  __$$HomeErrorImplCopyWithImpl(
      _$HomeErrorImpl _value, $Res Function(_$HomeErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$HomeErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HomeErrorImpl implements HomeError {
  const _$HomeErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'HomeState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeErrorImplCopyWith<_$HomeErrorImpl> get copyWith =>
      __$$HomeErrorImplCopyWithImpl<_$HomeErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(HomeData data) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(HomeData data)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(HomeData data)? loaded,
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
    required TResult Function(HomeLoading value) loading,
    required TResult Function(HomeLoaded value) loaded,
    required TResult Function(HomeError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeLoading value)? loading,
    TResult? Function(HomeLoaded value)? loaded,
    TResult? Function(HomeError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeLoading value)? loading,
    TResult Function(HomeLoaded value)? loaded,
    TResult Function(HomeError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class HomeError implements HomeState {
  const factory HomeError(final String message) = _$HomeErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$HomeErrorImplCopyWith<_$HomeErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
