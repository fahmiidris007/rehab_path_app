// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsData {
  AppThemeMode get themeMode => throw _privateConstructorUsedError;
  AppLocale get locale => throw _privateConstructorUsedError;
  FontSizeLevel get fontSizeLevel => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsDataCopyWith<SettingsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsDataCopyWith<$Res> {
  factory $SettingsDataCopyWith(
          SettingsData value, $Res Function(SettingsData) then) =
      _$SettingsDataCopyWithImpl<$Res, SettingsData>;
  @useResult
  $Res call(
      {AppThemeMode themeMode,
      AppLocale locale,
      FontSizeLevel fontSizeLevel,
      bool notificationsEnabled});
}

/// @nodoc
class _$SettingsDataCopyWithImpl<$Res, $Val extends SettingsData>
    implements $SettingsDataCopyWith<$Res> {
  _$SettingsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? locale = null,
    Object? fontSizeLevel = null,
    Object? notificationsEnabled = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as AppLocale,
      fontSizeLevel: null == fontSizeLevel
          ? _value.fontSizeLevel
          : fontSizeLevel // ignore: cast_nullable_to_non_nullable
              as FontSizeLevel,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsDataImplCopyWith<$Res>
    implements $SettingsDataCopyWith<$Res> {
  factory _$$SettingsDataImplCopyWith(
          _$SettingsDataImpl value, $Res Function(_$SettingsDataImpl) then) =
      __$$SettingsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AppThemeMode themeMode,
      AppLocale locale,
      FontSizeLevel fontSizeLevel,
      bool notificationsEnabled});
}

