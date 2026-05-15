// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OnboardingState {
  int get currentStep => throw _privateConstructorUsedError;
  OnboardingProfileEntity? get partialProfile =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get isComplete => throw _privateConstructorUsedError;
  ProgramLevel? get computedLevel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OnboardingStateCopyWith<OnboardingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<$Res> {
  factory $OnboardingStateCopyWith(
          OnboardingState value, $Res Function(OnboardingState) then) =
      _$OnboardingStateCopyWithImpl<$Res, OnboardingState>;
  @useResult
  $Res call(
      {int currentStep,
      OnboardingProfileEntity? partialProfile,
      bool isLoading,
      String? errorMessage,
      bool isComplete,
      ProgramLevel? computedLevel});

  $OnboardingProfileEntityCopyWith<$Res>? get partialProfile;
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res, $Val extends OnboardingState>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? partialProfile = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? isComplete = null,
    Object? computedLevel = freezed,
  }) {
    return _then(_value.copyWith(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      partialProfile: freezed == partialProfile
          ? _value.partialProfile
          : partialProfile // ignore: cast_nullable_to_non_nullable
              as OnboardingProfileEntity?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      computedLevel: freezed == computedLevel
          ? _value.computedLevel
          : computedLevel // ignore: cast_nullable_to_non_nullable
              as ProgramLevel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OnboardingProfileEntityCopyWith<$Res>? get partialProfile {
    if (_value.partialProfile == null) {
      return null;
    }

    return $OnboardingProfileEntityCopyWith<$Res>(_value.partialProfile!,
        (value) {
      return _then(_value.copyWith(partialProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingStateImplCopyWith(_$OnboardingStateImpl value,
          $Res Function(_$OnboardingStateImpl) then) =
      __$$OnboardingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentStep,
      OnboardingProfileEntity? partialProfile,
      bool isLoading,
      String? errorMessage,
      bool isComplete,
      ProgramLevel? computedLevel});

  @override
  $OnboardingProfileEntityCopyWith<$Res>? get partialProfile;
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingStateImpl>
    implements _$$OnboardingStateImplCopyWith<$Res> {
  __$$OnboardingStateImplCopyWithImpl(
      _$OnboardingStateImpl _value, $Res Function(_$OnboardingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? partialProfile = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? isComplete = null,
    Object? computedLevel = freezed,
  }) {
    return _then(_$OnboardingStateImpl(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      partialProfile: freezed == partialProfile
          ? _value.partialProfile
          : partialProfile // ignore: cast_nullable_to_non_nullable
              as OnboardingProfileEntity?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      computedLevel: freezed == computedLevel
          ? _value.computedLevel
          : computedLevel // ignore: cast_nullable_to_non_nullable
              as ProgramLevel?,
    ));
  }
}

/// @nodoc

class _$OnboardingStateImpl implements _OnboardingState {
  const _$OnboardingStateImpl(
      {this.currentStep = 1,
      this.partialProfile,
      this.isLoading = false,
      this.errorMessage,
      this.isComplete = false,
      this.computedLevel});

  @override
  @JsonKey()
  final int currentStep;
  @override
  final OnboardingProfileEntity? partialProfile;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool isComplete;
  @override
  final ProgramLevel? computedLevel;

  @override
  String toString() {
    return 'OnboardingState(currentStep: $currentStep, partialProfile: $partialProfile, isLoading: $isLoading, errorMessage: $errorMessage, isComplete: $isComplete, computedLevel: $computedLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.partialProfile, partialProfile) ||
                other.partialProfile == partialProfile) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.computedLevel, computedLevel) ||
                other.computedLevel == computedLevel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentStep, partialProfile,
      isLoading, errorMessage, isComplete, computedLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      __$$OnboardingStateImplCopyWithImpl<_$OnboardingStateImpl>(
          this, _$identity);
}

abstract class _OnboardingState implements OnboardingState {
  const factory _OnboardingState(
      {final int currentStep,
      final OnboardingProfileEntity? partialProfile,
      final bool isLoading,
      final String? errorMessage,
      final bool isComplete,
      final ProgramLevel? computedLevel}) = _$OnboardingStateImpl;

  @override
  int get currentStep;
  @override
  OnboardingProfileEntity? get partialProfile;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  bool get isComplete;
  @override
  ProgramLevel? get computedLevel;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
