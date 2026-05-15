import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  const factory Failure.validation({
    required String message,
    String? field,
  }) = ValidationFailure;

  const factory Failure.unexpected({
    required String message,
  }) = UnexpectedFailure;
}