/// @nodoc
class __$$SettingsDataImplCopyWithImpl<$Res>
    extends _$SettingsDataCopyWithImpl<$Res, _$SettingsDataImpl>
    implements _$$SettingsDataImplCopyWith<$Res> {
  __$$SettingsDataImplCopyWithImpl(
      _$SettingsDataImpl _value, $Res Function(_$SettingsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? locale = null,
    Object? fontSizeLevel = null,
    Object? notificationsEnabled = null,
  }) {
    return _then(_$SettingsDataImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as AppLocale,
      fontSizeLevel: null == fontSizeLevel
          ? _value.fontSizeLevel
          : fontSizeLevel // ignore: cast_nullable_to_non_nullable
              as FontSizeLevel,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SettingsDataImpl implements _SettingsData {
  const _$SettingsDataImpl(
      {required this.themeMode,
      required this.locale,
      required this.fontSizeLevel,
      required this.notificationsEnabled});

  @override
  final AppThemeMode themeMode;
  @override
  final AppLocale locale;
  @override
  final FontSizeLevel fontSizeLevel;
  @override
  final bool notificationsEnabled;

  @override
  String toString() {
    return 'SettingsData(themeMode: $themeMode, locale: $locale, fontSizeLevel: $fontSizeLevel, notificationsEnabled: $notificationsEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsDataImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.fontSizeLevel, fontSizeLevel) ||
                other.fontSizeLevel == fontSizeLevel) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, themeMode, locale, fontSizeLevel, notificationsEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsDataImplCopyWith<_$SettingsDataImpl> get copyWith =>
      __$$SettingsDataImplCopyWithImpl<_$SettingsDataImpl>(this, _$identity);
}

abstract class _SettingsData implements SettingsData {
  const factory _SettingsData(
      {required final AppThemeMode themeMode,
      required final AppLocale locale,
      required final FontSizeLevel fontSizeLevel,
      required final bool notificationsEnabled}) = _$SettingsDataImpl;

  @override
  AppThemeMode get themeMode;
  @override
  AppLocale get locale;
  @override
  FontSizeLevel get fontSizeLevel;
  @override
  bool get notificationsEnabled;
  @override
  @JsonKey(ignore: true)
  _$$SettingsDataImplCopyWith<_$SettingsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SettingsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SettingsData data) loaded,
    required TResult Function(String message) error,
    required TResult Function(SettingsData data) notificationPermissionDenied,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SettingsData data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(SettingsData data)? notificationPermissionDenied,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SettingsData data)? loaded,
    TResult Function(String message)? error,
    TResult Function(SettingsData data)? notificationPermissionDenied,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SettingsLoading value) loading,
    required TResult Function(SettingsLoaded value) loaded,
    required TResult Function(SettingsError value) error,
    required TResult Function(SettingsNotificationPermissionDenied value)
        notificationPermissionDenied,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsLoading value)? loading,
    TResult? Function(SettingsLoaded value)? loaded,
    TResult? Function(SettingsError value)? error,
    TResult? Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsLoading value)? loading,
    TResult Function(SettingsLoaded value)? loaded,
    TResult Function(SettingsError value)? error,
    TResult Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
          SettingsState value, $Res Function(SettingsState) then) =
      _$SettingsStateCopyWithImpl<$Res, SettingsState>;
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SettingsLoadingImplCopyWith<$Res> {
  factory _$$SettingsLoadingImplCopyWith(_$SettingsLoadingImpl value,
          $Res Function(_$SettingsLoadingImpl) then) =
      __$$SettingsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SettingsLoadingImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsLoadingImpl>
    implements _$$SettingsLoadingImplCopyWith<$Res> {
  __$$SettingsLoadingImplCopyWithImpl(
      _$SettingsLoadingImpl _value, $Res Function(_$SettingsLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SettingsLoadingImpl implements SettingsLoading {
  const _$SettingsLoadingImpl();

  @override
  String toString() {
    return 'SettingsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SettingsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SettingsData data) loaded,
    required TResult Function(String message) error,
    required TResult Function(SettingsData data) notificationPermissionDenied,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SettingsData data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(SettingsData data)? notificationPermissionDenied,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SettingsData data)? loaded,
    TResult Function(String message)? error,
    TResult Function(SettingsData data)? notificationPermissionDenied,
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
    required TResult Function(SettingsLoading value) loading,
    required TResult Function(SettingsLoaded value) loaded,
    required TResult Function(SettingsError value) error,
    required TResult Function(SettingsNotificationPermissionDenied value)
        notificationPermissionDenied,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsLoading value)? loading,
    TResult? Function(SettingsLoaded value)? loaded,
    TResult? Function(SettingsError value)? error,
    TResult? Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsLoading value)? loading,
    TResult Function(SettingsLoaded value)? loaded,
    TResult Function(SettingsError value)? error,
    TResult Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SettingsLoading implements SettingsState {
  const factory SettingsLoading() = _$SettingsLoadingImpl;
}

/// @nodoc
abstract class _$$SettingsLoadedImplCopyWith<$Res> {
  factory _$$SettingsLoadedImplCopyWith(_$SettingsLoadedImpl value,
          $Res Function(_$SettingsLoadedImpl) then) =
      __$$SettingsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SettingsData data});

  $SettingsDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$SettingsLoadedImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsLoadedImpl>
    implements _$$SettingsLoadedImplCopyWith<$Res> {
  __$$SettingsLoadedImplCopyWithImpl(
      _$SettingsLoadedImpl _value, $Res Function(_$SettingsLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SettingsLoadedImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SettingsData,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingsDataCopyWith<$Res> get data {
    return $SettingsDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$SettingsLoadedImpl implements SettingsLoaded {
  const _$SettingsLoadedImpl(this.data);

  @override
  final SettingsData data;

  @override
  String toString() {
    return 'SettingsState.loaded(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsLoadedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsLoadedImplCopyWith<_$SettingsLoadedImpl> get copyWith =>
      __$$SettingsLoadedImplCopyWithImpl<_$SettingsLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SettingsData data) loaded,
    required TResult Function(String message) error,
    required TResult Function(SettingsData data) notificationPermissionDenied,
  }) {
    return loaded(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SettingsData data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(SettingsData data)? notificationPermissionDenied,
  }) {
    return loaded?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SettingsData data)? loaded,
    TResult Function(String message)? error,
    TResult Function(SettingsData data)? notificationPermissionDenied,
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
    required TResult Function(SettingsLoading value) loading,
    required TResult Function(SettingsLoaded value) loaded,
    required TResult Function(SettingsError value) error,
    required TResult Function(SettingsNotificationPermissionDenied value)
        notificationPermissionDenied,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsLoading value)? loading,
    TResult? Function(SettingsLoaded value)? loaded,
    TResult? Function(SettingsError value)? error,
    TResult? Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsLoading value)? loading,
    TResult Function(SettingsLoaded value)? loaded,
    TResult Function(SettingsError value)? error,
    TResult Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SettingsLoaded implements SettingsState {
  const factory SettingsLoaded(final SettingsData data) = _$SettingsLoadedImpl;

  SettingsData get data;
  @JsonKey(ignore: true)
  _$$SettingsLoadedImplCopyWith<_$SettingsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SettingsErrorImplCopyWith<$Res> {
  factory _$$SettingsErrorImplCopyWith(
          _$SettingsErrorImpl value, $Res Function(_$SettingsErrorImpl) then) =
      __$$SettingsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SettingsErrorImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsErrorImpl>
    implements _$$SettingsErrorImplCopyWith<$Res> {
  __$$SettingsErrorImplCopyWithImpl(
      _$SettingsErrorImpl _value, $Res Function(_$SettingsErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SettingsErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SettingsErrorImpl implements SettingsError {
  const _$SettingsErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SettingsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsErrorImplCopyWith<_$SettingsErrorImpl> get copyWith =>
      __$$SettingsErrorImplCopyWithImpl<_$SettingsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SettingsData data) loaded,
    required TResult Function(String message) error,
    required TResult Function(SettingsData data) notificationPermissionDenied,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SettingsData data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(SettingsData data)? notificationPermissionDenied,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SettingsData data)? loaded,
    TResult Function(String message)? error,
    TResult Function(SettingsData data)? notificationPermissionDenied,
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
    required TResult Function(SettingsLoading value) loading,
    required TResult Function(SettingsLoaded value) loaded,
    required TResult Function(SettingsError value) error,
    required TResult Function(SettingsNotificationPermissionDenied value)
        notificationPermissionDenied,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsLoading value)? loading,
    TResult? Function(SettingsLoaded value)? loaded,
    TResult? Function(SettingsError value)? error,
    TResult? Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsLoading value)? loading,
    TResult Function(SettingsLoaded value)? loaded,
    TResult Function(SettingsError value)? error,
    TResult Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SettingsError implements SettingsState {
  const factory SettingsError(final String message) = _$SettingsErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$SettingsErrorImplCopyWith<_$SettingsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SettingsNotificationPermissionDeniedImplCopyWith<$Res> {
  factory _$$SettingsNotificationPermissionDeniedImplCopyWith(
          _$SettingsNotificationPermissionDeniedImpl value,
          $Res Function(_$SettingsNotificationPermissionDeniedImpl) then) =
      __$$SettingsNotificationPermissionDeniedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SettingsData data});

  $SettingsDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$SettingsNotificationPermissionDeniedImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res,
        _$SettingsNotificationPermissionDeniedImpl>
    implements _$$SettingsNotificationPermissionDeniedImplCopyWith<$Res> {
  __$$SettingsNotificationPermissionDeniedImplCopyWithImpl(
      _$SettingsNotificationPermissionDeniedImpl _value,
      $Res Function(_$SettingsNotificationPermissionDeniedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SettingsNotificationPermissionDeniedImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SettingsData,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingsDataCopyWith<$Res> get data {
    return $SettingsDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$SettingsNotificationPermissionDeniedImpl
    implements SettingsNotificationPermissionDenied {
  const _$SettingsNotificationPermissionDeniedImpl(this.data);

  @override
  final SettingsData data;

  @override
  String toString() {
    return 'SettingsState.notificationPermissionDenied(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsNotificationPermissionDeniedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsNotificationPermissionDeniedImplCopyWith<
          _$SettingsNotificationPermissionDeniedImpl>
      get copyWith => __$$SettingsNotificationPermissionDeniedImplCopyWithImpl<
          _$SettingsNotificationPermissionDeniedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(SettingsData data) loaded,
    required TResult Function(String message) error,
    required TResult Function(SettingsData data) notificationPermissionDenied,
  }) {
    return notificationPermissionDenied(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(SettingsData data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(SettingsData data)? notificationPermissionDenied,
  }) {
    return notificationPermissionDenied?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(SettingsData data)? loaded,
    TResult Function(String message)? error,
    TResult Function(SettingsData data)? notificationPermissionDenied,
    required TResult orElse(),
  }) {
    if (notificationPermissionDenied != null) {
      return notificationPermissionDenied(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SettingsLoading value) loading,
    required TResult Function(SettingsLoaded value) loaded,
    required TResult Function(SettingsError value) error,
    required TResult Function(SettingsNotificationPermissionDenied value)
        notificationPermissionDenied,
  }) {
    return notificationPermissionDenied(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SettingsLoading value)? loading,
    TResult? Function(SettingsLoaded value)? loaded,
    TResult? Function(SettingsError value)? error,
    TResult? Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
  }) {
    return notificationPermissionDenied?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SettingsLoading value)? loading,
    TResult Function(SettingsLoaded value)? loaded,
    TResult Function(SettingsError value)? error,
    TResult Function(SettingsNotificationPermissionDenied value)?
        notificationPermissionDenied,
    required TResult orElse(),
  }) {
    if (notificationPermissionDenied != null) {
      return notificationPermissionDenied(this);
    }
    return orElse();
  }
}

abstract class SettingsNotificationPermissionDenied implements SettingsState {
  const factory SettingsNotificationPermissionDenied(final SettingsData data) =
      _$SettingsNotificationPermissionDeniedImpl;

  SettingsData get data;
  @JsonKey(ignore: true)
  _$$SettingsNotificationPermissionDeniedImplCopyWith<
          _$SettingsNotificationPermissionDeniedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
