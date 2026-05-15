import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// Base class for all use cases.
///
/// [T] is the return type on success.
/// [Params] is the input parameter type.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Used as the [Params] type for use cases that require no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
